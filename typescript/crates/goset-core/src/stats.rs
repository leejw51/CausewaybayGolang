//! XP, levels and badges: the part of the game that makes a right answer feel
//! like more than a green line. Ported from `src/stats.lua`.
//!
//! Everything here is derived from play and saved as one record, which the
//! browser keeps in `localStorage` where LÖVE kept `~/.causewaybaygo/stats.jsonl`.
//! The numbers are the desktop numbers, so a level earned on one is the same
//! level on the other.

use serde::{Deserialize, Serialize};

/// XP per event.
pub mod xp {
    pub const RIGHT: i64 = 10;
    /// Extra per step of streak beyond the first.
    pub const COMBO: i64 = 3;
    pub const COMBO_CAP: i64 = 30;
    /// Answered within [`FAST`] seconds of seeing the blank.
    pub const FAST_BONUS: i64 = 5;
    pub const CLEAR: i64 = 25;
    /// A street cleared with no miss and no revealed answer.
    pub const PERFECT: i64 = 50;
    pub const STAMP: i64 = 200;
    pub const BADGE: i64 = 40;
}

pub const FAST: f32 = 8.0;

/// Badge ids in the order they are listed, each with its i18n key.
pub const BADGES: &[(&str, &str)] = &[
    ("first_clear", "badge_first_clear"),
    ("combo5", "badge_combo5"),
    ("combo10", "badge_combo10"),
    ("perfect", "badge_perfect"),
    ("perfect5", "badge_perfect5"),
    ("fast10", "badge_fast10"),
    ("right100", "badge_right100"),
    ("stamp", "badge_stamp"),
    ("trio", "badge_trio"),
    ("polyglot", "badge_polyglot"),
    ("bigo", "badge_bigo"),
    ("share", "badge_share"),
    ("night", "badge_night"),
    ("early", "badge_early"),
];

pub fn badge_key(id: &str) -> Option<&'static str> {
    BADGES.iter().find(|(b, _)| *b == id).map(|(_, k)| *k)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct Stats {
    pub xp: i64,
    pub level: i64,
    pub right: i64,
    pub wrong: i64,
    pub fast: i64,
    pub perfects: i64,
    pub clears: i64,
    pub stamps: i64,
    pub copies: i64,
    pub exports: i64,
    pub best_streak: i64,
    /// Ordered list of badge ids, oldest first.
    pub badges: Vec<String>,
}

impl Default for Stats {
    fn default() -> Self {
        Stats {
            xp: 0,
            level: 1,
            right: 0,
            wrong: 0,
            fast: 0,
            perfects: 0,
            clears: 0,
            stamps: 0,
            copies: 0,
            exports: 0,
            best_streak: 0,
            badges: Vec::new(),
        }
    }
}

/// What an event paid: XP, whether it was FAST, any badges it unlocked, and
/// the new level when one was crossed.
#[derive(Debug, Clone, Default, Serialize)]
pub struct Reward {
    pub xp: i64,
    pub fast: bool,
    pub badges: Vec<String>,
    pub level: Option<i64>,
}

impl Reward {
    pub fn is_empty(&self) -> bool {
        self.xp == 0 && self.badges.is_empty() && self.level.is_none()
    }
}

/// Total XP needed to stand on level `n`. Level 2 at 100, 3 at 300, 4 at 600:
/// the triangular numbers times 100.
pub fn xp_for(level: i64) -> i64 {
    let level = level.max(1);
    50 * (level - 1) * level
}

pub fn level_for(xp: i64) -> i64 {
    let mut lv = 1;
    while xp_for(lv + 1) <= xp {
        lv += 1;
    }
    lv
}

impl Stats {
    pub fn has(&self, id: &str) -> bool {
        self.badges.iter().any(|b| b == id)
    }

    /// XP into the current level, and the size of the level, for a bar.
    pub fn progress(&self) -> (i64, i64) {
        let lo = xp_for(self.level);
        let hi = xp_for(self.level + 1);
        (self.xp - lo, hi - lo)
    }

    /// A loaded record is trusted for its counters but not for its level: the
    /// level follows from the XP, so a hand-edited save cannot mint one.
    pub fn normalise(&mut self) {
        self.badges.retain(|id| badge_key(id).is_some());
        self.badges.dedup();
        self.level = level_for(self.xp);
    }

    fn gain(&mut self, n: i64, out: &mut Reward) {
        self.xp += n;
        out.xp += n;
        let lv = level_for(self.xp);
        if lv > self.level {
            self.level = lv;
            out.level = Some(lv);
        }
    }

    fn award(&mut self, id: &str, out: &mut Reward) -> bool {
        if self.has(id) || badge_key(id).is_none() {
            return false;
        }
        self.badges.push(id.to_string());
        out.badges.push(id.to_string());
        self.gain(xp::BADGE, out);
        true
    }

    /// Badges that depend on the wall clock. `hour` is the player's local
    /// hour: wasm has no clock of its own, so the shell hands it over.
    fn clock_badges(&mut self, hour: u32, out: &mut Reward) {
        if !(5..23).contains(&hour) {
            self.award("night", out);
        } else if (5..7).contains(&hour) {
            self.award("early", out);
        }
    }

    /// One attempt at a blank. `secs` is the time since the blank was shown.
    pub fn on_answer(&mut self, ok: bool, streak: i64, secs: f32, hour: u32) -> Reward {
        let mut out = Reward::default();
        if !ok {
            self.wrong += 1;
            return out;
        }
        self.right += 1;
        self.gain(xp::RIGHT, &mut out);
        if streak > self.best_streak {
            self.best_streak = streak;
        }
        if streak >= 2 {
            self.gain(xp::COMBO_CAP.min(xp::COMBO * (streak - 1)), &mut out);
        }
        if secs <= FAST {
            self.fast += 1;
            out.fast = true;
            self.gain(xp::FAST_BONUS, &mut out);
        }
        if streak >= 5 {
            self.award("combo5", &mut out);
        }
        if streak >= 10 {
            self.award("combo10", &mut out);
        }
        if self.fast >= 10 {
            self.award("fast10", &mut out);
        }
        if self.right >= 100 {
            self.award("right100", &mut out);
        }
        self.clock_badges(hour, &mut out);
        out
    }

    /// A street CLEAR. `tracks` is how many language tracks have a clear at
    /// all, and `polyglot` whether one station label is clear in three of them
    /// — RECURSE in Go, Rust and Python is the same round three times.
    pub fn on_clear(&mut self, perfect: bool, tracks: usize, polyglot: bool) -> Reward {
        let mut out = Reward::default();
        self.clears += 1;
        self.gain(xp::CLEAR, &mut out);
        self.award("first_clear", &mut out);
        if perfect {
            self.perfects += 1;
            self.gain(xp::PERFECT, &mut out);
            self.award("perfect", &mut out);
            if self.perfects >= 5 {
                self.award("perfect5", &mut out);
            }
        }
        if tracks >= 3 {
            self.award("trio", &mut out);
        }
        if polyglot {
            self.award("polyglot", &mut out);
        }
        out
    }

    /// A quest's stamp. `bigo` is set when the quest that ended was a BIG O one.
    pub fn on_stamp(&mut self, bigo: bool) -> Reward {
        let mut out = Reward::default();
        self.stamps += 1;
        self.gain(xp::STAMP, &mut out);
        self.award("stamp", &mut out);
        if bigo {
            self.award("bigo", &mut out);
        }
        out
    }

    pub fn on_share(&mut self, copy: bool) -> Reward {
        let mut out = Reward::default();
        if copy {
            self.copies += 1;
        } else {
            self.exports += 1;
        }
        self.award("share", &mut out);
        out
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn levels_sit_on_the_triangular_numbers() {
        assert_eq!(xp_for(1), 0);
        assert_eq!(xp_for(2), 100);
        assert_eq!(xp_for(3), 300);
        assert_eq!(xp_for(4), 600);
        assert_eq!(level_for(99), 1);
        assert_eq!(level_for(100), 2);
        assert_eq!(level_for(299), 2);
    }

    #[test]
    fn a_right_answer_pays_and_a_wrong_one_only_counts() {
        let mut s = Stats::default();
        let r = s.on_answer(true, 1, 30.0, 12);
        assert_eq!(r.xp, xp::RIGHT);
        assert!(!r.fast);
        assert_eq!(s.right, 1);

        let r = s.on_answer(false, 0, 1.0, 12);
        assert!(r.is_empty());
        assert_eq!(s.wrong, 1);
    }

    #[test]
    fn a_combo_and_a_fast_answer_both_pay_extra() {
        let mut s = Stats::default();
        let r = s.on_answer(true, 3, 2.0, 12);
        // right + combo (2 steps past the first) + fast
        assert_eq!(r.xp, xp::RIGHT + xp::COMBO * 2 + xp::FAST_BONUS);
        assert!(r.fast);
        assert_eq!(s.best_streak, 3);
    }

    #[test]
    fn the_combo_bonus_is_capped() {
        let mut s = Stats::default();
        // A streak of a hundred also unlocks COMBO x5 and COMBO x10, and a
        // badge pays too: the cap is on the combo bonus, not on the answer.
        let r = s.on_answer(true, 100, 60.0, 12);
        assert_eq!(r.badges, vec!["combo5".to_string(), "combo10".to_string()]);
        assert_eq!(r.xp, xp::RIGHT + xp::COMBO_CAP + xp::BADGE * 2);
    }

    #[test]
    fn a_badge_is_awarded_once_and_pays_once() {
        let mut s = Stats::default();
        let first = s.on_clear(true, 1, false);
        assert!(first.badges.contains(&"first_clear".to_string()));
        assert!(first.badges.contains(&"perfect".to_string()));
        let second = s.on_clear(true, 1, false);
        assert!(second.badges.is_empty());
        assert_eq!(second.xp, xp::CLEAR + xp::PERFECT);
    }

    #[test]
    fn crossing_a_level_is_reported_once() {
        let mut s = Stats::default();
        let mut crossings = 0;
        for _ in 0..12 {
            if s.on_answer(true, 1, 60.0, 12).level.is_some() {
                crossings += 1;
            }
        }
        assert_eq!(s.xp, 120);
        assert_eq!(s.level, 2);
        assert_eq!(crossings, 1);
    }

    #[test]
    fn the_night_and_early_badges_watch_the_clock() {
        let mut s = Stats::default();
        s.on_answer(true, 1, 60.0, 2);
        assert!(s.has("night"));
        let mut s = Stats::default();
        s.on_answer(true, 1, 60.0, 6);
        assert!(s.has("early"));
        let mut s = Stats::default();
        s.on_answer(true, 1, 60.0, 14);
        assert!(!s.has("night") && !s.has("early"));
    }

    #[test]
    fn a_loaded_record_cannot_mint_a_level_or_an_unknown_badge() {
        let mut s = Stats {
            xp: 100,
            level: 99,
            badges: vec!["nope".into()],
            ..Stats::default()
        };
        s.normalise();
        assert_eq!(s.level, 2);
        assert!(s.badges.is_empty());
    }
}

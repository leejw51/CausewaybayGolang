//! The state machine, ported from `src/game.lua`.
//!
//!   title  ->  map  ->  play  ->  (next street ...)  ->  win
//!            ^  ^        |
//!            |  +--------+   ESC / the MAP button
//!            +-- ESC on the map returns to where it came from
//!
//! Play is a quiz. One blank `___` per stage, the player types the answer.
//! HINT is two-tier: the first press a nudge, the second the answer. A wrong
//! attempt opens the nudge; thirty seconds of silence opens it too. A street
//! is CLEAR when every one of its blanks is answered, and the quest's stamp
//! comes when every street is.
//!
//! Nothing here draws or plays anything: side effects leave as [`Event`]s, so
//! a whole quest can be played in a test with no browser attached.

use crate::answer::{accepts, fill_blank};
use crate::data::{Doc, MapDef, Quest, Stage};
use crate::event::{Event, Space};
use crate::i18n;
use crate::stats::{Reward, Stats};
use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

/// Seconds of silence before the nudge opens itself.
const HINT_WAIT: f32 = 30.0;
/// The longest answer the prompt will hold, in characters.
const MAX_INPUT: usize = 40;

/// AUTO: the game plays itself, pausing so the reader can follow (seconds).
mod auto {
    pub const READ: f32 = 1.4;
    pub const HINT: f32 = 1.4;
    pub const KEY: f32 = 0.11;
    pub const PAUSE: f32 = 0.7;
    pub const LEARN: f32 = 1.8;
    pub const CLEAR: f32 = 2.4;
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum State {
    Title,
    Map,
    Play,
    Win,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum AutoPhase {
    Read,
    Hint,
    Type,
    Learn,
}

/// Where the title screen's "continue" picks up, and where the map opens.
#[derive(Debug, Clone, Copy, Serialize)]
pub struct Saved {
    pub quest: usize,
    pub step: usize,
    pub stage: usize,
    pub solved: bool,
}

/// The record that outlives the tab. The browser keeps it in `localStorage`
/// where LÖVE kept the last line of `~/.causewaybaygo/progress.jsonl`; the
/// fields are the fields of that line, so the two are the same save.
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
#[serde(default)]
pub struct Progress {
    pub quest: usize,
    pub step: usize,
    pub stage: usize,
    pub solved: bool,
    pub cleared: Vec<String>,
    pub lang: Option<String>,
}

pub struct Game {
    pub doc: Doc,
    pub lang: String,
    pub state: State,

    /// Seconds since boot. Only the shell's animations really need it; the
    /// rules use it for the blank's FAST window and the idle nudge.
    pub t: f32,
    /// The viewport, in the virtual pixels the layout works in. The camera is
    /// the only rule that cares how wide the window is.
    pub w: f32,

    pub quest: usize,
    pub step: usize,
    pub stage: usize,

    pub input: String,
    /// Blanks answered on this street, by stage index.
    done: Vec<bool>,
    pub solved: bool,
    /// 0 none, 1 nudge, 2 answer.
    pub hint_level: u8,
    hint_auto: bool,
    /// An i18n key, or the stage's own "why" text once it is answered.
    pub msg: Msg,
    pub streak: i64,
    /// Wrong answers plus revealed answers on this street.
    pub misses: i64,
    pub perfect: bool,
    /// Seconds the current blank has been on screen (the FAST bonus).
    blank_t: f32,
    idle: f32,

    pub player_x: f32,
    pub player_facing: f32,
    pub player_walk: bool,
    pub cam: f32,
    held_left: bool,
    held_right: bool,

    pub cleared: BTreeSet<String>,
    pub map_cursor: usize,
    pub map_from: State,
    /// The quest last visited in each track, so TAB returns there.
    track_quest: Vec<(String, usize)>,
    pub saved: Option<Saved>,

    pub auto: bool,
    auto_phase: AutoPhase,
    auto_t: f32,
    auto_chars: Vec<char>,

    pub sheet: bool,
    pub share_scope: String,

    pub stats: Stats,
    /// The player's local hour, for the NIGHT OWL and EARLY BIRD badges. wasm
    /// has no clock of its own, so the shell hands it over.
    pub hour: u32,

    events: Vec<Event>,
    /// Bumped whenever anything the renderer reads has changed, so the shell
    /// can rebuild its view once per change instead of once per frame.
    version: u64,
}

/// The feedback line under the speaker's name. It follows a language switch,
/// so it is stored as what to look up rather than as looked-up text.
#[derive(Debug, Clone, PartialEq)]
pub enum Msg {
    None,
    /// A UI string by key: `msg_empty`, `msg_wrong`.
    Key(&'static str),
    /// The stage's own "why this is the answer" line.
    StageOk {
        quest: usize,
        step: usize,
        stage: usize,
    },
}

impl Game {
    pub fn new(doc: Doc) -> Game {
        let mut g = Game {
            doc,
            lang: "en".into(),
            state: State::Title,
            t: 0.0,
            w: 1280.0,
            quest: 0,
            step: 0,
            stage: 0,
            input: String::new(),
            done: Vec::new(),
            solved: false,
            hint_level: 0,
            hint_auto: false,
            msg: Msg::None,
            streak: 0,
            misses: 0,
            perfect: false,
            blank_t: 0.0,
            idle: 0.0,
            player_x: 200.0,
            player_facing: 1.0,
            player_walk: false,
            cam: 0.0,
            held_left: false,
            held_right: false,
            cleared: BTreeSet::new(),
            map_cursor: 0,
            map_from: State::Title,
            track_quest: Vec::new(),
            saved: None,
            auto: false,
            auto_phase: AutoPhase::Read,
            auto_t: 0.0,
            auto_chars: Vec::new(),
            sheet: false,
            share_scope: "street".into(),
            stats: Stats::default(),
            hour: 12,
            events: Vec::new(),
            version: 1,
        };
        g.load_map(0);
        g.state = State::Title;
        g
    }

    // ------------------------------------------------------------ shorthands

    pub fn quest_def(&self) -> &Quest {
        &self.doc.quests[self.quest]
    }

    pub fn maps(&self) -> &[MapDef] {
        &self.doc.quests[self.quest].maps
    }

    pub fn map(&self) -> &MapDef {
        &self.maps()[self.step.min(self.maps().len() - 1)]
    }

    pub fn current_stage(&self) -> &Stage {
        let m = self.map();
        &m.stages[self.stage.min(m.stages.len() - 1)]
    }

    pub fn track(&self) -> &str {
        &self.doc.quests[self.quest].track
    }

    pub fn version(&self) -> u64 {
        self.version
    }

    fn touch(&mut self) {
        self.version += 1;
    }

    fn emit(&mut self, e: Event) {
        self.events.push(e);
    }

    fn sfx(&mut self, name: &'static str) {
        self.emit(Event::Sfx { name, pitch: 1.0 });
    }

    pub fn drain_events(&mut self) -> Vec<Event> {
        std::mem::take(&mut self.events)
    }

    pub fn t(&self, key: &str) -> String {
        i18n::t(&self.doc, key, &self.lang)
    }

    pub fn tf(&self, key: &str, args: &[String]) -> String {
        i18n::tf(&self.doc, key, &self.lang, args)
    }

    pub fn pick(&self, v: &crate::data::Loc) -> String {
        i18n::pick(&self.doc, v, &self.lang)
    }

    pub fn set_lang(&mut self, code: &str) {
        if self.doc.lang_names.contains_key(code) {
            self.lang = code.to_string();
            self.touch();
        }
    }

    pub fn cycle_lang(&mut self) {
        self.lang = i18n::cycle(&self.doc, &self.lang);
        self.touch();
    }

    pub fn set_viewport(&mut self, w: f32) {
        self.w = w.max(320.0);
    }

    pub fn set_held(&mut self, left: bool, right: bool) {
        self.held_left = left;
        self.held_right = right;
    }

    // -------------------------------------------------------------- progress

    /// Every CLEAR street of every quest, in game order, for the save.
    pub fn cleared_ids(&self) -> Vec<String> {
        let mut out = Vec::new();
        for quest in &self.doc.quests {
            for m in &quest.maps {
                if self.cleared.contains(&m.id) {
                    out.push(m.id.clone());
                }
            }
        }
        out
    }

    pub fn cleared_count(&self, q: usize) -> usize {
        self.doc.quests[q]
            .maps
            .iter()
            .filter(|m| self.cleared.contains(&m.id))
            .count()
    }

    /// CLEAR streets across every quest of one track.
    pub fn track_cleared(&self, track: &str) -> (usize, usize) {
        let mut n = 0;
        let mut total = 0;
        for q in self.doc.of_track(track) {
            n += self.cleared_count(q);
            total += self.doc.quests[q].maps.len();
        }
        (n, total)
    }

    pub fn progress(&self) -> Progress {
        Progress {
            quest: self.quest,
            step: self.step,
            stage: self.progress_stage(),
            solved: self.solved,
            cleared: self.cleared_ids(),
            lang: Some(self.lang.clone()),
        }
    }

    /// A record from `localStorage`, or from a save written by an older build:
    /// every field is checked, because a quest that no longer exists or a step
    /// past the end of one would otherwise be a panic on the first draw.
    pub fn load_progress(&mut self, p: &Progress) {
        self.cleared = p.cleared.iter().cloned().collect();
        self.saved = None;
        if let Some(lang) = &p.lang {
            self.set_lang(lang);
        }
        let quest = if p.quest < self.doc.quests.len() {
            p.quest
        } else {
            0
        };
        self.quest = quest;
        self.remember_track(quest);
        let maps = self.maps().len();
        if p.step < maps {
            let stages = self.maps()[p.step].stages.len();
            self.saved = Some(Saved {
                quest,
                step: p.step,
                stage: p.stage.min(stages.saturating_sub(1)),
                solved: p.solved,
            });
        }
        self.touch();
    }

    fn remember_track(&mut self, q: usize) {
        let track = self.doc.quests[q].track.clone();
        match self.track_quest.iter_mut().find(|(t, _)| *t == track) {
            Some(slot) => slot.1 = q,
            None => self.track_quest.push((track, q)),
        }
    }

    fn save(&mut self) {
        self.saved = Some(Saved {
            quest: self.quest,
            step: self.step,
            stage: self.stage,
            solved: self.solved,
        });
        self.emit(Event::Save);
    }

    // ------------------------------------------------------------ navigation

    pub fn is_cleared(&self, i: usize) -> bool {
        self.maps()
            .get(i)
            .is_some_and(|m| self.cleared.contains(&m.id))
    }

    pub fn all_cleared(&self) -> bool {
        (0..self.maps().len()).all(|i| self.is_cleared(i))
    }

    /// The first street that is not CLEAR yet; the first street when they all are.
    pub fn first_open(&self) -> usize {
        (0..self.maps().len())
            .find(|&i| !self.is_cleared(i))
            .unwrap_or(0)
    }

    fn mark_clear(&mut self, i: usize) {
        let Some(id) = self.maps().get(i).map(|m| m.id.clone()) else {
            return;
        };
        if self.cleared.insert(id) {
            self.emit(Event::Burst {
                at: Space::Scene,
                fx: 0.5,
                fy: 0.4,
                n: 48,
            });
        }
    }

    pub fn set_quest(&mut self, q: usize, quiet: bool) {
        if q >= self.doc.quests.len() || q == self.quest {
            return;
        }
        self.quest = q;
        self.remember_track(q);
        self.streak = 0;
        if self.map_from == State::Play {
            // The street we came from belongs to the other quest: no "resume".
            self.map_from = State::Title;
        }
        if self.state == State::Map {
            self.map_cursor = self.first_open();
        }
        // The street cursor has to land inside the new quest before anything
        // reads it: the quests are not the same length.
        self.step = self.step.min(self.maps().len() - 1);
        self.stage = 0;
        self.done = vec![false; self.maps()[self.step].stages.len()];
        self.solved = false;
        if !quiet {
            self.sfx("select");
        }
        self.touch();
    }

    /// Q: the next quest of the same track, wrapping.
    pub fn toggle_quest(&mut self) {
        let list = self.doc.of_track(self.track());
        let next = match list.iter().position(|&q| q == self.quest) {
            Some(i) => list[(i + 1) % list.len()],
            None => list[0],
        };
        self.set_quest(next, false);
    }

    /// TAB, or one of the three big buttons: switch language track. Lands on
    /// the quest the player last visited there, else its first.
    pub fn set_track(&mut self, id: &str) {
        if id == self.track() || !self.doc.tracks.iter().any(|t| t.id == id) {
            return;
        }
        let want = self
            .track_quest
            .iter()
            .find(|(t, _)| t == id)
            .map(|(_, q)| *q)
            .unwrap_or_else(|| self.doc.first_of(id));
        self.set_quest(want, true);
        // On the map the burst goes off behind the track bar, near the top;
        // anywhere else it belongs in the middle of the screen.
        let fy = if self.state == State::Map { 0.12 } else { 0.5 };
        self.emit(Event::Burst {
            at: Space::Screen,
            fx: 0.5,
            fy,
            n: 40,
        });
        self.sfx("lang");
        self.touch();
    }

    pub fn toggle_track(&mut self) {
        let tracks: Vec<String> = self.doc.tracks.iter().map(|t| t.id.clone()).collect();
        let next = match tracks.iter().position(|t| t == self.track()) {
            Some(i) => tracks[(i + 1) % tracks.len()].clone(),
            None => tracks[0].clone(),
        };
        self.set_track(&next);
    }

    // ---------------------------------------------------------------- states

    pub fn enter_title(&mut self) {
        self.stop_auto();
        self.streak = 0;
        self.state = State::Title;
        self.touch();
    }

    /// `from` is the state the map was opened from; ESC on the map goes back there.
    pub fn enter_map(&mut self, from: State) {
        let from = if from == State::Map {
            self.map_from
        } else {
            from
        };
        self.map_from = from;
        self.stop_auto();
        self.sheet = false;
        self.state = State::Map;
        self.map_cursor = if from == State::Play {
            self.step
        } else {
            match self.saved {
                // A half-done street: pick up there.
                Some(s) if !s.solved && s.quest == self.quest => s.step,
                _ => self.first_open(),
            }
        };
        self.emit(Event::Burst {
            at: Space::Screen,
            fx: 0.5,
            fy: 0.45,
            n: 18,
        });
        self.sfx("open");
        self.touch();
    }

    pub fn leave_map(&mut self) {
        self.sfx("back");
        if self.map_from == State::Play {
            self.state = State::Play;
        } else {
            self.enter_title();
        }
        self.touch();
    }

    pub fn set_map_cursor(&mut self, i: usize) {
        if i < self.maps().len() && i != self.map_cursor {
            self.map_cursor = i;
            self.sfx("move");
            self.touch();
        }
    }

    fn move_map_cursor(&mut self, delta: i64) {
        let n = self.maps().len() as i64;
        let next = (self.map_cursor as i64 + delta).rem_euclid(n) as usize;
        self.map_cursor = next;
        self.sfx("move");
        self.touch();
    }

    /// Start (or restart) street `i`. `stage` restores a saved position;
    /// `quiet` skips the select blip, because `advance` plays its own sweep.
    pub fn enter_play(&mut self, i: usize, stage: Option<usize>, quiet: bool) {
        let i = i.min(self.maps().len() - 1);
        if self.state == State::Map && self.map_from == State::Play && i == self.step {
            // Already standing on this street: the map was only being looked at.
            self.leave_map();
            return;
        }
        self.load_map(i);
        if let Some(s) = stage {
            let n = self.maps()[i].stages.len();
            self.stage = s.min(n - 1);
            // A resumed street counts the blanks behind the cursor as answered.
            for k in 0..self.stage {
                self.done[k] = true;
            }
        }
        self.state = State::Play;
        if !quiet {
            self.sfx("select");
        }
        self.save();
        self.touch();
    }

    fn load_map(&mut self, i: usize) {
        self.step = i;
        self.stage = 0;
        self.done = vec![false; self.maps()[i].stages.len()];
        self.solved = false;
        self.misses = 0;
        self.perfect = false;
        self.set_hint(0);
        self.hint_auto = false;
        self.input.clear();
        self.msg = Msg::None;
        self.emit(Event::FxClear);
        self.emit(Event::PopsClear);
        let spawn = self.maps()[i].spawn;
        self.player_x = spawn;
        self.player_facing = 1.0;
        self.player_walk = false;
        self.cam = (spawn - self.w * 0.32).max(0.0);
        self.idle = 0.0;
        self.blank_t = 0.0;
        self.sheet = false;
    }

    /// Where the title's "C" goes: the half-done street, else the one after the
    /// last solved street, else the first street of that quest still open.
    pub fn continue_target(&self) -> Option<(usize, usize, usize)> {
        let s = self.saved?;
        let q = s.quest.min(self.doc.quests.len() - 1);
        let qmaps = &self.doc.quests[q].maps;
        if !s.solved {
            return Some((s.step, s.stage, q));
        }
        if s.step + 1 < qmaps.len() {
            return Some((s.step + 1, 0, q));
        }
        let open = qmaps
            .iter()
            .position(|m| !self.cleared.contains(&m.id))
            .unwrap_or(0);
        Some((open, 0, q))
    }

    pub fn continue_(&mut self) {
        match self.continue_target() {
            Some((step, stage, q)) => {
                self.set_quest(q, true);
                self.enter_play(step, Some(stage), false);
            }
            None => self.enter_map(State::Title),
        }
    }

    fn enter_win(&mut self) {
        self.auto = false;
        self.sheet = false;
        self.state = State::Win;
        self.sfx("win");
        self.emit(Event::Burst {
            at: Space::Screen,
            fx: 0.5,
            fy: 0.4,
            n: 80,
        });
        self.emit(Event::FxClear);
        let text = self.t("fx_quest");
        self.emit(Event::FxQuest { text });
        self.save();
        let bigo = self.quest_def().station == "BIG O";
        let r = self.stats.on_stamp(bigo);
        self.reward(r, true);
        self.touch();
    }

    // ------------------------------------------------------------- the quiz

    fn pop(&mut self, text: String, kind: &'static str) {
        self.emit(Event::Pop { text, kind });
    }

    /// What the stats hand back after an answer, a CLEAR or a stamp: +XP, FAST,
    /// badges and a level. `quiet` suppresses the +XP line, for the events the
    /// player did not do on purpose.
    fn reward(&mut self, r: Reward, quiet: bool) {
        if r.xp > 0 && !quiet {
            let mut text = self.tf("xp_gain", &[r.xp.to_string()]);
            if r.fast {
                text.push_str("   ");
                text.push_str(&self.t("fast"));
            }
            self.pop(text, "xp");
        }
        for id in &r.badges {
            if let Some(key) = crate::stats::badge_key(id) {
                let name = self.t(key);
                let text = self.tf("badge_pop", &[name]);
                self.pop(text, "badge");
                self.emit(Event::Burst {
                    at: Space::Scene,
                    fx: 0.5,
                    fy: 0.3,
                    n: 40,
                });
                self.sfx("hint");
            }
        }
        if let Some(level) = r.level {
            let text = self.tf("level_up", &[level.to_string()]);
            self.pop(text, "level");
            self.emit(Event::Burst {
                at: Space::Scene,
                fx: 0.5,
                fy: 0.35,
                n: 70,
            });
            self.sfx("clear");
        }
    }

    pub fn set_hint(&mut self, level: u8) {
        // Revealing the answer costs the streak and counts as a miss: a street
        // read out of the HINT panel is not a PERFECT one.
        if level >= 2 && self.hint_level < 2 && !self.solved {
            self.streak = 0;
            self.misses += 1;
        }
        self.hint_level = level.min(2);
        self.touch();
    }

    /// HINT cycles: nudge -> answer -> hidden.
    pub fn toggle_hint(&mut self) {
        self.set_hint((self.hint_level + 1) % 3);
        let name = if self.hint_level > 0 { "hint" } else { "back" };
        self.sfx(name);
        self.idle = 0.0;
    }

    pub fn submit(&mut self) {
        if self.state != State::Play || self.solved {
            return;
        }
        let accept = self.current_stage().accept.clone();
        if !accepts(&self.input, &accept) {
            if self.input.is_empty() {
                self.msg = Msg::Key("msg_empty");
                self.sfx("deny");
            } else {
                self.msg = Msg::Key("msg_wrong");
                self.streak = 0;
                self.misses += 1;
                self.set_hint(self.hint_level.max(1));
                self.sfx("bad");
                let (streak, blank_t, hour) = (self.streak, self.blank_t, self.hour);
                self.stats.on_answer(false, streak, blank_t, hour);
            }
            self.emit(Event::Shake { amount: 10.0 });
            self.emit(Event::Flash {
                good: false,
                amount: 0.6,
            });
            self.idle = 0.0;
            self.touch();
            return;
        }

        self.msg = Msg::StageOk {
            quest: self.quest,
            step: self.step,
            stage: self.stage,
        };
        self.idle = 0.0;
        self.streak += 1;
        let n = 36 + (self.streak.min(8) as u32) * 12;
        self.emit(Event::Burst {
            at: Space::Scene,
            fx: 0.5,
            fy: 0.45,
            n,
        });
        let step_text = self.t("fx_step");
        self.emit(Event::FxSmall {
            fx: 0.5,
            fy: 0.62,
            text: step_text,
        });
        if self.streak >= 2 {
            let text = self.tf("combo", &[self.streak.to_string()]);
            self.pop(text, "combo");
        }
        let (streak, blank_t, hour) = (self.streak, self.blank_t, self.hour);
        let r = self.stats.on_answer(true, streak, blank_t, hour);
        self.reward(r, false);
        self.blank_t = 0.0;
        self.done[self.stage] = true;

        match self.first_open_stage() {
            Some(open) => {
                if self.streak >= 2 {
                    let pitch = 1.0 + 0.06 * self.streak.min(10) as f32;
                    self.emit(Event::Sfx {
                        name: "combo",
                        pitch,
                    });
                } else {
                    self.sfx("ok");
                }
                self.stage = open;
                self.input.clear();
                self.set_hint(0);
                self.hint_auto = false;
            }
            None => {
                self.solved = true;
                self.input.clear();
                self.set_hint(0);
                self.emit(Event::Flash {
                    good: true,
                    amount: 0.45,
                });
                if self.misses == 0 {
                    self.perfect = true;
                    self.emit(Event::PopsClear);
                    let text = self.t("perfect");
                    self.pop(text, "perfect");
                    self.emit(Event::Burst {
                        at: Space::Scene,
                        fx: 0.5,
                        fy: 0.4,
                        n: 90,
                    });
                    self.sfx("perfect");
                } else {
                    self.sfx("clear");
                }
                self.emit(Event::FxClear);
                let text = self.t("fx_street");
                let perfect = self.perfect;
                self.emit(Event::FxBig { text, perfect });
                self.mark_clear(self.step);
                let (tracks, polyglot) = self.polyglot_state();
                let r = self.stats.on_clear(perfect, tracks, polyglot);
                self.reward(r, false);
            }
        }
        self.save();
        self.touch();
    }

    /// The two cross-track badges, computed the way `stationsByTrack` does:
    /// how many tracks have any CLEAR street, and whether one station label is
    /// CLEAR in three of them. RECURSE in Go, Rust and Python is one round
    /// played three times, and finishing all three is what POLYGLOT means.
    fn polyglot_state(&self) -> (usize, bool) {
        let mut tracks: BTreeSet<&str> = BTreeSet::new();
        let mut by_station: std::collections::BTreeMap<&str, BTreeSet<&str>> = Default::default();
        for quest in &self.doc.quests {
            for m in &quest.maps {
                if self.cleared.contains(&m.id) {
                    tracks.insert(&quest.track);
                    by_station
                        .entry(&m.station)
                        .or_default()
                        .insert(&quest.track);
                }
            }
        }
        (tracks.len(), by_station.values().any(|t| t.len() >= 3))
    }

    /// After CLEAR: the stamp once every street is clear, else the next street,
    /// else (the last street, some still open) the map.
    pub fn advance(&mut self) {
        if self.state != State::Play || !self.solved {
            return;
        }
        if self.all_cleared() {
            self.enter_win();
            return;
        }
        if self.step + 1 >= self.maps().len() {
            self.enter_map(State::Play);
            return;
        }
        self.sfx("next");
        self.enter_play(self.step + 1, None, true);
    }

    /// The first blank of this street not yet answered, in order; `None` once
    /// every blank is done. Answering out of order still visits them all.
    pub fn first_open_stage(&self) -> Option<usize> {
        self.done.iter().position(|d| !d)
    }

    /// What the save records as the stage: the first open blank, not the one
    /// being browsed, so a resume lands on the work.
    pub fn progress_stage(&self) -> usize {
        self.first_open_stage()
            .unwrap_or_else(|| self.map().stages.len() - 1)
    }

    pub fn has_stage(&self, k: i64) -> bool {
        k >= 0 && (k as usize) < self.map().stages.len()
    }

    /// PREV / NEXT page through the blanks of the street, cleared or not, so a
    /// reader can re-read a line or peek ahead. Moving clears the typed text
    /// and the hint: each blank is its own question.
    pub fn goto_stage(&mut self, k: i64) {
        if self.state != State::Play || !self.has_stage(k) || k as usize == self.stage {
            return;
        }
        self.stage = k as usize;
        self.input.clear();
        self.msg = Msg::None;
        self.set_hint(0);
        self.hint_auto = false;
        self.idle = 0.0;
        self.blank_t = 0.0;
        self.sfx("move");
        self.save();
        self.touch();
    }

    // ----------------------------------------------------------------- AUTO
    //
    // AUTO plays the quiz for the reader: read the question, open the nudge,
    // type the answer one key at a time, submit, sit on the explanation, and
    // after CLEAR walk on to the next open street until the stamp.

    pub fn start_auto(&mut self) {
        if self.state != State::Play {
            return;
        }
        self.auto = true;
        self.auto_phase = AutoPhase::Read;
        self.auto_t = 0.0;
        self.auto_chars.clear();
        self.idle = 0.0;
        self.sfx("select");
        self.touch();
    }

    pub fn stop_auto(&mut self) {
        if self.auto {
            self.auto = false;
            self.sfx("back");
            self.touch();
        }
    }

    pub fn toggle_auto(&mut self) {
        if self.auto {
            self.stop_auto();
        } else {
            self.start_auto();
        }
    }

    fn auto_advance(&mut self) {
        if self.all_cleared() {
            self.enter_win();
            return;
        }
        let n = self.maps().len();
        let next = (1..=n)
            .map(|k| (self.step + k) % n)
            .find(|&i| !self.is_cleared(i));
        self.sfx("next");
        self.enter_play(next.unwrap_or_else(|| self.first_open()), None, true);
        self.auto = true;
        self.auto_phase = AutoPhase::Read;
        self.auto_t = 0.0;
        self.auto_chars.clear();
    }

    fn update_auto(&mut self, dt: f32) {
        self.auto_t += dt;
        // The thirty-second nudge stays quiet: AUTO opens its own.
        self.idle = 0.0;
        if self.solved {
            if self.auto_t >= auto::CLEAR {
                self.auto_advance();
            }
            return;
        }
        match self.auto_phase {
            AutoPhase::Read => {
                if self.auto_t >= auto::READ {
                    self.set_hint(1);
                    self.auto_phase = AutoPhase::Hint;
                    self.auto_t = 0.0;
                }
            }
            AutoPhase::Hint => {
                if self.auto_t >= auto::HINT {
                    self.auto_chars = self.current_stage().shown_answer().chars().collect();
                    self.input.clear();
                    self.auto_phase = AutoPhase::Type;
                    self.auto_t = 0.0;
                }
            }
            AutoPhase::Type => {
                let typed = self.input.chars().count();
                if typed < self.auto_chars.len() {
                    if self.auto_t >= auto::KEY {
                        self.input.push(self.auto_chars[typed]);
                        self.auto_t = 0.0;
                        self.sfx("type");
                        self.touch();
                    }
                } else if self.auto_t >= auto::PAUSE {
                    self.submit();
                    self.auto_phase = AutoPhase::Learn;
                    self.auto_t = 0.0;
                }
            }
            AutoPhase::Learn => {
                if self.auto_t >= auto::LEARN {
                    self.auto_phase = AutoPhase::Read;
                    self.auto_t = 0.0;
                }
            }
        }
    }

    // --------------------------------------------------------------- update

    pub fn update(&mut self, dt: f32) {
        let dt = dt.clamp(0.0, 1.0 / 20.0);
        self.t += dt;
        if self.state == State::Play {
            self.update_play(dt);
        }
    }

    fn update_play(&mut self, dt: f32) {
        if !self.solved && !self.sheet {
            self.blank_t += dt;
        }
        if self.auto {
            self.update_auto(dt);
        }

        // Arrows walk only after CLEAR. While a blank is open the keyboard types.
        self.player_walk = false;
        if self.solved {
            let speed = 300.0;
            if self.held_left && !self.held_right {
                self.player_x -= speed * dt;
                self.player_facing = -1.0;
                self.player_walk = true;
            } else if self.held_right && !self.held_left {
                self.player_x += speed * dt;
                self.player_facing = 1.0;
                self.player_walk = true;
            }
        }
        let width = self.map().width;
        self.player_x = self.player_x.clamp(80.0, width - 80.0);

        let target = (self.player_x - self.w * 0.32).clamp(0.0, (width - self.w).max(0.0));
        // Frame-rate independent exponential smoothing (`ease.smooth`).
        self.cam += (target - self.cam) * (1.0 - (-4.2 * dt).exp());

        if self.solved {
            if self.player_x > width - 110.0 {
                self.advance();
            }
        } else {
            self.idle += dt;
            if self.hint_level == 0 && !self.hint_auto && self.idle >= HINT_WAIT {
                self.set_hint(1);
                self.hint_auto = true;
                self.emit(Event::Burst {
                    at: Space::Screen,
                    fx: 0.22,
                    fy: 0.75,
                    n: 16,
                });
            }
        }
    }

    // ---------------------------------------------------------------- input

    /// What the code block shows in place of `___` right now.
    pub fn shown(&self) -> String {
        if self.solved {
            self.current_stage().shown_answer().to_string()
        } else if self.input.is_empty() {
            "___".to_string()
        } else {
            self.input.clone()
        }
    }

    pub fn rendered_code(&self) -> String {
        fill_blank(&self.pick(&self.current_stage().code), &self.shown())
    }

    pub fn type_text(&mut self, text: &str) {
        if self.state != State::Play || self.solved || self.sheet {
            return;
        }
        if matches!(text, "\t" | "\n" | "\r") {
            return;
        }
        self.stop_auto();
        if self.input.chars().count() < MAX_INPUT {
            self.input.push_str(text);
            self.idle = 0.0;
            self.sfx("type");
            self.touch();
        }
    }

    pub fn backspace(&mut self) {
        if self.state != State::Play || self.solved || self.sheet {
            return;
        }
        self.stop_auto();
        if self.input.pop().is_some() {
            self.sfx("type");
            self.touch();
        }
        self.idle = 0.0;
    }

    /// One key, by the name LÖVE gives it, so the two ports read the same.
    /// Returns false for a key nothing wanted, which is the shell's cue to let
    /// the browser have it.
    pub fn key(&mut self, key: &str) -> bool {
        // F2 / MAP: open the street picker, or close it again.
        if key == "f2" {
            if self.state == State::Map {
                self.leave_map();
            } else {
                self.enter_map(self.state);
            }
            return true;
        }

        match self.state {
            State::Title => self.key_title(key),
            State::Map => self.key_map(key),
            State::Win => self.key_win(key),
            State::Play => self.key_play(key),
        }
    }

    fn digit(&self, key: &str) -> Option<usize> {
        let n: usize = key.parse().ok()?;
        (n >= 1 && n <= self.maps().len()).then(|| n - 1)
    }

    fn key_title(&mut self, key: &str) -> bool {
        match key {
            "return" | "space" | "kpenter" => self.enter_map(State::Title),
            "c" => self.continue_(),
            "m" => self.enter_map(State::Title),
            "q" => self.toggle_quest(),
            "tab" => self.toggle_track(),
            _ => match self.digit(key) {
                Some(n) => self.enter_play(n, None, false),
                None => return false,
            },
        }
        true
    }

    fn key_map(&mut self, key: &str) -> bool {
        match key {
            "escape" => self.leave_map(),
            "q" => self.toggle_quest(),
            "tab" => self.toggle_track(),
            "left" | "up" | "a" | "w" | "h" | "k" => self.move_map_cursor(-1),
            "right" | "down" | "d" | "s" | "l" | "j" => self.move_map_cursor(1),
            "return" | "space" | "kpenter" => self.enter_play(self.map_cursor, None, false),
            _ => match self.digit(key) {
                Some(n) => self.enter_play(n, None, false),
                None => return false,
            },
        }
        true
    }

    fn key_win(&mut self, key: &str) -> bool {
        match key {
            "return" | "space" | "kpenter" => self.enter_map(State::Win),
            "escape" => self.enter_title(),
            _ => return false,
        }
        true
    }

    fn key_play(&mut self, key: &str) -> bool {
        if key == "f6" {
            self.toggle_sheet();
            return true;
        }
        if self.sheet {
            if key == "escape" {
                self.close_sheet();
            } else if let Some(id) = sheet_key(key) {
                self.sheet_action(id);
            }
            return true;
        }
        if key == "f5" {
            self.toggle_auto();
            return true;
        }
        self.stop_auto();
        match key {
            "escape" => self.enter_map(State::Play),
            "backspace" => self.backspace(),
            "return" | "kpenter" => {
                if self.solved {
                    self.advance();
                } else {
                    self.submit();
                }
            }
            "tab" => self.toggle_hint(),
            "pageup" => self.goto_stage(self.stage as i64 - 1),
            "pagedown" => self.goto_stage(self.stage as i64 + 1),
            "n" | "space" if self.solved => self.advance(),
            _ => return false,
        }
        true
    }

    // ----------------------------------------------------------- the buttons
    //
    // The shell owns the hit boxes — it is the one that laid them out — and
    // calls the action a click landed on by name.

    pub fn action(&mut self, id: &str) {
        match id {
            "hint" => {
                self.stop_auto();
                self.toggle_hint();
            }
            "ok" => {
                self.stop_auto();
                self.submit();
            }
            "next" => {
                self.stop_auto();
                self.advance();
            }
            "auto" => self.toggle_auto(),
            "prev_stage" => {
                self.stop_auto();
                self.goto_stage(self.stage as i64 - 1);
            }
            "next_stage" => {
                self.stop_auto();
                self.goto_stage(self.stage as i64 + 1);
            }
            "share" => self.open_sheet(),
            "map" => self.enter_map(self.state),
            "leave_map" => self.leave_map(),
            "title" => self.enter_title(),
            "continue" => self.continue_(),
            "quest" => self.toggle_quest(),
            "track" => self.toggle_track(),
            "lang" => self.cycle_lang(),
            _ => {}
        }
    }

    // ---------------------------------------------------------------- share

    pub fn open_sheet(&mut self) {
        if self.state != State::Play {
            return;
        }
        self.stop_auto();
        self.sheet = true;
        self.sfx("open");
        self.touch();
    }

    pub fn close_sheet(&mut self) {
        if self.sheet {
            self.sheet = false;
            self.sfx("back");
            self.touch();
        }
    }

    pub fn toggle_sheet(&mut self) {
        if self.sheet {
            self.close_sheet();
        } else {
            self.open_sheet();
        }
    }

    fn cycle_scope(&mut self) {
        const SCOPES: [&str; 3] = ["street", "quest", "track"];
        let i = SCOPES
            .iter()
            .position(|s| *s == self.share_scope)
            .unwrap_or(0);
        self.share_scope = SCOPES[(i + 1) % SCOPES.len()].to_string();
        self.sfx("move");
        self.touch();
    }

    /// One button of the SHARE sheet. Copies and exports leave the sheet open,
    /// so a player can take several formats in a row; the toast says what happened.
    pub fn sheet_action(&mut self, id: &str) {
        if id == "scope" {
            self.cycle_scope();
            return;
        }
        if matches!(id, "q" | "hint" | "answer" | "all") {
            let text = crate::share::copy_text(self, id);
            self.emit(Event::Copy { text });
            let key = match id {
                "q" => "copy_q",
                "hint" => "copy_hint",
                "answer" => "copy_answer",
                _ => "copy_all",
            };
            // The Lua strips the leading "1. " numbering off the button label.
            let label = self.t(key);
            let short: String = label.chars().skip(3).collect();
            let toast = self.tf("toast_copied", &[short]);
            self.emit(Event::Toast { text: toast });
            self.sfx("ok");
            let r = self.stats.on_share(true);
            self.reward(r, true);
            return;
        }

        let scope = self.share_scope.clone();
        let formats: Vec<&str> = if id == "allfmt" {
            crate::share::FORMATS.to_vec()
        } else if crate::share::FORMATS.contains(&id) {
            vec![id]
        } else {
            return;
        };
        let mut names = Vec::new();
        for fmt in &formats {
            let (name, mime, body) = crate::share::export(self, fmt, &scope);
            names.push(name.clone());
            self.emit(Event::Download { name, mime, body });
        }
        let toast = if names.len() == 1 {
            self.tf("toast_saved", &[names[0].clone()])
        } else {
            self.tf(
                "toast_saved_n",
                &[names.len().to_string(), "Downloads".into()],
            )
        };
        self.emit(Event::Toast { text: toast });
        self.sfx(if id == "png" || id == "allfmt" {
            "clear"
        } else {
            "ok"
        });
        let r = self.stats.on_share(false);
        self.reward(r, true);
    }
}

/// The digits and letters the SHARE sheet answers to (`SHEET_KEYS`).
fn sheet_key(key: &str) -> Option<&'static str> {
    Some(match key {
        "1" => "q",
        "2" => "hint",
        "3" => "answer",
        "4" => "all",
        "5" => "md",
        "6" => "csv",
        "7" => "jsonl",
        "8" => "txt",
        // The desktop build has SQLite on 9 and the disk on 0. A browser has
        // nowhere useful to put a database file, so 9 does nothing here and
        // the disk keeps the key its own label names.
        "0" => "png",
        "a" => "allfmt",
        "s" => "scope",
        _ => return None,
    })
}

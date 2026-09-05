//! What the rules ask the shell to do.
//!
//! The core decides *that* a right answer sparkles and *that* it plays the
//! "ok" blip; where the sparkle lands in window pixels and how the blip is
//! synthesised are the shell's business. So the frame's side effects come out
//! as a list of these rather than as calls into a graphics or audio API, which
//! is also what lets `cargo test` play whole quests with nothing attached.

use serde::Serialize;

/// Where a burst's coordinates are measured. `Screen` is the whole viewport;
/// `Scene` is the band the street is drawn in, whose height only the shell
/// knows. Both are fractions of that box, never pixels.
#[derive(Debug, Clone, Copy, Serialize, PartialEq, Eq)]
#[serde(rename_all = "lowercase")]
pub enum Space {
    Screen,
    Scene,
}

#[derive(Debug, Clone, Serialize, PartialEq)]
#[serde(tag = "event", rename_all = "snake_case")]
pub enum Event {
    /// One of the synthesized 8-bit effects, by the name `src/sfx.lua` gives it.
    Sfx {
        name: &'static str,
        pitch: f32,
    },
    /// A shower of confetti stars at a point.
    Burst {
        at: Space,
        fx: f32,
        fy: f32,
        n: u32,
    },
    Shake {
        amount: f32,
    },
    Flash {
        good: bool,
        amount: f32,
    },
    /// The three tiers of "you did it" (`src/fx.lua`).
    FxSmall {
        fx: f32,
        fy: f32,
        text: String,
    },
    FxBig {
        text: String,
        perfect: bool,
    },
    FxQuest {
        text: String,
    },
    FxClear,
    /// A floating COMBO / +XP / PERFECT / LEVEL UP / BADGE line.
    Pop {
        text: String,
        kind: &'static str,
    },
    /// PERFECT takes the stage alone: whatever was floating goes.
    PopsClear,
    /// The progress record changed and is worth writing out.
    Save,
    Copy {
        text: String,
    },
    Download {
        name: String,
        mime: &'static str,
        body: String,
    },
    Toast {
        text: String,
    },
}

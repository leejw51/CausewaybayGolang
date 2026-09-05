//! CAUSEWAYBAY GO, the rules, compiled to wasm.
//!
//! The LÖVE game is one program: `src/game.lua` decides what happens *and*
//! draws it. The web build splits that in half. Everything a test could ever
//! assert on — which street is open, whether an answer counts, what a combo
//! pays, where "continue" goes — lives here and is exercised by `cargo test`
//! with nothing attached. The TypeScript shell owns the four things a browser
//! will not delegate: a canvas, a keyboard, Web Audio and somewhere to save.
//!
//! The content is not compiled in. `public/data/game.json` is generated from
//! the same Lua files the desktop game reads and handed to [`Core::new`], so a
//! question fixed in `love2d/src/data.lua` is fixed in both builds at once.

pub mod answer;
pub mod data;
pub mod event;
pub mod game;
pub mod i18n;
pub mod share;
pub mod stats;
pub mod view;

use game::{Game, Progress, State};
use wasm_bindgen::prelude::*;

/// The game, as JavaScript holds it.
#[wasm_bindgen]
pub struct Core {
    game: Game,
}

#[wasm_bindgen]
impl Core {
    /// `data` is the text of `public/data/game.json`.
    #[wasm_bindgen(constructor)]
    pub fn new(data: &str) -> Result<Core, JsValue> {
        let doc = data::Doc::parse(data).map_err(|e| JsValue::from_str(&e))?;
        Ok(Core {
            game: Game::new(doc),
        })
    }

    // ------------------------------------------------------------ the frame

    pub fn update(&mut self, dt: f32) {
        self.game.update(dt);
    }

    /// The version of the snapshot. When it has not moved, neither has
    /// anything [`Core::view`] would say, and the shell can keep the last one.
    pub fn version(&self) -> u64 {
        self.game.version()
    }

    pub fn view(&self) -> String {
        serde_json::to_string(&view::build(&self.game)).unwrap_or_else(|_| "{}".into())
    }

    /// `[player x, facing, walking, camera, clock]`.
    pub fn anim(&self) -> Vec<f32> {
        view::anim(&self.game)
    }

    /// Everything the rules asked the shell to do since the last call.
    pub fn events(&mut self) -> String {
        serde_json::to_string(&self.game.drain_events()).unwrap_or_else(|_| "[]".into())
    }

    // ----------------------------------------------------------------- input

    /// A key, by the name LÖVE gives it. False means nothing wanted it, which
    /// is the shell's cue to let the browser have the keystroke.
    pub fn key(&mut self, key: &str) -> bool {
        self.game.key(key)
    }

    pub fn text(&mut self, text: &str) {
        self.game.type_text(text);
    }

    /// Arrow keys held down, for the walk after a street is CLEAR.
    pub fn set_held(&mut self, left: bool, right: bool) {
        self.game.set_held(left, right);
    }

    /// A button the shell laid out and the player clicked.
    pub fn action(&mut self, id: &str) {
        self.game.action(id);
    }

    pub fn sheet_action(&mut self, id: &str) {
        self.game.sheet_action(id);
    }

    pub fn close_sheet(&mut self) {
        self.game.close_sheet();
    }

    pub fn set_map_cursor(&mut self, i: usize) {
        self.game.set_map_cursor(i);
    }

    pub fn enter_play(&mut self, i: usize) {
        self.game.enter_play(i, None, false);
    }

    pub fn set_quest(&mut self, q: usize) {
        self.game.set_quest(q, false);
    }

    pub fn set_track(&mut self, id: &str) {
        self.game.set_track(id);
    }

    pub fn enter_map(&mut self) {
        let from = self.game.state;
        self.game.enter_map(from);
    }

    pub fn leave_map(&mut self) {
        self.game.leave_map();
    }

    // ---------------------------------------------------------- the shell's

    /// The virtual width the layout settled on. The camera is the only rule
    /// that cares how wide the window is.
    pub fn set_viewport(&mut self, w: f32) {
        self.game.set_viewport(w);
    }

    /// The player's local hour, for the NIGHT OWL and EARLY BIRD badges: wasm
    /// has no clock of its own.
    pub fn set_hour(&mut self, hour: u32) {
        self.game.hour = hour.min(23);
    }

    // ------------------------------------------------------------- language

    pub fn lang(&self) -> String {
        self.game.lang.clone()
    }

    pub fn set_lang(&mut self, code: &str) {
        self.game.set_lang(code);
    }

    pub fn cycle_lang(&mut self) {
        self.game.cycle_lang();
    }

    /// Every UI string, resolved into the language on screen. The shell caches
    /// this and re-reads it when the language changes; formatting the `%s` and
    /// `%d` in them is a dozen lines it can do itself.
    pub fn strings(&self) -> String {
        let g = &self.game;
        let map: std::collections::BTreeMap<&String, String> = g
            .doc
            .strings
            .iter()
            .map(|(k, v)| (k, i18n::pick(&g.doc, v, &g.lang)))
            .collect();
        serde_json::to_string(&map).unwrap_or_else(|_| "{}".into())
    }

    // -------------------------------------------------------------- storage

    pub fn progress(&self) -> String {
        serde_json::to_string(&self.game.progress()).unwrap_or_else(|_| "{}".into())
    }

    pub fn load_progress(&mut self, json: &str) {
        if let Ok(p) = serde_json::from_str::<Progress>(json) {
            self.game.load_progress(&p);
        }
    }

    pub fn stats(&self) -> String {
        serde_json::to_string(&self.game.stats).unwrap_or_else(|_| "{}".into())
    }

    pub fn load_stats(&mut self, json: &str) {
        if let Ok(mut s) = serde_json::from_str::<stats::Stats>(json) {
            s.normalise();
            self.game.stats = s;
        }
    }

    /// Title, map, play or win: the one thing an end-to-end test needs to see
    /// without reading pixels back off the canvas.
    pub fn state(&self) -> String {
        match self.game.state {
            State::Title => "title",
            State::Map => "map",
            State::Play => "play",
            State::Win => "win",
        }
        .to_string()
    }
}

/// The number of quests in the loaded data, so the shell can fail loudly on an
/// empty or truncated `game.json` rather than on the first draw.
#[wasm_bindgen]
pub fn quest_count(data: &str) -> usize {
    data::Doc::parse(data).map(|d| d.quests.len()).unwrap_or(0)
}

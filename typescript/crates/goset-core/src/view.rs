//! One frame's worth of "what is on screen", as the shell needs it.
//!
//! The renderer never reaches into the game: it asks for this, lays it out and
//! draws it. Which is why every string in here is already translated and every
//! index is already resolved — the TypeScript side owns pixels and nothing else.
//!
//! It is rebuilt only when [`Game::version`](crate::game::Game::version)
//! changes, so the per-frame cost of the boundary is one integer, not four
//! kilobytes of JSON.

use crate::game::{Game, Msg, State};
use crate::i18n;
use serde::Serialize;

#[derive(Serialize)]
pub struct TrackButton {
    pub id: String,
    pub label: String,
    pub item: String,
    pub cleared: usize,
    pub total: usize,
    pub lit: bool,
}

#[derive(Serialize)]
pub struct QuestTab {
    pub index: usize,
    pub tag: String,
    pub station: String,
    pub cleared: usize,
    pub total: usize,
    pub lit: bool,
}

#[derive(Serialize)]
pub struct StationView {
    pub station: String,
    pub id: String,
    pub name: String,
    pub title: String,
    pub lesson: String,
    pub cleared: bool,
}

#[derive(Serialize)]
pub struct NpcView {
    pub kind: String,
    pub x: f32,
    pub facing: f32,
    pub line: String,
}

#[derive(Serialize)]
pub struct MapView {
    pub id: String,
    pub station: String,
    pub name: String,
    pub title: String,
    pub lesson: String,
    pub story: String,
    pub speaker: String,
    pub bg: String,
    pub portrait: String,
    pub viz: String,
    pub ground: f32,
    pub width: f32,
    pub npcs: Vec<NpcView>,
    pub chips: Vec<(String, String)>,
    pub note: String,
}

/// A line of the code block, with the blank already filled in. `blank` marks
/// the line the `___` was on, which is the one that pulses gold.
#[derive(Serialize)]
pub struct CodeLine {
    pub text: String,
    pub blank: bool,
}

#[derive(Serialize)]
pub struct StageView {
    pub topic: String,
    pub question: String,
    pub hint: String,
    pub answer: String,
    pub code: Vec<CodeLine>,
}

#[derive(Serialize)]
pub struct StatsView {
    pub level: i64,
    pub xp: i64,
    pub into: i64,
    pub size: i64,
    pub badges: usize,
}

#[derive(Serialize)]
pub struct WinView {
    pub stamp: String,
    pub bg: String,
    pub title: String,
    pub head: String,
}

#[derive(Serialize)]
pub struct ContinueView {
    pub quest_tag: String,
    pub station: String,
    pub cleared: usize,
    pub total: usize,
}

#[derive(Serialize)]
pub struct PlayerView {
    pub x: f32,
    pub facing: f32,
    pub walk: bool,
    pub cam: f32,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct View {
    pub version: u64,
    pub state: State,
    pub lang: String,
    pub lang_name: String,

    pub track: String,
    pub track_label: String,
    pub tracks: Vec<TrackButton>,
    pub quest_tag: String,
    pub quest_station: String,
    pub quest_name: String,
    /// The quest's 1-based number inside its own track: the "QUEST %d".
    pub quest_number: usize,
    pub quest_tabs: Vec<QuestTab>,

    pub step: usize,
    pub stage: usize,
    pub stage_count: usize,
    pub stations: Vec<StationView>,
    pub cleared_count: usize,
    pub all_cleared: bool,

    pub map: MapView,
    pub stage_data: StageView,

    pub input: String,
    pub solved: bool,
    pub hint_level: u8,
    pub msg: String,
    pub msg_kind: &'static str,
    pub streak: i64,
    pub perfect: bool,

    pub map_cursor: usize,
    pub map_from: State,
    pub can_resume: bool,

    pub stats: StatsView,
    pub win: WinView,
    pub continue_at: Option<ContinueView>,

    pub auto: bool,
    pub sheet: bool,
    pub share_scope: String,
}

pub fn build(g: &Game) -> View {
    let doc = &g.doc;
    let track = g.track().to_string();
    let track_def = doc.track_def(&track);

    let tracks = doc
        .tracks
        .iter()
        .map(|t| {
            let (cleared, total) = g.track_cleared(&t.id);
            TrackButton {
                id: t.id.clone(),
                label: t.label.clone(),
                item: t.item.clone(),
                cleared,
                total,
                lit: t.id == track,
            }
        })
        .collect();

    let quest_tabs = doc
        .of_track(&track)
        .into_iter()
        .map(|q| QuestTab {
            index: q,
            tag: doc.quests[q].tag.clone(),
            station: doc.quests[q].station.clone(),
            cleared: g.cleared_count(q),
            total: doc.quests[q].maps.len(),
            lit: q == g.quest,
        })
        .collect();

    let stations = g
        .maps()
        .iter()
        .map(|m| StationView {
            station: m.station.clone(),
            id: m.id.clone(),
            name: g.pick(&m.name),
            title: g.pick(&m.title),
            lesson: g.pick(&m.lesson),
            cleared: g.cleared.contains(&m.id),
        })
        .collect();

    let m = g.map();
    let map = MapView {
        id: m.id.clone(),
        station: m.station.clone(),
        name: g.pick(&m.name),
        title: g.pick(&m.title),
        lesson: g.pick(&m.lesson),
        story: g.pick(&m.story),
        speaker: g.pick(&m.speaker),
        bg: m.bg.clone(),
        portrait: m.portrait.clone(),
        viz: m.viz.clone(),
        ground: m.ground,
        width: m.width,
        npcs: m
            .npcs
            .iter()
            .map(|n| NpcView {
                kind: n.kind.clone(),
                x: n.x,
                facing: n.facing,
                line: g.pick(&n.line),
            })
            .collect(),
        chips: m.chips.clone(),
        note: m.note.clone().unwrap_or_default(),
    };

    let st = g.current_stage();
    let shown = g.shown();
    // The blank is marked from the *source* line, so a wrong guess that happens
    // to contain "___" cannot light up a line that never had a blank.
    let block = g.pick(&st.code);
    let source: Vec<String> = block.lines().map(str::to_string).collect();
    let code = source
        .iter()
        .map(|line| CodeLine {
            text: crate::answer::fill_blank(line, &shown),
            blank: line.contains("___"),
        })
        .collect();

    let stage_data = StageView {
        topic: st.topic.clone(),
        question: g.pick(&st.q),
        hint: g.pick(&st.hint),
        answer: st.shown_answer().to_string(),
        code,
    };

    let (msg, msg_kind) = match &g.msg {
        Msg::None => (String::new(), "idle"),
        Msg::Key(k) => (g.t(k), "bad"),
        Msg::StageOk { quest, step, stage } => {
            let ok = &doc.quests[*quest].maps[*step].stages[*stage].ok;
            (i18n::pick(doc, ok, &g.lang), "ok")
        }
    };

    let (into, size) = g.stats.progress();
    let win = &g.quest_def().win;
    let continue_at = g.continue_target().map(|(step, _, q)| ContinueView {
        quest_tag: doc.quests[q].tag.clone(),
        station: doc.quests[q].maps[step].station.clone(),
        cleared: g.cleared_count(q),
        total: doc.quests[q].maps.len(),
    });

    View {
        version: g.version(),
        state: g.state,
        lang: g.lang.clone(),
        lang_name: doc
            .lang_names
            .get(&g.lang)
            .cloned()
            .unwrap_or_else(|| "EN".into()),
        track: track.clone(),
        track_label: track_def.label.clone(),
        tracks,
        quest_tag: g.quest_def().tag.clone(),
        quest_station: g.quest_def().station.clone(),
        quest_name: g.pick(&g.quest_def().name),
        quest_number: doc.index_in_track(g.quest) + 1,
        quest_tabs,
        step: g.step,
        stage: g.stage,
        stage_count: m.stages.len(),
        stations,
        cleared_count: g.cleared_count(g.quest),
        all_cleared: g.all_cleared(),
        map,
        stage_data,
        input: g.input.clone(),
        solved: g.solved,
        hint_level: g.hint_level,
        msg,
        msg_kind,
        streak: g.streak,
        perfect: g.perfect,
        map_cursor: g.map_cursor,
        map_from: g.map_from,
        can_resume: g.map_from == State::Play,
        stats: StatsView {
            level: g.stats.level,
            xp: g.stats.xp,
            into,
            size,
            badges: g.stats.badges.len(),
        },
        win: WinView {
            stamp: win.stamp.clone(),
            bg: win.bg.clone(),
            title: win.title.clone(),
            head: win.head.clone(),
        },
        continue_at,
        auto: g.auto,
        sheet: g.sheet,
        share_scope: g.share_scope.clone(),
    }
}

/// Where the player and the camera are, this frame. Split out from the view
/// because it changes every frame while walking and the view barely changes at
/// all; four floats cross the boundary instead of the whole snapshot.
pub fn anim(g: &Game) -> Vec<f32> {
    vec![
        g.player_x,
        g.player_facing,
        if g.player_walk { 1.0 } else { 0.0 },
        g.cam,
        g.t,
    ]
}

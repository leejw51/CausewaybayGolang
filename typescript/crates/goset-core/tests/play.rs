//! Play the real game, headless.
//!
//! These run against `public/data/game.json` — the same file the browser
//! downloads — so they check the rules and the content together: a quest that
//! lost its streets, a blank whose `accept` list no longer contains its own
//! answer, or a street that cannot be cleared would all fail here rather than
//! in front of a player.

use goset_core::data::Doc;
use goset_core::event::Event;
use goset_core::game::{Game, State};

fn doc() -> Doc {
    let path = concat!(env!("CARGO_MANIFEST_DIR"), "/../../public/data/game.json");
    let json = std::fs::read_to_string(path)
        .unwrap_or_else(|e| panic!("{path}: {e}\nrun `make data` to generate it from love2d/src"));
    Doc::parse(&json).expect("game.json parses")
}

fn game() -> Game {
    let mut g = Game::new(doc());
    g.set_viewport(1280.0);
    g
}

/// Answer the blank in front of us correctly.
fn answer_right(g: &mut Game) {
    let want = g.current_stage().shown_answer().to_string();
    g.input = want;
    g.submit();
}

#[test]
fn the_content_is_the_shape_the_readme_promises() {
    let d = doc();
    assert_eq!(d.quests.len(), 20, "twenty quests");
    assert_eq!(d.tracks.len(), 3, "go, rust, python");
    let streets: usize = d.quests.iter().map(|q| q.maps.len()).sum();
    assert_eq!(streets, 140, "seven streets per quest");
    for q in &d.quests {
        assert_eq!(q.maps.len(), 7, "{} has seven streets", q.tag);
        assert!(
            d.tracks.iter().any(|t| t.id == q.track),
            "{} has a real track",
            q.tag
        );
    }
}

#[test]
fn every_blank_accepts_the_answer_it_shows() {
    let d = doc();
    for q in &d.quests {
        for m in &q.maps {
            for (i, st) in m.stages.iter().enumerate() {
                let shown = st.shown_answer();
                assert!(
                    !shown.is_empty(),
                    "{} {} blank {i} has an answer",
                    q.tag,
                    m.id
                );
                assert!(
                    goset_core::answer::accepts(shown, &st.accept),
                    "{} {} blank {i}: {shown:?} is not in its own accept list",
                    q.tag,
                    m.id
                );
                assert!(
                    st.code.en.contains("___"),
                    "{} {} blank {i}: the code block has no blank in it",
                    q.tag,
                    m.id
                );
            }
        }
    }
}

#[test]
fn a_street_clears_when_every_blank_is_answered() {
    let mut g = game();
    g.enter_play(0, None, false);
    let blanks = g.map().stages.len();
    for _ in 0..blanks {
        assert!(!g.solved);
        answer_right(&mut g);
    }
    assert!(g.solved, "the street is CLEAR");
    assert!(g.perfect, "no misses, so PERFECT");
    assert!(g.is_cleared(0));
    assert_eq!(g.streak, blanks as i64);
    assert!(g.stats.xp > 0);
}

#[test]
fn a_wrong_answer_costs_the_streak_and_opens_the_nudge() {
    let mut g = game();
    g.enter_play(0, None, false);
    answer_right(&mut g);
    assert_eq!(g.streak, 1);

    g.input = "definitely not the answer".into();
    g.submit();
    assert_eq!(g.streak, 0, "the streak is gone");
    assert_eq!(g.misses, 1);
    assert_eq!(g.hint_level, 1, "the nudge opened itself");
    assert!(!g.solved);

    // ... and the street can still be finished, just not PERFECT.
    while !g.solved {
        answer_right(&mut g);
    }
    assert!(!g.perfect);
}

#[test]
fn revealing_the_answer_is_a_miss() {
    let mut g = game();
    g.enter_play(0, None, false);
    g.set_hint(2);
    while !g.solved {
        answer_right(&mut g);
    }
    assert!(
        !g.perfect,
        "a street read out of the HINT panel is not PERFECT"
    );
}

#[test]
fn clearing_every_street_of_a_quest_ends_in_the_stamp() {
    let mut g = game();
    let streets = g.maps().len();
    for step in 0..streets {
        g.enter_play(step, None, true);
        while !g.solved {
            answer_right(&mut g);
        }
        if step + 1 < streets {
            g.advance();
            assert_eq!(g.state, State::Play);
        }
    }
    assert!(g.all_cleared());
    g.advance();
    assert_eq!(g.state, State::Win, "the last street hands over the stamp");
    assert_eq!(g.stats.stamps, 1);
    assert!(g.stats.has("stamp"));
}

#[test]
fn auto_plays_a_street_by_itself() {
    let mut g = game();
    g.enter_play(0, None, false);
    g.start_auto();
    // Sixty seconds at 60 Hz is far more than one street needs, and AUTO stops
    // on its own by walking to the next one.
    for _ in 0..3600 {
        g.update(1.0 / 60.0);
        if g.is_cleared(0) {
            break;
        }
    }
    assert!(g.is_cleared(0), "AUTO cleared the street on its own");
}

#[test]
fn a_saved_game_comes_back_where_it_left_off() {
    let mut g = game();
    g.enter_play(2, None, false);
    answer_right(&mut g);
    let saved = g.progress();
    assert_eq!(saved.step, 2);

    let mut fresh = game();
    fresh.load_progress(&saved);
    let (step, stage, quest) = fresh.continue_target().expect("somewhere to continue");
    assert_eq!((step, quest), (2, 0));
    assert_eq!(stage, 1, "the blank after the one that was answered");
}

#[test]
fn a_save_from_a_future_build_does_not_take_the_game_down() {
    let mut g = game();
    g.load_progress(&goset_core::game::Progress {
        quest: 9999,
        step: 9999,
        stage: 9999,
        solved: true,
        cleared: vec!["a street that never existed".into()],
        lang: Some("klingon".into()),
    });
    assert_eq!(g.quest, 0);
    assert_eq!(g.lang, "en");
    // The point of the test: none of the below may panic.
    let _ = goset_core::view::build(&g);
    g.enter_map(State::Title);
    g.enter_play(0, None, false);
}

#[test]
fn tab_walks_the_three_tracks_and_remembers_where_it_was() {
    let mut g = game();
    assert_eq!(g.track(), "go");
    g.set_quest(1, true); // Q2 ADVANCED
    g.toggle_track();
    assert_eq!(g.track(), "rust");
    g.set_quest(6, true); // R3 DELIVERY
    g.toggle_track();
    assert_eq!(g.track(), "python");
    g.toggle_track();
    assert_eq!(g.track(), "go");
    assert_eq!(g.quest, 1, "back to the Go quest we left");
    g.toggle_track();
    assert_eq!(g.quest, 6, "and back to the Rust one");
}

#[test]
fn the_view_is_built_for_every_street_in_the_game() {
    // The renderer indexes into the view without checking, so an off-by-one in
    // any of the twenty chips would be a blank screen. Build all 140.
    let mut g = game();
    for q in 0..g.doc.quests.len() {
        g.set_quest(q, true);
        for step in 0..g.maps().len() {
            g.enter_play(step, None, true);
            let v = goset_core::view::build(&g);
            assert!(
                !v.stage_data.code.is_empty(),
                "quest {q} street {step} has code"
            );
            assert!(
                v.stage_data.code.iter().any(|l| l.blank),
                "and a blank in it"
            );
        }
    }
}

#[test]
fn share_copies_the_blank_on_screen_and_exports_the_street() {
    let mut g = game();
    g.enter_play(0, None, false);
    let text = goset_core::share::copy_text(&g, "all");
    assert!(text.contains("ANSWER:"));
    assert!(text.contains(g.current_stage().shown_answer()));

    for fmt in goset_core::share::FORMATS {
        let (name, _, body) = goset_core::share::export(&g, fmt, "street");
        assert!(name.ends_with(&format!(".{fmt}")), "{name} is a .{fmt}");
        assert!(!body.is_empty(), "{fmt} export is not empty");
    }

    let rows = goset_core::share::rows(&g, "quest");
    let blanks: usize = g.maps().iter().map(|m| m.stages.len()).sum();
    assert_eq!(
        rows.len(),
        blanks,
        "the quest scope covers every blank of it"
    );
}

#[test]
fn the_events_a_right_answer_asks_for() {
    let mut g = game();
    g.enter_play(0, None, false);
    let _ = g.drain_events();
    answer_right(&mut g);
    let events = g.drain_events();
    assert!(
        events
            .iter()
            .any(|e| matches!(e, Event::Sfx { name: "ok", .. })),
        "a blip: {events:?}"
    );
    assert!(
        events.iter().any(|e| matches!(e, Event::Burst { .. })),
        "a sparkle"
    );
    assert!(
        events.iter().any(|e| matches!(e, Event::Save)),
        "and a save"
    );
}

#[test]
fn every_ui_string_the_shell_prints_exists() {
    // The keys the TypeScript side looks up by hand. A rename in i18n.lua that
    // did not reach the shell would show up as the key itself on screen.
    let g = game();
    for key in [
        "subtitle",
        "tagline",
        "title_enter",
        "title_continue",
        "title_fresh",
        "title_help",
        "track_line",
        "quest_tab",
        "clear",
        "cleared",
        "here",
        "map_help",
        "clear_count",
        "esc_back",
        "esc_title",
        "map_label",
        "clear_stamp",
        "clear_map",
        "clear_next",
        "clear_prize",
        "q_prefix",
        "hint",
        "answer",
        "hide",
        "ok",
        "auto",
        "auto_on",
        "next",
        "step_prev",
        "step_next",
        "type_answer",
        "clear_prompt",
        "help_play",
        "help_walk",
        "help_answer",
        "msg_empty",
        "msg_wrong",
        "share",
        "share_title",
        "share_copy_head",
        "share_export_head",
        "share_help",
        "copy_q",
        "copy_hint",
        "copy_answer",
        "copy_all",
        "scope_street",
        "scope_quest",
        "scope_track",
        "exp_md",
        "exp_csv",
        "exp_jsonl",
        "exp_txt",
        "exp_png",
        "exp_all",
        "toast_copied",
        "toast_saved",
        "toast_saved_n",
        "xp_line",
        "xp_short",
        "xp_gain",
        "level_up",
        "fast",
        "badge_pop",
        "badges_head",
        "combo",
        "perfect",
        "streak",
        "fx_step",
        "fx_street",
        "fx_quest",
        "win_help",
        "hud_map",
        "hud_back",
        "hud_full",
        "hud_wind",
        "hud_port",
        "hud_land",
    ] {
        assert!(
            g.doc.strings.contains_key(key),
            "src/i18n.lua has no {key:?}"
        );
    }
    // And every quest's win screen names strings that exist.
    for q in &g.doc.quests {
        assert!(
            g.doc.strings.contains_key(&q.win.title),
            "{} win title",
            q.tag
        );
        assert!(
            g.doc.strings.contains_key(&q.win.head),
            "{} win head",
            q.tag
        );
    }
}

#[test]
fn every_language_says_something_for_every_ui_string() {
    let d = doc();
    let g = Game::new(doc());
    for lang in &d.langs {
        for key in d.strings.keys() {
            let s = goset_core::i18n::t(&d, key, lang);
            assert!(!s.is_empty(), "{lang} {key} is empty");
        }
    }
    drop(g);
}

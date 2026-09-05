//! SHARE: take the lesson with you. Ported from `src/share.lua`.
//!
//! COPY puts the blank on screen — the question, the hint, the answer or all
//! of it — on the clipboard with a line to paste to an AI. EXPORT writes the
//! street, the quest or the whole track out as Markdown, CSV, JSONL, plain
//! text or a PNG "disk": one square image holding every question, hint and
//! answer, a lesson you can carry in a photo album.
//!
//! Four of the five are text and are built here. The PNG is drawn by the shell,
//! which is the side that owns a canvas and a font; this module hands it the
//! same rows the other writers use, so the picture and the Markdown say the
//! same thing.
//!
//! The desktop build also writes SQLite. The browser has nowhere to put a
//! database file that a person could then open, so that one format stays on
//! the desktop and the web build ships the other five.

use crate::game::Game;
use serde::Serialize;

pub const FORMATS: &[&str] = &["md", "csv", "jsonl", "txt", "png"];

/// One row per blank: everything the exports need, already in the language on
/// screen, so a Korean export is Korean all the way through.
#[derive(Debug, Clone, Serialize)]
pub struct Row {
    pub track: String,
    pub quest: String,
    pub quest_name: String,
    pub step: usize,
    pub station: String,
    pub street: String,
    pub place: String,
    pub stage: usize,
    pub topic: String,
    pub question: String,
    pub code: String,
    pub hint: String,
    pub answer: String,
    pub accept: Vec<String>,
    pub why: String,
    pub lesson: String,
    pub cleared: bool,
    pub id: String,
}

/// The columns of the CSV, and the fields the JSONL keeps, in order.
const COLUMNS: &[&str] = &[
    "track", "quest", "step", "station", "street", "stage", "topic", "question", "code", "hint",
    "answer", "why", "lesson", "cleared",
];

fn cell(row: &Row, name: &str) -> String {
    match name {
        "track" => row.track.clone(),
        "quest" => row.quest.clone(),
        "step" => (row.step + 1).to_string(),
        "station" => row.station.clone(),
        "street" => row.street.clone(),
        "stage" => (row.stage + 1).to_string(),
        "topic" => row.topic.clone(),
        "question" => row.question.clone(),
        "code" => row.code.clone(),
        "hint" => row.hint.clone(),
        "answer" => row.answer.clone(),
        "why" => row.why.clone(),
        "lesson" => row.lesson.clone(),
        "cleared" => row.cleared.to_string(),
        _ => String::new(),
    }
}

fn trim_trailing_newlines(s: &str) -> String {
    s.trim_end_matches('\n').to_string()
}

pub fn rows(game: &Game, scope: &str) -> Vec<Row> {
    let quests: Vec<usize> = if scope == "track" {
        game.doc.of_track(game.track())
    } else {
        vec![game.quest]
    };
    let mut out = Vec::new();
    for q in quests {
        let quest = &game.doc.quests[q];
        for (step, m) in quest.maps.iter().enumerate() {
            if scope == "street" && !(q == game.quest && step == game.step) {
                continue;
            }
            for (si, st) in m.stages.iter().enumerate() {
                out.push(Row {
                    track: quest.track.clone(),
                    quest: quest.tag.clone(),
                    quest_name: game.pick(&quest.name),
                    step,
                    station: m.station.clone(),
                    street: game.pick(&m.title),
                    place: game.pick(&m.name),
                    stage: si,
                    topic: st.topic.clone(),
                    question: game.pick(&st.q),
                    code: trim_trailing_newlines(&game.pick(&st.code)),
                    hint: game.pick(&st.hint),
                    answer: st.shown_answer().to_string(),
                    accept: st.accept.clone(),
                    why: game.pick(&st.ok),
                    lesson: game.pick(&m.lesson),
                    cleared: game.cleared.contains(&m.id),
                    id: m.id.clone(),
                });
            }
        }
    }
    out
}

/// The title line of an export: which track, quest and street it holds.
pub fn title(game: &Game, scope: &str) -> String {
    let quest = game.quest_def();
    let label = &game.doc.track_def(game.track()).label;
    match scope {
        "track" => format!("CAUSEWAYBAY GO  ·  {label} TRACK"),
        "quest" => {
            format!(
                "CAUSEWAYBAY GO  ·  {label} {}  {}",
                quest.tag,
                game.pick(&quest.name)
            )
        }
        _ => {
            let m = game.map();
            format!(
                "CAUSEWAYBAY GO  ·  {label} {}  {} {}  ·  {}",
                quest.tag,
                game.step + 1,
                m.station,
                game.pick(&m.title)
            )
        }
    }
}

/// The text for one part of the blank on screen. "all" ends with a question
/// the player can paste straight to their AI.
pub fn copy_text(game: &Game, part: &str) -> String {
    let st = game.current_stage();
    let m = game.map();
    let quest = game.quest_def();
    let head = format!(
        "[{} {}  {}/{} {}  ·  {} {}/{}]",
        game.doc.track_def(game.track()).label,
        quest.tag,
        game.step + 1,
        quest.maps.len(),
        m.station,
        st.topic,
        game.stage + 1,
        m.stages.len()
    );
    let code = trim_trailing_newlines(&game.pick(&st.code));
    let answer = st.shown_answer();
    let q = game.pick(&st.q);
    let mut lines: Vec<String> = vec![head];
    match part {
        "q" => {
            lines.push(format!("Q: {q}"));
            lines.push(String::new());
            lines.push(code);
        }
        "hint" => {
            lines.push(format!("Q: {q}"));
            lines.push(format!("HINT: {}", game.pick(&st.hint)));
        }
        "answer" => {
            lines.push(format!("Q: {q}"));
            lines.push(format!("ANSWER: {answer}"));
            lines.push(format!("WHY: {}", game.pick(&st.ok)));
        }
        _ => {
            lines.push(game.pick(&m.story));
            lines.push(String::new());
            lines.push(format!("Q: {q}"));
            lines.push(String::new());
            lines.push(code);
            lines.push(String::new());
            lines.push(format!("HINT: {}", game.pick(&st.hint)));
            lines.push(format!("ANSWER: {answer}"));
            lines.push(format!("WHY: {}", game.pick(&st.ok)));
            lines.push(String::new());
            lines.push(game.tf("share_ask", &[answer.to_string()]));
        }
    }
    lines.join("\n")
}

// ------------------------------------------------------------------ writers

fn csv_field(s: &str) -> String {
    if s.contains(['"', ',', '\n', '\r']) {
        format!("\"{}\"", s.replace('"', "\"\""))
    } else {
        s.to_string()
    }
}

pub fn csv(rows: &[Row]) -> String {
    let mut out = vec![COLUMNS.join(",")];
    for r in rows {
        let cells: Vec<String> = COLUMNS.iter().map(|c| csv_field(&cell(r, c))).collect();
        out.push(cells.join(","));
    }
    out.join("\n") + "\n"
}

pub fn jsonl(rows: &[Row], title: &str) -> String {
    let mut out = String::new();
    for r in rows {
        let mut obj = serde_json::Map::new();
        obj.insert("title".into(), serde_json::Value::String(title.to_string()));
        for c in COLUMNS {
            let v = match *c {
                "step" => serde_json::json!(r.step + 1),
                "stage" => serde_json::json!(r.stage + 1),
                "cleared" => serde_json::json!(r.cleared),
                other => serde_json::Value::String(cell(r, other)),
            };
            obj.insert((*c).to_string(), v);
        }
        obj.insert("accept".into(), serde_json::json!(r.accept));
        out.push_str(&serde_json::Value::Object(obj).to_string());
        out.push('\n');
    }
    out
}

pub fn markdown(game: &Game, rows: &[Row], title: &str) -> String {
    let mut out = vec![format!("# {title}"), String::new()];
    let mut last: Option<String> = None;
    for r in rows {
        let key = format!("{}{}", r.quest, r.step);
        if last.as_deref() != Some(key.as_str()) {
            last = Some(key);
            out.push(format!(
                "## {} {}  {}  —  {}",
                r.quest,
                r.step + 1,
                r.station,
                r.street
            ));
            out.push(String::new());
            out.push(format!("_{}_", r.lesson));
            out.push(String::new());
        }
        out.push(format!("### {}. {}", r.stage + 1, r.topic));
        out.push(String::new());
        out.push(format!("**Q:** {}", r.question));
        out.push(String::new());
        out.push(format!("```{}", game.doc.track_def(&r.track).lang));
        out.push(r.code.clone());
        out.push("```".into());
        out.push(String::new());
        out.push(format!("- **Hint:** {}", r.hint));
        out.push(format!("- **Answer:** `{}`", r.answer));
        out.push(format!("- **Why:** {}", r.why));
        out.push(String::new());
    }
    out.join("\n")
}

pub fn txt(rows: &[Row], title: &str) -> String {
    let mut out = vec![
        title.to_string(),
        "=".repeat(title.chars().count()),
        String::new(),
    ];
    for r in rows {
        out.push(format!(
            "[{} {} {} {} · {} {}]",
            r.track.to_uppercase(),
            r.quest,
            r.step + 1,
            r.station,
            r.topic,
            r.stage + 1
        ));
        out.push(format!("Q: {}", r.question));
        out.push(String::new());
        out.push(r.code.clone());
        out.push(String::new());
        out.push(format!("HINT: {}", r.hint));
        out.push(format!("ANSWER: {}", r.answer));
        out.push(format!("WHY: {}", r.why));
        out.push(String::new());
        out.push("-".repeat(40));
        out.push(String::new());
    }
    out.join("\n")
}

/// `causewaybaygo-<track>-<quest>-<street>.<ext>`, lowercased and with
/// anything that is not a letter or a digit turned into a dash: the browser
/// hands this straight to a download, and a colon or a slash in it would be a
/// file the operating system refuses to write.
pub fn filename(game: &Game, scope: &str, ext: &str) -> String {
    let quest = game.quest_def();
    let mut parts = vec!["causewaybaygo".to_string(), game.track().to_string()];
    if scope != "track" {
        parts.push(quest.tag.to_lowercase());
    }
    if scope == "street" {
        parts.push(format!("{}-{}", game.step + 1, game.map().station));
    }
    let stem: String = parts
        .join("-")
        .chars()
        .map(|c| {
            if c.is_ascii_alphanumeric() {
                c.to_ascii_lowercase()
            } else {
                '-'
            }
        })
        .collect();
    let stem = stem.trim_matches('-').to_string();
    let mut squashed = String::with_capacity(stem.len());
    let mut prev_dash = false;
    for c in stem.chars() {
        if c == '-' && prev_dash {
            continue;
        }
        prev_dash = c == '-';
        squashed.push(c);
    }
    format!("{squashed}.{ext}")
}

/// Build one export: its file name, its content type and its body. The PNG
/// comes back as the rows in JSON, because the shell draws that one.
pub fn export(game: &Game, fmt: &str, scope: &str) -> (String, &'static str, String) {
    let rows = rows(game, scope);
    let title = title(game, scope);
    let name = filename(game, scope, fmt);
    match fmt {
        "csv" => (name, "text/csv", csv(&rows)),
        "jsonl" => (name, "application/x-ndjson", jsonl(&rows, &title)),
        "txt" => (name, "text/plain", txt(&rows, &title)),
        "png" => {
            let payload = serde_json::json!({ "title": title, "rows": rows });
            (name, "image/png", payload.to_string())
        }
        _ => (
            filename(game, scope, "md"),
            "text/markdown",
            markdown(game, &rows, &title),
        ),
    }
}

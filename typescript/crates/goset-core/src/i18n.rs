//! The language switch, ported from `src/i18n.lua`.
//!
//! Three languages are written inline in the data files as `{ en, ko, yue }`;
//! the four added later live in by-English tables and are looked up by the
//! English string, so the data files never had to change. Anything missing in
//! any language falls back to English, which is why a half-translated file is
//! a legible game rather than a screen of blanks.

use crate::data::{Doc, Loc};

/// Look one translated field up in `lang`.
pub fn pick(doc: &Doc, v: &Loc, lang: &str) -> String {
    let inline = match lang {
        "en" => Some(&v.en),
        "ko" => v.ko.as_ref(),
        "yue" => v.yue.as_ref(),
        _ => None,
    };
    if let Some(s) = inline {
        if !s.is_empty() {
            return s.clone();
        }
    }
    if let Some(table) = doc.tr.get(lang) {
        if let Some(s) = table.get(&v.en) {
            return s.clone();
        }
    }
    v.en.clone()
}

/// A UI string by key. An unknown key comes back as itself, which is what
/// LÖVE does and makes a missing string obvious on screen rather than blank.
pub fn t(doc: &Doc, key: &str, lang: &str) -> String {
    match doc.strings.get(key) {
        Some(v) => pick(doc, v, lang),
        None => key.to_string(),
    }
}

/// `string.format` with the handful of specifiers the string table actually
/// uses: `%s` and `%d`. Arguments are already strings; `%d` is only different
/// from `%s` in Lua, where the argument had to be a number.
///
/// A `%%` is a literal percent, and a specifier with no argument left is
/// printed as it stands rather than swallowed — a translation with one `%s`
/// too many should look wrong, not silently drop text.
pub fn format(spec: &str, args: &[String]) -> String {
    let mut out = String::with_capacity(spec.len() + 16);
    let mut next = 0usize;
    let mut chars = spec.chars().peekable();
    while let Some(c) = chars.next() {
        if c != '%' {
            out.push(c);
            continue;
        }
        match chars.peek() {
            Some('%') => {
                chars.next();
                out.push('%');
            }
            Some(&k @ ('s' | 'd')) => {
                chars.next();
                match args.get(next) {
                    Some(a) => {
                        out.push_str(a);
                        next += 1;
                    }
                    None => {
                        out.push('%');
                        out.push(k);
                    }
                }
            }
            _ => out.push('%'),
        }
    }
    out
}

pub fn tf(doc: &Doc, key: &str, lang: &str, args: &[String]) -> String {
    format(&t(doc, key, lang), args)
}

/// The next language in [`Doc::langs`], wrapping.
pub fn cycle(doc: &Doc, lang: &str) -> String {
    let n = doc.langs.len();
    if n == 0 {
        return "en".into();
    }
    match doc.langs.iter().position(|l| l == lang) {
        Some(i) => doc.langs[(i + 1) % n].clone(),
        None => doc.langs[0].clone(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn format_fills_s_and_d_in_order() {
        let args = ["MTR".to_string(), "3".to_string(), "7".to_string()];
        assert_eq!(format("%s  %d/%d clear", &args), "MTR  3/7 clear");
    }

    #[test]
    fn format_keeps_a_literal_percent_and_a_starved_specifier() {
        assert_eq!(format("100%% sure", &[]), "100% sure");
        assert_eq!(format("%s and %s", &["one".into()]), "one and %s");
    }
}

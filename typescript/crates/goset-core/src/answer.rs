//! Does what the player typed count as the answer?
//!
//! Ported from `norm` and `accepts` in `src/game.lua`. The comparison is
//! deliberately loose: this is a quiz about ideas, not a spelling test, so
//! case, spaces, quotes, underscores, dashes and dots are all ignored and
//! `SHA-256`, `sha256` and `sha_256` are one answer.

/// The two things punctuation-stripping must not destroy: Go's blank
/// identifier `_`, which is nothing but an underscore, and a negative number,
/// where the leading minus is meaning rather than punctuation.
pub fn norm(s: &str) -> String {
    let lower = s.to_lowercase();
    let no_quotes: String = lower
        .chars()
        .filter(|c| !matches!(c, '"' | '\'' | '`'))
        .collect();
    let no_space: String = no_quotes.chars().filter(|c| !c.is_whitespace()).collect();

    let blank = !no_space.is_empty() && no_space.chars().all(|c| c == '_');
    // The minus is judged after the underscores and dots go, and put back
    // before the emptiness test: a lone "-" is an answer in its own right
    // (Python's `len(s) - 1`), and it must not normalise away to nothing.
    let no_words: String = no_space
        .chars()
        .filter(|c| !matches!(c, '_' | '.'))
        .collect();
    let neg = no_words.starts_with('-');
    let stripped: String = no_words.chars().filter(|c| *c != '-').collect();
    let out = if neg {
        format!("-{stripped}")
    } else {
        stripped
    };

    if out.is_empty() && blank {
        return "_".into();
    }
    out
}

pub fn accepts(answer: &str, list: &[String]) -> bool {
    let a = norm(answer);
    if a.is_empty() {
        return false;
    }
    list.iter().any(|c| norm(c) == a)
}

/// Every `___` in a code block shows the same thing: the blank, what is being
/// typed, or the answer once the street is CLEAR.
pub fn fill_blank(code: &str, shown: &str) -> String {
    code.replace("___", shown)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn punctuation_and_case_do_not_matter() {
        let accept = vec!["sha256".to_string()];
        assert!(accepts("SHA-256", &accept));
        assert!(accepts(" sha_256 ", &accept));
        assert!(accepts("\"sha.256\"", &accept));
    }

    #[test]
    fn the_blank_identifier_survives() {
        assert_eq!(norm("_"), "_");
        assert_eq!(norm("__"), "_");
        assert!(accepts("_", &["_".to_string()]));
    }

    #[test]
    fn a_lone_minus_is_an_answer() {
        // `i, j = 0, len(s) ___ 1` wants a minus and nothing else.
        assert_eq!(norm("-"), "-");
        assert!(accepts("-", &["-".to_string()]));
        assert!(!accepts(".", &["-".to_string()]));
    }

    #[test]
    fn a_negative_number_keeps_its_sign() {
        assert_eq!(norm("-1"), "-1");
        assert!(!accepts("-1", &["1".to_string()]));
        assert!(accepts("- 1", &["-1".to_string()]));
    }

    #[test]
    fn nothing_typed_is_never_right() {
        assert!(!accepts("", &["main".to_string()]));
        assert!(!accepts("   ", &["main".to_string()]));
    }

    #[test]
    fn every_blank_in_a_block_is_filled() {
        assert_eq!(fill_blank("a ___ b ___", "x"), "a x b x");
    }
}

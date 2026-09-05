//! Shrink `love2d/assets` down to what a browser will actually download.
//!
//! The LÖVE game loads 48 MB of studio renders and reworks them at every
//! launch: `src/assets.lua` keys the magenta backdrop out of the sprites,
//! measures where the ink lands, crops each character to that box and scales
//! it into a 32x48 cell. A desktop game can afford to redo that on every run;
//! a web game cannot ship the originals at all.
//!
//! So the same passes happen here, once, at build time, and `public/art` comes
//! out around three megabytes. The thresholds, the cell size and the target
//! sizes are copied from `assets.lua`, so a sprite lands on screen the same
//! way it does in LÖVE.
//!
//! Backgrounds are the exception: they are photographs of a painted set, they
//! carry no alpha the game uses, and PNG is the wrong container for them. They
//! come out as JPEG, which is where nearly all of the 48 MB goes.
//!
//!     cargo run -p mkassets -- <src dir> <out dir>

use std::fmt::Write as _;
use std::path::{Path, PathBuf};

use image::codecs::jpeg::JpegEncoder;
use image::imageops::FilterType;
use image::{ImageBuffer, Rgba, RgbaImage};

/// How a source image is treated. The three arms are `assets.lua`'s three
/// arms: a background is drawn as-is, a `SIZE` sprite is scaled and keyed, a
/// `CHAR` sprite is keyed, cropped to its ink and packed into one cell.
#[derive(Clone, Copy, PartialEq, Eq)]
enum Kind {
    /// Photographic backdrop: no alpha, no key, JPEG out.
    Bg,
    /// Keyed sprite, scaled to a fixed size.
    Sprite,
    /// Keyed character, cropped to its ink and packed into a CHAR_W x CHAR_H cell.
    Char,
}

/// `CHAR_W, CHAR_H` in `src/assets.lua`: every person is one cell of this size,
/// so `sprites.lua` can scale them all with one number.
const CHAR_W: u32 = 32;
const CHAR_H: u32 = 48;

/// The long side a background is allowed to keep. The play scene draws them at
/// roughly two thirds of the source height and the title at about one and a
/// half; the art is soft enough that the title's upscale does not show.
const BG_LONG: u32 = 1152;
const BG_QUALITY: u8 = 80;

/// Every image the game asks for, in the order `assets.lua` lists them.
/// `w`/`h` are the target size for a `Sprite`; a `Bg` is fitted to `BG_LONG`
/// and a `Char` to the cell, so their numbers are ignored.
const ART: &[(&str, Kind, u32, u32)] = &[
    ("title_bg", Kind::Bg, 0, 0),
    ("title_bg_p", Kind::Bg, 0, 0),
    ("bg_flat", Kind::Bg, 0, 0),
    ("bg_street", Kind::Bg, 0, 0),
    ("bg_mtr", Kind::Bg, 0, 0),
    ("bg_times", Kind::Bg, 0, 0),
    ("bg_mall", Kind::Bg, 0, 0),
    ("bg_queue", Kind::Bg, 0, 0),
    ("bg_till", Kind::Bg, 0, 0),
    ("bg_kitchen", Kind::Bg, 0, 0),
    ("bg_set", Kind::Bg, 0, 0),
    ("bg_night", Kind::Bg, 0, 0),
    ("bg_lab", Kind::Bg, 0, 0),
    ("bg_market", Kind::Bg, 0, 0),
    ("map_bg", Kind::Bg, 0, 0),
    ("map_bg_p", Kind::Bg, 0, 0),
    ("sprite_hero", Kind::Char, 0, 0),
    ("sprite_clerk", Kind::Char, 0, 0),
    ("sprite_mei", Kind::Char, 0, 0),
    ("sprite_cook", Kind::Char, 0, 0),
    ("item_hashbrown", Kind::Sprite, 128, 128),
    ("item_set", Kind::Sprite, 128, 128),
    ("ui_coin", Kind::Sprite, 48, 48),
    ("ui_panel", Kind::Sprite, 128, 96),
    ("stamp_served", Kind::Sprite, 96, 96),
    ("sprite_monty", Kind::Sprite, 128, 128),
    ("sprite_ferris", Kind::Sprite, 128, 128),
    ("sprite_gogo", Kind::Sprite, 128, 128),
    ("fx_star", Kind::Sprite, 48, 48),
    ("fx_confetti", Kind::Sprite, 24, 24),
    ("fx_ribbon", Kind::Sprite, 512, 512),
    ("fx_trophy", Kind::Sprite, 192, 192),
    ("fx_medal", Kind::Sprite, 160, 160),
];

/// Where a sprite's ink actually is, in its own pixels: `measureBox` in
/// `assets.lua`. The renderer pins a character by `cx` and `feet` rather than
/// by the image corner, so a tall sheet and a short one stand on the same line.
#[derive(Clone, Copy)]
struct Box2 {
    cx: f32,
    feet: f32,
    h: f32,
    /// The opaque bounds themselves. The ribbon behind a CLEAR banner is
    /// stretched to a size the renderer picks, and it has to stretch the ink
    /// rather than the transparent margin around it.
    minx: f32,
    miny: f32,
    maxx: f32,
    maxy: f32,
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let src = PathBuf::from(
        args.first()
            .map(String::as_str)
            .unwrap_or("../love2d/assets"),
    );
    let out = PathBuf::from(args.get(1).map(String::as_str).unwrap_or("public/art"));

    if let Err(err) = std::fs::create_dir_all(&out) {
        fail(&format!("cannot create {}: {err}", out.display()));
    }

    let mut entries: Vec<String> = Vec::new();
    let mut missing: Vec<&str> = Vec::new();
    let mut total = 0u64;

    for (name, kind, w, h) in ART {
        match convert(&src, &out, name, *kind, *w, *h) {
            Ok((bytes, entry)) => {
                total += bytes;
                entries.push(entry);
            }
            Err(err) => {
                eprintln!("  {name}.png: {err}");
                missing.push(name);
            }
        }
    }

    let manifest = format!(
        "{{\n  \"art\": [\n    {}\n  ]\n}}\n",
        entries.join(",\n    ")
    );
    if let Err(err) = std::fs::write(out.join("manifest.json"), &manifest) {
        fail(&format!("cannot write manifest: {err}"));
    }

    if !missing.is_empty() {
        fail(&format!(
            "{} source images missing or unreadable",
            missing.len()
        ));
    }
    println!(
        "  {} images -> {} ({:.1} MB)",
        ART.len(),
        out.display(),
        total as f64 / 1_048_576.0
    );
}

fn fail(msg: &str) -> ! {
    eprintln!("mkassets: {msg}");
    std::process::exit(1);
}

fn convert(
    src: &Path,
    out: &Path,
    name: &str,
    kind: Kind,
    w: u32,
    h: u32,
) -> Result<(u64, String), String> {
    let from = src.join(format!("{name}.png"));
    // Sniffed, not guessed from the name: a handful of the "PNG" sources in
    // love2d/assets are JPEGs that were never renamed, and LÖVE never minded.
    let img = image::ImageReader::open(&from)
        .map_err(|e| e.to_string())?
        .with_guessed_format()
        .map_err(|e| e.to_string())?
        .decode()
        .map_err(|e| e.to_string())?
        .to_rgba8();

    let (file, box2) = match kind {
        Kind::Bg => {
            let fitted = fit_long(&img, BG_LONG);
            let path = out.join(format!("{name}.jpg"));
            write_jpeg(&flatten(&fitted), &path)?;
            (format!("{name}.jpg"), None)
        }
        Kind::Sprite => {
            let mut small = nearest_scale(&img, w, h);
            knockout(&mut small);
            let path = out.join(format!("{name}.png"));
            small.save(&path).map_err(|e| e.to_string())?;
            (format!("{name}.png"), Some(measure_box(&small)))
        }
        Kind::Char => {
            let (cell, box2) = pack_character(&img);
            let path = out.join(format!("{name}.png"));
            cell.save(&path).map_err(|e| e.to_string())?;
            (format!("{name}.png"), Some(box2))
        }
    };

    let bytes = std::fs::metadata(out.join(&file))
        .map(|m| m.len())
        .map_err(|e| e.to_string())?;
    let dims = image::image_dimensions(out.join(&file)).map_err(|e| e.to_string())?;

    let mut entry = String::new();
    let _ = write!(
        entry,
        "{{ \"name\": \"{name}\", \"file\": \"{file}\", \"w\": {}, \"h\": {}",
        dims.0, dims.1
    );
    if let Some(b) = box2 {
        let _ = write!(
            entry,
            ", \"box\": {{ \"cx\": {:.2}, \"feet\": {:.2}, \"h\": {:.2}, \"minx\": {:.0}, \"miny\": {:.0}, \"maxx\": {:.0}, \"maxy\": {:.0} }}",
            b.cx,
            b.feet,
            b.h,
            b.minx,
            b.miny,
            b.maxx,
            b.maxy
        );
    }
    entry.push_str(" }");
    Ok((bytes, entry))
}

// ------------------------------------------------------------------ resizing

/// Scale so the longer side is `long`, leaving anything already smaller alone.
fn fit_long(img: &RgbaImage, long: u32) -> RgbaImage {
    let (w, h) = img.dimensions();
    let max = w.max(h);
    if max <= long {
        return img.clone();
    }
    let s = long as f32 / max as f32;
    let (nw, nh) = (
        ((w as f32 * s) as u32).max(1),
        ((h as f32 * s) as u32).max(1),
    );
    image::imageops::resize(img, nw, nh, FilterType::Lanczos3)
}

/// `nearestScale` in `assets.lua`. Nearest, not a filter: keying a filtered
/// edge leaves a magenta halo, and the game wants hard pixel edges anyway.
fn nearest_scale(img: &RgbaImage, tw: u32, th: u32) -> RgbaImage {
    let (sw, sh) = img.dimensions();
    let (tw, th) = (tw.max(1), th.max(1));
    ImageBuffer::from_fn(tw, th, |x, y| {
        let sx = (x * sw / tw).min(sw - 1);
        let sy = (y * sh / th).min(sh - 1);
        *img.get_pixel(sx, sy)
    })
}

/// Composite onto black. A background has no transparency the game wants, and
/// JPEG has nowhere to put it.
fn flatten(img: &RgbaImage) -> RgbaImage {
    let (w, h) = img.dimensions();
    ImageBuffer::from_fn(w, h, |x, y| {
        let p = img.get_pixel(x, y).0;
        let a = p[3] as f32 / 255.0;
        Rgba([
            (p[0] as f32 * a) as u8,
            (p[1] as f32 * a) as u8,
            (p[2] as f32 * a) as u8,
            255,
        ])
    })
}

fn write_jpeg(img: &RgbaImage, path: &Path) -> Result<(), String> {
    let rgb = image::DynamicImage::ImageRgba8(img.clone()).to_rgb8();
    let mut file = std::fs::File::create(path).map_err(|e| e.to_string())?;
    JpegEncoder::new_with_quality(&mut file, BG_QUALITY)
        .encode_image(&rgb)
        .map_err(|e| e.to_string())
}

// ------------------------------------------------------------------- keying

/// Is this the studio backdrop rather than the subject? `isBg` in `assets.lua`:
/// already transparent, hot magenta (Grok's "solid magenta" comes back as pink
/// too), or a leftover lime screen.
fn is_bg(p: [u8; 4]) -> bool {
    let a = p[3] as f32 / 255.0;
    if a < 0.12 {
        return true;
    }
    let (r, g, b) = (
        p[0] as f32 / 255.0,
        p[1] as f32 / 255.0,
        p[2] as f32 / 255.0,
    );
    if r > 0.55 && b > 0.30 && g < 0.45 && b < r + 0.2 {
        return true;
    }
    g > 0.62 && r < 0.50 && b < 0.50
}

/// Flood the backdrop away from the edges rather than keying every matching
/// pixel. A magenta button on a character's jacket is the subject; the same
/// colour touching the frame is the screen behind them.
fn knockout(img: &mut RgbaImage) {
    let (w, h) = img.dimensions();
    let (w, h) = (w as i64, h as i64);
    let mut seen = vec![false; (w * h) as usize];
    let mut queue: Vec<(i64, i64)> = Vec::new();

    let push = |queue: &mut Vec<(i64, i64)>, seen: &mut Vec<bool>, img: &RgbaImage, x, y| {
        if x < 0 || y < 0 || x >= w || y >= h {
            return;
        }
        let k = (y * w + x) as usize;
        if seen[k] || !is_bg(img.get_pixel(x as u32, y as u32).0) {
            return;
        }
        seen[k] = true;
        queue.push((x, y));
    };

    // Every other pixel of the frame is enough of a seed: the flood joins them.
    for x in (0..w).step_by(2) {
        push(&mut queue, &mut seen, img, x, 0);
        push(&mut queue, &mut seen, img, x, h - 1);
    }
    for y in (0..h).step_by(2) {
        push(&mut queue, &mut seen, img, 0, y);
        push(&mut queue, &mut seen, img, w - 1, y);
    }

    let mut i = 0;
    while i < queue.len() {
        let (x, y) = queue[i];
        i += 1;
        img.put_pixel(x as u32, y as u32, Rgba([0, 0, 0, 0]));
        push(&mut queue, &mut seen, img, x + 1, y);
        push(&mut queue, &mut seen, img, x - 1, y);
        push(&mut queue, &mut seen, img, x, y + 1);
        push(&mut queue, &mut seen, img, x, y - 1);
    }
}

/// The opaque bounds of a keyed sprite, plus the two numbers the renderer pins
/// it by: the horizontal middle of the ink and the row its feet stand on.
fn measure_box(img: &RgbaImage) -> Box2 {
    match ink_bounds(img) {
        None => {
            let (w, h) = img.dimensions();
            Box2 {
                cx: w as f32 * 0.5,
                feet: h as f32,
                h: h as f32,
                minx: 0.0,
                miny: 0.0,
                maxx: w as f32 - 1.0,
                maxy: h as f32 - 1.0,
            }
        }
        Some((minx, miny, maxx, maxy)) => Box2 {
            cx: (minx + maxx) as f32 * 0.5,
            feet: (maxy + 1) as f32,
            h: ((maxy - miny + 1) as f32).max(8.0),
            minx: minx as f32,
            miny: miny as f32,
            maxx: maxx as f32,
            maxy: maxy as f32,
        },
    }
}

fn ink_bounds(img: &RgbaImage) -> Option<(u32, u32, u32, u32)> {
    let (w, h) = img.dimensions();
    let (mut minx, mut miny, mut maxx, mut maxy) = (w, h, 0u32, 0u32);
    let mut found = false;
    for y in 0..h {
        for x in 0..w {
            if img.get_pixel(x, y).0[3] as f32 / 255.0 > 0.12 {
                found = true;
                minx = minx.min(x);
                miny = miny.min(y);
                maxx = maxx.max(x);
                maxy = maxy.max(y);
            }
        }
    }
    found.then_some((minx, miny, maxx, maxy))
}

/// `packCharacter` in `assets.lua`: key the backdrop, crop to the ink, scale
/// that to fit the cell and stand it on the cell's floor. Every person ends up
/// the same logical size whatever the render gave us.
fn pack_character(img: &RgbaImage) -> (RgbaImage, Box2) {
    let mut keyed = img.clone();
    knockout(&mut keyed);
    let Some((minx, miny, maxx, maxy)) = ink_bounds(&keyed) else {
        let cell = nearest_scale(&keyed, CHAR_W, CHAR_H);
        let b = measure_box(&cell);
        return (cell, b);
    };

    let cropped =
        image::imageops::crop_imm(&keyed, minx, miny, maxx - minx + 1, maxy - miny + 1).to_image();
    let (sw, sh) = cropped.dimensions();

    let mut nh = CHAR_H;
    let mut nw = ((sw as f32 * nh as f32 / sh as f32).round() as u32).max(1);
    if nw > CHAR_W {
        nw = CHAR_W;
        nh = ((sh as f32 * nw as f32 / sw as f32).round() as u32).clamp(1, CHAR_H);
    }
    let fitted = nearest_scale(&cropped, nw, nh);

    let mut cell = RgbaImage::new(CHAR_W, CHAR_H);
    let ox = (CHAR_W - nw) / 2;
    let oy = CHAR_H - nh;
    image::imageops::replace(&mut cell, &fitted, ox as i64, oy as i64);
    let b = Box2 {
        cx: ox as f32 + nw as f32 * 0.5,
        feet: CHAR_H as f32,
        h: CHAR_H as f32,
        minx: ox as f32,
        miny: oy as f32,
        maxx: (ox + nw) as f32 - 1.0,
        maxy: CHAR_H as f32 - 1.0,
    };
    (cell, b)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn px(r: u8, g: u8, b: u8, a: u8) -> Rgba<u8> {
        Rgba([r, g, b, a])
    }

    #[test]
    fn magenta_is_backdrop_and_skin_is_not() {
        assert!(is_bg([255, 0, 255, 255]));
        assert!(is_bg([230, 60, 200, 255]));
        assert!(is_bg([0, 0, 0, 0]));
        assert!(!is_bg([240, 200, 170, 255]));
        assert!(!is_bg([20, 30, 90, 255]));
    }

    #[test]
    fn knockout_spares_a_magenta_island_inside_the_subject() {
        // A magenta frame around an opaque blue square with one magenta pixel
        // in the middle of it: the frame is the screen, the pixel is a button.
        let mut img = RgbaImage::from_pixel(9, 9, px(255, 0, 255, 255));
        for y in 2..7 {
            for x in 2..7 {
                img.put_pixel(x, y, px(20, 40, 200, 255));
            }
        }
        img.put_pixel(4, 4, px(255, 0, 255, 255));
        knockout(&mut img);

        assert_eq!(img.get_pixel(0, 0).0[3], 0, "the frame should be gone");
        assert_eq!(img.get_pixel(4, 4).0[3], 255, "the island should survive");
        assert_eq!(img.get_pixel(2, 2).0[3], 255);
    }

    #[test]
    fn a_character_is_packed_standing_on_the_floor_of_its_cell() {
        // A subject that is taller than it is wide, floating in the middle of
        // a magenta sheet: it should come back filling the cell's height with
        // its feet on the bottom row.
        let mut img = RgbaImage::from_pixel(100, 100, px(255, 0, 255, 255));
        for y in 20..80 {
            for x in 45..55 {
                img.put_pixel(x, y, px(20, 40, 200, 255));
            }
        }
        let (cell, b) = pack_character(&img);
        assert_eq!(cell.dimensions(), (CHAR_W, CHAR_H));
        assert_eq!(b.feet, CHAR_H as f32);
        assert_eq!(
            cell.get_pixel(CHAR_W / 2, CHAR_H - 1).0[3],
            255,
            "feet on the floor"
        );
        assert_eq!(cell.get_pixel(0, 0).0[3], 0, "the sheet is keyed away");
        assert!((b.cx - CHAR_W as f32 * 0.5).abs() < 3.0, "centred");
    }

    #[test]
    fn nearest_scale_hits_the_size_it_is_asked_for() {
        let img = RgbaImage::from_pixel(64, 32, px(1, 2, 3, 255));
        assert_eq!(nearest_scale(&img, 16, 16).dimensions(), (16, 16));
    }

    #[test]
    fn fit_long_leaves_a_small_image_alone() {
        let img = RgbaImage::from_pixel(64, 32, px(1, 2, 3, 255));
        assert_eq!(fit_long(&img, 128).dimensions(), (64, 32));
        assert_eq!(fit_long(&img, 32).dimensions(), (32, 16));
    }
}

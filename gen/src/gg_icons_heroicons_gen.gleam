//// Dev-only generator for gg_icons_heroicons. Run from this `gen/` project:
////
////     cd gen && gleam run
////
//// Reads the pinned upstream SVGs under `vendor/heroicons/`, bakes them through
//// the shared `gg_icon_gen` engine, and writes the sharded modules +
//// `internal.gleam` into `../src/gg_icons_heroicons`, plus `../icons.json`.
//// Never shipped.
////
//// Heroicons ships four variants, keyed upstream by size + style:
////   `outline` — 24×24 stroked, 1.5px caps, the DEFAULT. fill=none, stroke.
////   `solid`   — 24×24 solid glyph. fill=currentColor.
////   `mini`    — 20×20 solid glyph (upstream `20/solid`).
////   `micro`   — 16×16 solid glyph (upstream `16/solid`).
//// The three solid variants differ only in `view_box`; all paint with
//// `fill=currentColor`. Outline paths carry their own `stroke-linecap` /
//// `stroke-linejoin`, so they survive verbatim — the variant defaults stay the
//// minimal `fill`/`stroke`/`stroke-width`. Heroicons' inner markup is already
//// clean geometry (no bounding rect), so the `clean` hook is the identity.

import gg_icon_gen.{type Config, Config, Variant}
import gleam/io
import gleam/string

pub fn main() {
  case gg_icon_gen.generate(config()) {
    Ok(_) -> io.println("✓ generated gg_icons_heroicons")
    Error(e) -> io.println("✗ " <> string.inspect(e))
  }
}

fn config() -> Config {
  Config(
    set: "heroicons",
    module_prefix: "gg_icons_heroicons",
    out_src: "../src/gg_icons_heroicons",
    out_manifest: "../icons.json",
    variants: [
      // outline — the default variant: a 24×24 stroked glyph, 1.5px caps.
      Variant(
        name: "outline",
        is_default: True,
        view_box: "0 0 24 24",
        defaults: [
          #("fill", "none"),
          #("stroke", "currentColor"),
          #("stroke-width", "1.5"),
        ],
        source_dir: "vendor/heroicons/outline",
      ),
      // solid — a 24×24 solid glyph, no stroke.
      Variant(
        name: "solid",
        is_default: False,
        view_box: "0 0 24 24",
        defaults: [#("fill", "currentColor")],
        source_dir: "vendor/heroicons/solid",
      ),
      // mini — a 20×20 solid glyph (upstream 20/solid).
      Variant(
        name: "mini",
        is_default: False,
        view_box: "0 0 20 20",
        defaults: [#("fill", "currentColor")],
        source_dir: "vendor/heroicons/mini",
      ),
      // micro — a 16×16 solid glyph (upstream 16/solid).
      Variant(
        name: "micro",
        is_default: False,
        view_box: "0 0 16 16",
        defaults: [#("fill", "currentColor")],
        source_dir: "vendor/heroicons/micro",
      ),
    ],
    // Heroicons' inner markup is already clean geometry — no bounding rect.
    clean: fn(nodes) { nodes },
  )
}

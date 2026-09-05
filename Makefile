# CAUSEWAYBAY GO
# Usage: make / make help / make start / make test / make package
#
# Two ports of the same game, side by side:
#
#   love2d/      the desktop game (LÖVE), and the source of every question
#   typescript/  the web build (Rust to wasm + TypeScript, on Cloudflare)
#
# The web build has no questions of its own: `make web-data` dumps them out of
# love2d/src, so a fix to a blank reaches both with one edit.

.DEFAULT_GOAL := help
# The `web-%` pattern below is deliberately not listed here: make skips the
# implicit-rule search for a target it has been told is phony, so naming the
# web targets would turn every one of them into "nothing to be done".
.PHONY: help version start stop status test lint format drive \
        package love app notarize gatekeeper clean web

GAME := love2d
WEB  := typescript

help:
	@$(MAKE) --no-print-directory -C $(GAME) help
	@printf '%s\n' \
		'' \
		'  web (Rust to wasm + TypeScript, $(WEB)/)' \
		'make web-start serve it on http://localhost:5310' \
		'make web-stop  stop that server' \
		'make web-build production bundle in $(WEB)/dist' \
		'make web-data  dump love2d/src into $(WEB)/public/data/game.json' \
		'make web-art   shrink love2d/assets into $(WEB)/public/art' \
		'make web-test  Rust suite + browser-side suite' \
		'make web-e2e   Playwright, against a real browser' \
		'make web-e2e-dist  the same suite, against the Cloudflare bundle' \
		'make web-check everything CI runs for the web build' \
		'make web-deploy build, then wrangler deploy to Cloudflare' \
		'make web-clean remove web build output' \
		''

start stop status test lint format drive version:
	@$(MAKE) --no-print-directory -C $(GAME) $@

# Release: the .love, and on macOS a signed .app with LÖVE embedded, into ./dist
package love app notarize gatekeeper clean:
	@$(MAKE) --no-print-directory -C $(GAME) $@

# The web build lives in its own directory with its own Makefile, and its
# targets are reachable from here under a `web-` prefix so the two ports never
# argue over a name like `test` or `clean`.
web: web-start

web-%:
	@$(MAKE) --no-print-directory -C $(WEB) $*

# CAUSEWAYBAY GO — the web build
#
# Rust holds the rules and compiles to wasm; TypeScript is the shell that gives
# them a canvas, a keyboard, Web Audio and somewhere to save. Vite builds it and
# Cloudflare serves it.
#
#   make start   run it locally
#   make check   everything CI should run
#   make deploy  push it to Cloudflare
#
# Run from the repository root with `make web-start`, or from here.

.DEFAULT_GOAL := help
.PHONY: help deps data art wasm wasm-tools rust-target build start stop restart \
        test test-rust test-web e2e e2e-dist check fmt fmt-check lint \
        deploy deploy-workers clean

PORT     ?= 5310
CF_PORT  ?= 8790
PROJECT  ?= causewaybay-go
BRANCH   ?= main
COMPAT_DATE ?= 2026-09-05
PID      := .run/vite.pid
LOG      := .run/vite.log
CF_PID   := .run/wrangler.pid
GAME     ?= ../love2d
ART_SRC  ?= $(GAME)/assets
ART_OUT  := public/art
DATA_OUT := public/data/game.json
WASM_OUT := src/wasm
TARGET   := wasm32-unknown-unknown
RELEASE  := target/$(TARGET)/release/goset_core.wasm

# The CLI has to match the crate exactly or the glue it writes will not load
# the module it is given. Read it from the lock file rather than pinning a
# second copy of the number here.
WBG := $(shell awk '/^name = "wasm-bindgen"$$/{f=1} f&&/^version = /{gsub(/"/,"",$$3); print $$3; exit}' Cargo.lock)

help:
	@printf '%s\n' \
		'CAUSEWAYBAY GO (web)' \
		'' \
		'make start    build and serve on http://localhost:$(PORT)' \
		'make stop     stop that server' \
		'make build    production bundle in dist/' \
		'make data     dump love2d/src into public/data/game.json' \
		'make art      shrink love2d/assets into public/art' \
		'make wasm     compile the Rust rules to wasm' \
		'make test     Rust suite + browser-side suite' \
		'make e2e      Playwright, against a real browser' \
		'make e2e-dist the same suite, against the Cloudflare bundle' \
		'make check    lint + both suites + a type check (what CI runs)' \
		'make fmt      format the Rust' \
		'make deploy   build, then wrangler pages deploy' \
		'make clean    remove build output'

# ------------------------------------------------------------------ toolchain

deps: node_modules

node_modules: package.json
	npm install
	@touch node_modules

rust-target:
	@rustup target list --installed 2>/dev/null | grep -qx '$(TARGET)' \
		|| rustup target add $(TARGET)

# `cargo install` is slow and unconditional, so only reach for it when the
# installed CLI is missing or is not the version the lock file names.
wasm-tools:
	@have=$$(wasm-bindgen --version 2>/dev/null | awk '{print $$2}'); \
	if [ "$$have" != "$(WBG)" ]; then \
		echo "  installing wasm-bindgen-cli $(WBG) (have: $${have:-none})"; \
		cargo install -f wasm-bindgen-cli --version $(WBG); \
	else \
		echo "  wasm-bindgen-cli $(WBG)"; \
	fi

# ---------------------------------------------------------------------- build

# The questions are not committed: they are the Lua the desktop game reads,
# dumped. A fix to love2d/src/data.lua reaches both builds with one edit.
data: $(DATA_OUT)

$(DATA_OUT): $(wildcard $(GAME)/src/data*.lua) $(GAME)/src/quests.lua $(GAME)/src/i18n.lua \
             $(wildcard $(GAME)/src/lang/*.lua) $(GAME)/tools/dump_web.lua
	@command -v luajit >/dev/null 2>&1 || { \
		echo "  luajit not found - brew install luajit" >&2; exit 1; }
	@mkdir -p $(dir $(DATA_OUT))
	cd $(GAME) && luajit tools/dump_web.lua "$(abspath $(DATA_OUT))"

# Nor is the art: the sources are 48 MB of studio renders and the browser wants
# a few megabytes of them.
art: $(ART_OUT)/manifest.json

$(ART_OUT)/manifest.json: crates/mkassets/src/main.rs
	@test -d "$(ART_SRC)" || { \
		echo "  no art at $(ART_SRC) - set ART_SRC=" >&2; exit 1; }
	cargo run --release -q -p mkassets -- "$(ART_SRC)" "$(ART_OUT)"

wasm: $(WASM_OUT)/goset_core_bg.wasm

$(WASM_OUT)/goset_core_bg.wasm: $(wildcard crates/goset-core/src/*.rs) crates/goset-core/Cargo.toml
	@$(MAKE) --no-print-directory rust-target
	@$(MAKE) --no-print-directory wasm-tools
	cargo build --release --target $(TARGET) -p goset-core
	wasm-bindgen --target web \
		--out-dir $(WASM_OUT) --out-name goset_core $(RELEASE)
	@echo "  $(WASM_OUT)/goset_core_bg.wasm ($$(du -h $(WASM_OUT)/goset_core_bg.wasm | cut -f1))"

build: deps wasm data art
	npm run build

# ------------------------------------------------------------------ run local

start: deps wasm data art
	@mkdir -p .run
	@if [ -f $(PID) ] && kill -0 $$(cat $(PID)) 2>/dev/null; then \
		echo "  already running -> http://localhost:$(PORT)"; exit 0; fi
	@nohup npx vite --host 0.0.0.0 --port $(PORT) > $(LOG) 2>&1 & echo $$! > $(PID)
	@disown $$(cat $(PID)) 2>/dev/null || true
	@sleep 1
	@echo "  CAUSEWAYBAY GO -> http://localhost:$(PORT)"

stop:
	@if [ -f $(PID) ]; then kill $$(cat $(PID)) 2>/dev/null || true; rm -f $(PID); fi
	@if [ -f $(CF_PID) ]; then kill $$(cat $(CF_PID)) 2>/dev/null || true; rm -f $(CF_PID); fi
	@-lsof -ti tcp:$(PORT) | xargs kill 2>/dev/null || true
	@echo "  stopped"

restart: stop start

# --------------------------------------------------------------------- checks

# Most of the suite is Rust, because most of the game is: the quiz runs
# headless against the real game.json with no browser attached, which is the
# thing LÖVE could only ever test inside a window.
test-rust: data
	cargo test

test-web: deps
	npm test

test: test-rust test-web

e2e: deps wasm data art
	npx playwright test

# The same suite against the thing that actually ships: the production bundle
# served by Cloudflare's own runtime instead of by Vite.
#
# This is the only check that can catch the faults that live in the gap between
# the two — a wasm file served with the wrong content type (streaming
# instantiation refuses anything but application/wasm), an asset Vite resolved
# from source and never copied into dist, or a base path that only resolves
# under the dev server.
e2e-dist: build
	@mkdir -p .run
	@npx wrangler pages dev dist --port $(CF_PORT) --ip 127.0.0.1 \
		> .run/wrangler.log 2>&1 & echo $$! > $(CF_PID)
	@for i in $$(seq 1 60); do \
		curl -fsS -o /dev/null "http://127.0.0.1:$(CF_PORT)/" 2>/dev/null && break; \
		sleep 1; \
	done
	@# The wasm content type is worth asserting on its own: a wrong one fails
	@# at instantiation with an error that says nothing about MIME types.
	@type=$$(curl -fsS -o /dev/null -w '%{content_type}' \
		"http://127.0.0.1:$(CF_PORT)/$$(cd dist && ls assets/*.wasm)"); \
	case "$$type" in application/wasm*) echo "  wasm served as $$type";; \
		*) echo "  wasm served as '$$type', not application/wasm" >&2; \
		   kill $$(cat $(CF_PID)) 2>/dev/null; exit 1;; esac
	@E2E_BASE_URL="http://127.0.0.1:$(CF_PORT)" npx playwright test; \
		status=$$?; \
		kill $$(cat $(CF_PID)) 2>/dev/null || true; \
		rm -f $(CF_PID); \
		exit $$status

lint:
	cargo clippy --all-targets --all-features -- -D warnings

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

check: lint fmt-check test-rust build test-web

# Cloudflare Pages. The game is static, so this uploads dist/ and nothing runs
# on the server side.
#
# Credentials come from CLOUDFLARE_API_TOKEN in the environment, so there is no
# `wrangler login` step; the token needs the `Cloudflare Pages: Edit` scope.
# `--commit-dirty` because the tree is normally dirty during development and
# refusing to publish over that is not a useful safety net here.
deploy: build
	@# A first deploy has nothing to deploy into. Creating the project is
	@# idempotent enough to keep in the recipe: it fails loudly and harmlessly
	@# when the project is already there.
	@npx wrangler pages project list 2>/dev/null | grep -q '$(PROJECT)' \
		|| npx wrangler pages project create $(PROJECT) --production-branch $(BRANCH)
	npx wrangler pages deploy dist \
		--project-name $(PROJECT) --branch $(BRANCH) --commit-dirty=true

# The Workers Static Assets route instead. Same bundle, different product; it
# needs a token with `Workers Scripts: Edit`, which the Pages token does not
# carry. Kept because it is a one-line switch if the account ever moves.
deploy-workers: build
	npx wrangler deploy --assets dist --name $(PROJECT) \
		--compatibility-date $(COMPAT_DATE)

clean:
	rm -rf dist target $(WASM_OUT) $(ART_OUT) public/data .run .wrangler \
		test-results playwright-report

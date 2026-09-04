# CAUSEWAYBAY GO — Love2D
# Default: make help

GAME_DIR := $(CURDIR)
LOVE    := love
PIDFILE := $(CURDIR)/.goset-love.pid
LOGFILE := $(CURDIR)/.goset-love.log
SRC     := main.lua conf.lua src tests tools
RUST_DATA := src/data_rs.lua src/data_rs_adv.lua src/data_rs_pro.lua src/data_rs_quiz.lua src/data_rs_bigo.lua src/data_rs_callback.lua
PY_DATA   := src/data_py.lua src/data_py_adv.lua src/data_py_quiz.lua src/data_py_bigo.lua src/data_py_callback.lua src/data_py_mp.lua
CHIP_DATA := $(RUST_DATA) $(PY_DATA) src/data_bigo.lua src/data_callback.lua src/data_conc.lua
ALL_DATA  := src/data.lua src/data_adv.lua src/data_pro.lua src/data_quiz.lua $(CHIP_DATA)
STYLUA  := stylua

.DEFAULT_GOAL := help

.PHONY: help start run stop test lint format status drive version love package app notarize gatekeeper clean

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\n  CAUSEWAYBAY GO  //  Love2D\n\n"} \
		/^[a-zA-Z0-9_-]+:.*##/ { printf "  make %-10s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n  F1 portrait/landscape   F11 window/fullscreen   F6 share\n"
	@printf "  setup, progress, stats JSONL live in ~/.causewaybaygo\n"
	@printf "  exports (md csv jsonl txt sqlite png) land in ~/Downloads\n\n"

start: ## Run the game (background)
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "already running  pid $$(cat "$(PIDFILE)")"; \
	else \
		: > "$(LOGFILE)"; \
		nohup $(LOVE) "$(GAME_DIR)" >"$(LOGFILE)" 2>&1 & echo $$! > "$(PIDFILE)"; \
		sleep 0.8; \
		if ! kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
			echo "start failed — see $(LOGFILE)"; \
			rm -f "$(PIDFILE)"; \
			cat "$(LOGFILE)"; \
			exit 1; \
		fi; \
		if grep -q '^Error:' "$(LOGFILE)" 2>/dev/null; then \
			echo "start failed — see $(LOGFILE)"; \
			kill $$(cat "$(PIDFILE)") 2>/dev/null || true; \
			rm -f "$(PIDFILE)"; \
			cat "$(LOGFILE)"; \
			exit 1; \
		fi; \
		echo "started  pid $$(cat "$(PIDFILE)")"; \
	fi

run: start ## Alias for start

stop: ## Stop the game
	@if [ -f "$(PIDFILE)" ]; then \
		pid=$$(cat "$(PIDFILE)"); \
		kill $$pid 2>/dev/null || true; \
		rm -f "$(PIDFILE)"; \
		echo "stopped  pid $$pid"; \
	else \
		pkill -f "love $(GAME_DIR)" 2>/dev/null || true; \
		echo "stopped"; \
	fi

status: ## Is the game running?
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "running  pid $$(cat "$(PIDFILE)")"; \
	else \
		echo "not running"; \
	fi

test: ## Run the Love2D test suite
	@GOSET_TEST=1 GOSET_HOME="$(GAME_DIR)/.test-home" GOSET_DOWNLOADS="$(GAME_DIR)/.test-home/downloads" $(LOVE) "$(GAME_DIR)" --test; \
	status=$$?; \
	rm -rf "$(GAME_DIR)/.test-home"; \
	exit $$status

drive: ## Replay a scripted session: make drive SCRIPT=tests/drive/all.lua
	@test -n "$(SCRIPT)" || { echo "usage: make drive SCRIPT=path/to/script.lua"; exit 1; }
	@GOSET_HOME="$(GAME_DIR)/.drive-home" GOSET_DOWNLOADS="$(GAME_DIR)/.drive-home/downloads" GOSET_DRIVE="$(SCRIPT)" $(LOVE) "$(GAME_DIR)"; \
	status=$$?; \
	rm -rf "$(GAME_DIR)/.drive-home"; \
	echo "screenshots: ~/Library/Application Support/LOVE/goset-causewaybay"; \
	exit $$status

lint: ## Check the street data without LÖVE (luajit)
	@command -v luajit >/dev/null 2>&1 || { echo "luajit not found — brew install luajit"; exit 1; }
	luajit tools/lint_data.lua $(CHIP_DATA)
	@# a first-tier hint that spells its own answer defeats the two-tier HINT
	luajit tools/hint_leaks.lua $(ALL_DATA)

format: ## Format Lua with stylua
	@command -v $(STYLUA) >/dev/null 2>&1 || { \
		echo "stylua not found — brew install stylua"; \
		exit 1; \
	}
	$(STYLUA) $(SRC)

# ------------------------------------------------------------------ package
#
# What a release ships. `make package` produces, in ../dist:
#
#   causewaybaygo-<version>.love  the game as one archive, for any OS with LÖVE
#   CausewaybayGo-macos.zip       a double-clickable macOS .app with LÖVE 11.5
#                                 embedded, signed (Developer ID when the
#                                 machine has one, ad-hoc otherwise)
#
# Signing follows lovegui in CausewaybayWallet: nested binaries first, then the
# executable, then the bundle, every stage with the entitlements LuaJIT needs
# under the hardened runtime. `make notarize` is a separate step because it
# needs Apple credentials and uploads the bundle; the release workflow runs it
# when the secrets are there.

VERSION      := $(shell cat $(CURDIR)/../VERSION 2>/dev/null | tr -d '[:space:]')
LOVE_VERSION ?= 11.5
APP_NAME     := CausewaybayGo
DISPLAY_NAME := CAUSEWAYBAY GO
BUNDLE_ID    := com.causewaybay.go
ICON         ?= assets/item_set.png
LOVE_URL     := https://github.com/love2d/love/releases/download/$(LOVE_VERSION)/love-$(LOVE_VERSION)-macos.zip
DIST_DIR     ?= $(abspath $(CURDIR)/../dist)
BUILD        := $(CURDIR)/build
APP          := $(BUILD)/$(APP_NAME).app
GAME_LOVE    := $(DIST_DIR)/causewaybaygo-$(VERSION).love
GAME_SRC     := main.lua conf.lua src assets

.PHONY: version
version: ## Print the version of record (../VERSION)
	@test -n "$(VERSION)" || { echo "no ../VERSION file" >&2; exit 1; }
	@echo "$(VERSION)"

# The .love: the sources a player needs, nothing else. Tests and the drive
# scripts stay out; a glob on `*.lua` keeps a new module beside main.lua from
# being forgotten, and verify-archive checks it landed.
.PHONY: love
love: ## Build the .love archive into ../dist
	@test -n "$(VERSION)" || { echo "no ../VERSION file" >&2; exit 1; }
	@mkdir -p "$(DIST_DIR)" "$(BUILD)"
	@rm -rf "$(BUILD)/stage" "$(GAME_LOVE)" && mkdir -p "$(BUILD)/stage"
	@cp -R $(GAME_SRC) "$(BUILD)/stage/"
	@find "$(BUILD)/stage" -name '.DS_Store' -delete
	@cd "$(BUILD)/stage" && zip -qr9 -X "$(GAME_LOVE)" .
	@rm -rf "$(BUILD)/stage"
	@$(MAKE) --no-print-directory verify-archive ARCHIVE="$(GAME_LOVE)"
	@echo "  $(GAME_LOVE)"

# Every module the game requires has to be in the archive. A missing one dies
# on the first `require` — on somebody else's machine, since the checkout it
# was built from has the file right there.
.PHONY: verify-archive
verify-archive:
	@missing=""; \
	for file in main.lua conf.lua $$(find src -name '*.lua' | sort); do \
		unzip -l "$(ARCHIVE)" 2>/dev/null | grep -qE " $$file$$" || missing="$$missing $$file"; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "  the archive is missing:$$missing" >&2; \
		exit 1; \
	fi; \
	echo "  archive carries every module ($$(find src -name '*.lua' | wc -l | tr -d ' ') + 2 files)"

.PHONY: package
package: ## Build the release: .love, plus a signed macOS .app on macOS
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		$(MAKE) --no-print-directory app; \
		cp -f "$(BUILD)/$(APP_NAME)-macos.zip" "$(DIST_DIR)/$(APP_NAME)-macos.zip"; \
	else \
		$(MAKE) --no-print-directory love; \
		echo "  not macOS: the .app is skipped, the .love is the release"; \
	fi
	@echo
	@echo "  $(DIST_DIR):"
	@ls -1lh "$(DIST_DIR)" | tail -n +2 | awk '{printf "    %-28s %s\n", $$9, $$5}'

# A real double-clickable .app: LÖVE downloaded and embedded, the game inside
# it, the icon from the game's own art, signed and zipped.
.PHONY: app
app: love ## Build a double-clickable macOS .app with LÖVE embedded
	@test "$$(uname -s)" = "Darwin" || { echo "  'make app' is macOS only." >&2; exit 1; }
	@rm -rf "$(APP)" "$(BUILD)/love-macos" "$(BUILD)/$(APP_NAME)-macos.zip"
	@mkdir -p "$(BUILD)"
	@if [ ! -f "$(BUILD)/love-$(LOVE_VERSION)-macos.zip" ]; then \
		echo "  fetching LÖVE $(LOVE_VERSION)"; \
		curl -fsSL -o "$(BUILD)/love-$(LOVE_VERSION)-macos.zip" "$(LOVE_URL)"; \
	fi
	@unzip -q -o "$(BUILD)/love-$(LOVE_VERSION)-macos.zip" -d "$(BUILD)/love-macos"
	@mv "$(BUILD)/love-macos/love.app" "$(APP)"
	@rm -rf "$(BUILD)/love-macos"
	@cp "$(GAME_LOVE)" "$(APP)/Contents/Resources/game.love"

	@# Without these the bundle is still "LÖVE" everywhere macOS shows a name,
	@# and two LÖVE games installed at once collide on the bundle id.
	@plutil -replace CFBundleName -string "$(DISPLAY_NAME)" "$(APP)/Contents/Info.plist"
	@plutil -replace CFBundleDisplayName -string "$(DISPLAY_NAME)" "$(APP)/Contents/Info.plist"
	@plutil -replace CFBundleIdentifier -string "$(BUNDLE_ID)" "$(APP)/Contents/Info.plist"
	@plutil -replace CFBundleShortVersionString -string "$(VERSION)" "$(APP)/Contents/Info.plist"
	@plutil -replace CFBundleVersion -string "$(VERSION)" "$(APP)/Contents/Info.plist"
	@# LÖVE registers .love as a document type so a dropped file runs. This
	@# bundle is one game and must not open somebody else's.
	@plutil -remove CFBundleDocumentTypes "$(APP)/Contents/Info.plist" 2>/dev/null || true
	@plutil -remove UTExportedTypeDeclarations "$(APP)/Contents/Info.plist" 2>/dev/null || true
	@plutil -replace NSHighResolutionCapable -bool true "$(APP)/Contents/Info.plist"

	@$(MAKE) --no-print-directory app-icon
	@$(MAKE) --no-print-directory app-sign

	@# Skipped where there is no window server: a CI runner cannot open the
	@# window the suite needs. verify-archive above still ran there.
	@if [ -n "$(SKIP_SMOKE)" ]; then \
		echo "  smoke test skipped (SKIP_SMOKE set)"; \
	else \
		$(MAKE) --no-print-directory app-smoke; \
	fi

	@cd "$(BUILD)" && ditto -c -k --sequesterRsrc --keepParent "$(APP_NAME).app" "$(APP_NAME)-macos.zip"
	@echo
	@echo "  $(APP)"
	@du -sh "$(APP)" "$(BUILD)/$(APP_NAME)-macos.zip" | sed 's/^/    /'
	@echo "  Open it with: open \"$(APP)\""

# The icon, from the morning set that is already on the title card. Every size
# is generated from the 1024px source.
.PHONY: app-icon
app-icon:
	@test -f "$(ICON)" || { echo "  no $(ICON); keeping LÖVE's icon"; exit 0; }
	@rm -rf "$(BUILD)/icon.iconset" && mkdir -p "$(BUILD)/icon.iconset"
	@for size in 16 32 64 128 256 512 1024; do \
		sips -s format png -z $$size $$size "$(ICON)" \
			--out "$(BUILD)/icon.iconset/icon_$${size}x$${size}.png" > /dev/null 2>&1; \
	done
	@for size in 16 32 128 256 512; do \
		double=$$((size * 2)); \
		cp "$(BUILD)/icon.iconset/icon_$${double}x$${double}.png" \
			"$(BUILD)/icon.iconset/icon_$${size}x$${size}@2x.png" 2>/dev/null || true; \
	done
	@rm -f "$(BUILD)/icon.iconset/icon_1024x1024.png"
	@iconutil -c icns "$(BUILD)/icon.iconset" -o "$(BUILD)/icon.icns"
	@cp "$(BUILD)/icon.icns" "$(APP)/Contents/Resources/OS X AppIcon.icns" 2>/dev/null || true
	@cp "$(BUILD)/icon.icns" "$(APP)/Contents/Resources/Love.icns" 2>/dev/null || true
	@rm -rf "$(BUILD)/icon.iconset" "$(BUILD)/icon.icns"
	@echo "  icon from $(ICON)"

# Signed inside-out: nested binaries, then the frameworks, then the
# executable, then the bundle. Signing the outer bundle first invalidates it
# the moment anything inside is signed afterwards.
#
# The entitlements are LuaJIT's: the hardened runtime kills the app the moment
# LuaJIT compiles anything unless it may JIT and use unsigned executable
# memory. APPLE_SIGNING_IDENTITY wins when set (the release workflow exports
# it); a keychain search is the laptop path; ad-hoc is the fallback, which
# runs here and nowhere else without a right-click Open.
.PHONY: app-sign
app-sign:
	@test -d "$(APP)" || { echo "  no $(APP); run 'make app'" >&2; exit 1; }
	@rm -f "$(BUILD)/entitlements.plist"
	@printf '%s\n' \
		'<?xml version="1.0" encoding="UTF-8"?>' \
		'<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' \
		'<plist version="1.0"><dict>' \
		'  <key>com.apple.security.cs.allow-jit</key><true/>' \
		'  <key>com.apple.security.cs.allow-unsigned-executable-memory</key><true/>' \
		'  <key>com.apple.security.cs.disable-library-validation</key><true/>' \
		'</dict></plist>' \
		> "$(BUILD)/entitlements.plist"
	@identity="$${APPLE_SIGNING_IDENTITY:-}"; \
	if [ -z "$$identity" ] || [ "$$identity" = "-" ]; then \
		identity=$$(security find-identity -v -p codesigning 2>/dev/null \
			| grep "Developer ID Application" | head -1 | awk -F'"' '{print $$2}'); \
	fi; \
	if [ -z "$$identity" ]; then \
		identity="-"; \
		echo "  no Developer ID found - signing ad-hoc (runs here, not elsewhere)"; \
	else \
		echo "  signing as $$identity"; \
	fi; \
	stamp=--timestamp; \
	[ "$$identity" = "-" ] && stamp=""; \
	find "$(APP)/Contents/Frameworks" -type f 2>/dev/null | while read -r file; do \
		if file "$$file" | grep -q "Mach-O"; then \
			codesign --force --options runtime --sign "$$identity" \
				--entitlements "$(BUILD)/entitlements.plist" $$stamp "$$file" || exit 1; \
		fi; \
	done; \
	find "$(APP)/Contents/Frameworks" -maxdepth 1 -name "*.framework" 2>/dev/null | while read -r bundle; do \
		codesign --force --options runtime --sign "$$identity" \
			--entitlements "$(BUILD)/entitlements.plist" $$stamp "$$bundle" || exit 1; \
	done; \
	codesign --force --options runtime --sign "$$identity" \
		--entitlements "$(BUILD)/entitlements.plist" $$stamp \
		"$(APP)/Contents/MacOS/love" || exit 1; \
	codesign --force --options runtime --sign "$$identity" \
		--entitlements "$(BUILD)/entitlements.plist" $$stamp "$(APP)" || exit 1
	@rm -f "$(BUILD)/entitlements.plist"
	@codesign --verify --deep --strict "$(APP)" && echo "  signature verifies"

# Run the test suite from inside the bundle. verify-archive proves every file
# is present; this proves they add up to a program, on the binary that ships
# rather than the checkout.
.PHONY: app-smoke
app-smoke:
	@test -d "$(APP)" || { echo "  no $(APP); run 'make app'" >&2; exit 1; }
	@rm -rf "$(BUILD)/smoke-home"
	@GOSET_TEST=1 GOSET_HOME="$(BUILD)/smoke-home" "$(APP)/Contents/MacOS/love" > "$(BUILD)/smoke.log" 2>&1; \
	status=$$?; \
	rm -rf "$(BUILD)/smoke-home"; \
	if [ $$status -ne 0 ]; then \
		echo "  the bundle failed its own test suite:" >&2; \
		tail -30 "$(BUILD)/smoke.log" >&2; \
		exit 1; \
	fi
	@rm -f "$(BUILD)/smoke.log"
	@echo "  the bundle runs its test suite and passes"

# Signing is necessary and not sufficient: since macOS 10.15 anything handed
# out outside the App Store must also be notarised, or a downloaded copy gets
# "Apple could not verify…". Needs credentials this repository does not carry:
#
#     export APPLE_ID=you@example.com
#     export APPLE_PASSWORD=abcd-efgh-ijkl-mnop   # app-specific
#     export APPLE_TEAM_ID=ABCDE12345
#     make notarize
.PHONY: notarize
notarize: ## Notarize and staple the built .app (needs Apple credentials)
	@test -d "$(APP)" || { echo "  no $(APP); run 'make app' first" >&2; exit 1; }
	@for name in APPLE_ID APPLE_PASSWORD APPLE_TEAM_ID; do \
		eval "value=\$$$$name"; \
		[ -n "$$value" ] || { \
			echo "  $$name is not set." >&2; \
			echo "  Notarising needs an Apple ID, an app-specific password" >&2; \
			echo "  from appleid.apple.com, and the team id." >&2; \
			exit 1; }; \
	done
	@codesign -dv --verbose=2 "$(APP)" 2>&1 | grep -q "Authority=Developer ID Application" || { \
		echo "  $(APP) is not signed with a Developer ID." >&2; \
		echo "  Apple refuses an ad-hoc signature; there is nothing to submit." >&2; \
		exit 1; }
	@echo "  submitting to Apple - this takes minutes, not seconds"
	@ditto -c -k --sequesterRsrc --keepParent "$(APP)" "$(BUILD)/notarize.zip"
	@xcrun notarytool submit "$(BUILD)/notarize.zip" \
		--apple-id "$$APPLE_ID" \
		--password "$$APPLE_PASSWORD" \
		--team-id "$$APPLE_TEAM_ID" \
		--wait --timeout 20m
	@rm -f "$(BUILD)/notarize.zip"
	@xcrun stapler staple "$(APP)"
	@xcrun stapler validate "$(APP)"
	@# The zip was made before stapling and carries an unstapled copy.
	@rm -f "$(BUILD)/$(APP_NAME)-macos.zip"
	@cd "$(BUILD)" && ditto -c -k --sequesterRsrc --keepParent \
		"$(APP_NAME).app" "$(APP_NAME)-macos.zip"
	@cp -f "$(BUILD)/$(APP_NAME)-macos.zip" "$(DIST_DIR)/$(APP_NAME)-macos.zip"
	@$(MAKE) --no-print-directory gatekeeper

# What a person who downloads it will get. `--context context:primary-signature`
# is the question Finder asks: plain `spctl -a` accepts an un-notarised
# Developer ID bundle, and Finder does not.
.PHONY: gatekeeper
gatekeeper: ## Assess the bundle the way Finder does
	@test -d "$(APP)" || { echo "  no $(APP); run 'make app' first" >&2; exit 1; }
	@codesign --verify --deep --strict "$(APP)" && echo "  signature: valid"
	@if xcrun stapler validate "$(APP)" > /dev/null 2>&1; then \
		echo "  notarised: yes, and stapled"; \
	else \
		echo "  notarised: NO - a downloaded copy will be blocked"; \
	fi
	@spctl -a -vvv -t open --context context:primary-signature "$(APP)" 2>&1 \
		| sed 's/^/  /' || true

.PHONY: clean
clean: ## Remove build/ and ../dist
	@rm -rf "$(BUILD)" "$(DIST_DIR)"
	@echo "  cleaned"

# GO SET — Love2D Causeway Bay
# Default: make help

APP     := $(CURDIR)
LOVE    := love
PIDFILE := $(CURDIR)/.goset-love.pid
LOGFILE := $(CURDIR)/.goset-love.log
SRC     := main.lua conf.lua src tests
STYLUA  := stylua

.DEFAULT_GOAL := help

.PHONY: help start run stop test format status drive

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\n  GO SET  //  Love2D\n\n"} \
		/^[a-zA-Z0-9_-]+:.*##/ { printf "  make %-10s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n  F1 portrait/landscape   F11 window/fullscreen\n"
	@printf "  setup JSONL lives in ~/.causewaybaygo\n\n"

start: ## Run the game (background)
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "already running  pid $$(cat "$(PIDFILE)")"; \
	else \
		: > "$(LOGFILE)"; \
		nohup $(LOVE) "$(APP)" >"$(LOGFILE)" 2>&1 & echo $$! > "$(PIDFILE)"; \
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
		pkill -f "love $(APP)" 2>/dev/null || true; \
		echo "stopped"; \
	fi

status: ## Is the game running?
	@if [ -f "$(PIDFILE)" ] && kill -0 $$(cat "$(PIDFILE)") 2>/dev/null; then \
		echo "running  pid $$(cat "$(PIDFILE)")"; \
	else \
		echo "not running"; \
	fi

test: ## Run the Love2D test suite
	@GOSET_TEST=1 GOSET_HOME="$(APP)/.test-home" $(LOVE) "$(APP)" --test; \
	status=$$?; \
	rm -rf "$(APP)/.test-home"; \
	exit $$status

drive: ## Replay a scripted session: make drive SCRIPT=tests/drive/all.lua
	@test -n "$(SCRIPT)" || { echo "usage: make drive SCRIPT=path/to/script.lua"; exit 1; }
	@GOSET_HOME="$(APP)/.drive-home" GOSET_DRIVE="$(SCRIPT)" $(LOVE) "$(APP)"; \
	status=$$?; \
	rm -rf "$(APP)/.drive-home"; \
	echo "screenshots: ~/Library/Application Support/LOVE/goset-causewaybay"; \
	exit $$status

format: ## Format Lua with stylua
	@command -v $(STYLUA) >/dev/null 2>&1 || { \
		echo "stylua not found — brew install stylua"; \
		exit 1; \
	}
	$(STYLUA) $(SRC)

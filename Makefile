.PHONY: start stop test help version package notarize gatekeeper clean

help:
	@$(MAKE) -C love2d help

start:
	@$(MAKE) -C love2d start

stop:
	@$(MAKE) -C love2d stop

test:
	@$(MAKE) -C love2d test

version:
	@$(MAKE) --no-print-directory -C love2d version

# Release: the .love, and on macOS a signed .app with LÖVE embedded, into ./dist
package:
	@$(MAKE) --no-print-directory -C love2d package

# Notarize and staple the .app (APPLE_ID, APPLE_PASSWORD, APPLE_TEAM_ID)
notarize:
	@$(MAKE) --no-print-directory -C love2d notarize

gatekeeper:
	@$(MAKE) --no-print-directory -C love2d gatekeeper

clean:
	@$(MAKE) --no-print-directory -C love2d clean

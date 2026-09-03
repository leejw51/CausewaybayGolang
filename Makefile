.PHONY: start stop test help

help:
	@$(MAKE) -C love2d help

start:
	@$(MAKE) -C love2d start

stop:
	@$(MAKE) -C love2d stop

test:
	@$(MAKE) -C love2d test

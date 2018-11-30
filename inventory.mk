#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

inventory/.stone: inventory.jsonnet; jsonnet -m $(@D) -S $< && touch $@

main: inventory/.stone
.PHONY: main

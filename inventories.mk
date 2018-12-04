#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

inventory/.stone: inventories.jsonnet nodes-lxc.jsonnet nodes-oxa.jsonnet; jsonnet -m $(@D) -S $< && touch $@

main: inventory/.stone
.PHONY: main

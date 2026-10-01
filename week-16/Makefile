CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror -Wconversion -Wsign-conversion -ffp-contract=off -fno-lto
ifeq ($(MODE),debug)
FLAGS = $(STRICT) -O0 -g
else ifeq ($(MODE),optimized)
FLAGS = $(STRICT) -O2 -g
else ifeq ($(MODE),sanitize)
FLAGS = $(STRICT) -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer
LINK = -no-pie
else
$(error MODE must be debug, optimized, or sanitize)
endif
ifeq ($(filter $(PACKAGE),learner instructor),)
$(error PACKAGE must be learner or instructor)
endif
BUILD = build/$(PACKAGE)/$(notdir $(CC))/$(MODE)
SRC = $(PACKAGE)/src
LAB = $(addprefix $(SRC)/,local.c static.c owner.c)
SUPPORT = support/allocator.c
HEADERS = include/lab.h support/allocator.h
INC = -Iinclude -Isupport
.PHONY: all test warmups inventory verify starters clean
all: $(BUILD)/playground $(BUILD)/warmups
$(BUILD):
	mkdir -p "$@"
$(BUILD)/playground: support/playground.c $(LAB) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(LINK) $(INC) $< $(LAB) $(SUPPORT) -lm -o $@
$(BUILD)/contracts: tests/contracts.c $(LAB) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(LINK) $(INC) $< $(LAB) $(SUPPORT) -lm -o $@
$(BUILD)/warmups: tests/warmups.c $(addprefix $(SRC)/,w01.c w02.c w03.c) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(LINK) $(INC) $< $(addprefix $(SRC)/,w01.c w02.c w03.c) -o $@
warmups: $(BUILD)/warmups
	$(BUILD)/warmups
inventory:
	$(PYTHON) tests/inventory.py
test: all $(BUILD)/contracts inventory
	$(BUILD)/contracts
	$(BUILD)/warmups
	$(PYTHON) tests/check.py $(BUILD)
starters:
	$(MAKE) PACKAGE=learner CC=gcc MODE=debug all
	$(MAKE) PACKAGE=learner CC=clang MODE=debug all
	$(PYTHON) tests/starters.py
verify:
	$(MAKE) PACKAGE=instructor CC=gcc MODE=debug test
	$(MAKE) PACKAGE=instructor CC=clang MODE=debug test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=clang MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=sanitize test
	$(MAKE) PACKAGE=instructor CC=clang MODE=sanitize test
	$(MAKE) starters
	$(PYTHON) tests/snippets.py
	$(PYTHON) tests/diagnose.py
clean:
	rm -rf -- build

.PHONY: diagnose
diagnose:
	$(PYTHON) tests/diagnose.py

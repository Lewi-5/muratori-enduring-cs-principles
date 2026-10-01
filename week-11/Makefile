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
LAB = $(addprefix $(SRC)/,abi.c wrappers.c fold.c calls.c)
SUPPORT = support/local.c support/geolab/geo.c support/geolab/query.c
HEADERS = include/lab.h $(wildcard support/geolab/*.h)
INC = -Iinclude -Isupport/geolab
.PHONY: all test warmups inventory inspect verify starters probe clean
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
inspect:
	$(PYTHON) tools/inspect.py $(CC) $(MODE) $(PACKAGE)
$(BUILD)/probe.o: instructor/probe.S | $(BUILD)
	$(CC) -c $< -o $@
$(BUILD)/probe: tests/probe.c $(BUILD)/probe.o
	$(CC) $(FLAGS) $(LINK) $^ -o $@
probe: $(BUILD)/probe
	$(BUILD)/probe
starters:
	$(MAKE) PACKAGE=learner CC=gcc MODE=debug all
	$(MAKE) PACKAGE=learner CC=clang MODE=debug all
	$(PYTHON) tests/starters.py
verify:
	$(MAKE) PACKAGE=instructor CC=gcc MODE=debug test inspect probe
	$(MAKE) PACKAGE=instructor CC=clang MODE=debug test inspect probe
	$(MAKE) PACKAGE=instructor CC=gcc MODE=optimized test inspect probe
	$(MAKE) PACKAGE=instructor CC=clang MODE=optimized test inspect probe
	$(MAKE) PACKAGE=instructor CC=gcc MODE=sanitize test probe
	$(MAKE) PACKAGE=instructor CC=clang MODE=sanitize test probe
	$(MAKE) starters
	$(PYTHON) tests/snippets.py
clean:
	rm -rf -- build

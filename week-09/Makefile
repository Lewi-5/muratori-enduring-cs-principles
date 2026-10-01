CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror -Wconversion -Wsign-conversion
ifeq ($(MODE),debug)
FLAGS = $(STRICT) -O0 -g
else ifeq ($(MODE),optimized)
FLAGS = $(STRICT) -O2
else ifeq ($(MODE),sanitize)
FLAGS = $(STRICT) -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer
EXE_FLAGS = -no-pie
else
$(error MODE must be debug, optimized, or sanitize)
endif
ifeq ($(filter $(PACKAGE),learner instructor),)
$(error PACKAGE must be learner or instructor)
endif
BUILD = build/$(PACKAGE)/$(notdir $(CC))/$(MODE)
SRC = $(PACKAGE)/src
SIM = $(addprefix $(SRC)/,address.c decode.c execute.c run.c)
SUPPORT = $(addprefix support/decoder/,address.c decode.c format.c) support/alu/registers.c support/alu/alu.c
HEADERS = include/machine.h support/alu/sim.h support/decoder/decode.h support/decoder/address.h
INCLUDES = -Iinclude -Isupport/alu -Isupport/decoder
.PHONY: all test warmups inventory verify starters clean
all: $(BUILD)/sim8086 $(BUILD)/playground $(BUILD)/warmups
$(BUILD):
	mkdir -p "$@"
$(BUILD)/sim8086: support/driver.c $(SIM) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(SUPPORT) -o $@
$(BUILD)/playground: support/playground.c $(SIM) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(SUPPORT) -o $@
$(BUILD)/contracts: tests/contracts.c $(SIM) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(SUPPORT) -o $@
$(BUILD)/warmups: tests/warmups.c $(addprefix $(SRC)/,w01.c w02.c w03.c) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(addprefix $(SRC)/,w01.c w02.c w03.c) -o $@
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
clean:
	rm -rf -- build

.PHONY: extras
extras: $(BUILD)/predicates
	$(BUILD)/predicates
$(BUILD)/predicates: extras/predicates.c $(SIM) $(SUPPORT) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(SUPPORT) -o $@

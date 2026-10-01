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
SRC = $(PACKAGE)/src
BUILD = build/$(PACKAGE)/$(notdir $(CC))/$(MODE)
DECODE = $(addprefix support/decoder/,address.c decode.c format.c)
SIM = $(addprefix $(SRC)/,registers.c alu.c execute.c run.c)
HEADERS = include/sim.h support/decoder/decode.h support/decoder/address.h
INCLUDES = -Iinclude -Isupport/decoder
.PHONY: all test inventory warmups verify starters extras clean
all: $(BUILD)/sim8086 $(BUILD)/playground $(BUILD)/warmups
$(BUILD):
	mkdir -p "$@"
$(BUILD)/sim8086: $(SRC)/sim8086.c $(SIM) $(DECODE) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(DECODE) -o $@
$(BUILD)/playground: $(SRC)/playground.c $(SIM) $(DECODE) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(DECODE) -o $@
$(BUILD)/contracts: tests/contracts.c $(SIM) $(DECODE) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(DECODE) -o $@
$(BUILD)/oracle_probe: tests/oracle_probe.c $(SIM) $(DECODE) $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $< $(SIM) $(DECODE) -o $@
$(BUILD)/warmups: $(addprefix $(SRC)/,w01.c w02.c w03.c) tests/warmups.c | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) $^ -o $@
warmups: $(BUILD)/warmups
	$(BUILD)/warmups
inventory:
	$(PYTHON) tests/inventory.py
test: all $(BUILD)/contracts $(BUILD)/oracle_probe inventory
	$(BUILD)/contracts
	$(BUILD)/warmups
	$(PYTHON) tests/check.py --build $(BUILD)
verify:
	$(MAKE) PACKAGE=instructor CC=gcc MODE=debug test
	$(MAKE) PACKAGE=instructor CC=clang MODE=debug test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=clang MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=sanitize test
	$(MAKE) PACKAGE=instructor CC=clang MODE=sanitize test
	$(MAKE) starters
starters:
	$(MAKE) PACKAGE=learner CC=gcc MODE=debug all
	$(MAKE) PACKAGE=learner CC=clang MODE=debug all
	$(PYTHON) tests/starters.py
extras: $(BUILD)/playground
	$(CC) $(FLAGS) $(EXE_FLAGS) $(INCLUDES) instructor/extras/predicates.c $(SIM) $(DECODE) -o $(BUILD)/predicates
	$(BUILD)/predicates
clean:
	rm -rf -- build

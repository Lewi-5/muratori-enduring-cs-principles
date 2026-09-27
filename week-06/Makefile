# Run from week-06 on Linux/WSL. Compiler, flags and package get distinct build directories.
# The instructor (reference) build adds -Wconversion -Wsign-conversion: this week is about exact integer conversions.
CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror
ifeq ($(PACKAGE),instructor)
STRICT += -Wconversion -Wsign-conversion
endif
ifeq ($(MODE),debug)
FLAGS = $(STRICT) -O0
else ifeq ($(MODE),optimized)
FLAGS = $(STRICT) -O2
else ifeq ($(MODE),sanitize)
FLAGS = $(STRICT) -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie
LINK_FLAGS = -no-pie
else
$(error MODE must be debug, optimized, or sanitize)
endif
ifeq ($(filter $(PACKAGE),learner instructor),)
$(error PACKAGE must be learner or instructor)
endif
SRC = $(PACKAGE)/src
BUILD = build/$(PACKAGE)/$(notdir $(CC))/$(MODE)
EXERCISES = 01 02 03 04 05
PROGRAMS = $(addprefix $(BUILD)/ex,$(EXERCISES)) $(BUILD)/decode8086
HEADERS = support/decode_types.h

.PHONY: all test inventory symbols verify starters mutate clean
all: $(PROGRAMS)
$(BUILD):
	mkdir -p "$@"
$(BUILD)/ex%: $(SRC)/ex%.c $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@
$(BUILD)/decode.o: $(SRC)/decode.c $(SRC)/decode.h $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) -Isupport -c $< -o $@
$(BUILD)/decode8086.o: $(SRC)/decode8086.c $(SRC)/decode.h $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) -Isupport -c $< -o $@
$(BUILD)/decode8086: $(BUILD)/decode.o $(BUILD)/decode8086.o
	$(CC) $(FLAGS) $(LINK_FLAGS) $^ -o $@
test: all inventory
	$(PYTHON) tests/check.py --build $(BUILD) --source $(SRC) --cc $(CC) --flags '$(FLAGS) $(LINK_FLAGS)'
inventory:
	$(PYTHON) tests/inventory.py
symbols: all
	nm -g --defined-only $(BUILD)/decode.o $(BUILD)/decode8086.o
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
	$(PYTHON) tests/starters.py --cc gcc
	$(PYTHON) tests/starters.py --cc clang
mutate:
	$(PYTHON) instructor/extras/mutate.py
clean:
	rm -rf -- build

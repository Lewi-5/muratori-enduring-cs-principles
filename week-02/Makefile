# Run from week-02 on Linux/WSL. Compiler/flags/source changes get distinct builds.
CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -fno-common -std=c11 -Wall -Wextra -Wpedantic -Werror
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
EXERCISES = 01 02 03 04 05 06 07 08 10
PROGRAMS = $(addprefix $(BUILD)/ex,$(EXERCISES)) $(BUILD)/ex09

.PHONY: all test inventory verify starters symbols inspect clean
all: $(PROGRAMS)
$(BUILD):
	mkdir -p "$@"
$(BUILD)/ex%: $(SRC)/ex%.c support/platform.h | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@
$(BUILD)/ex09_%.o: $(SRC)/ex09_%.c $(SRC)/ex09_data.h | $(BUILD)
	$(CC) $(FLAGS) -c $< -o $@
$(BUILD)/ex09: $(BUILD)/ex09_main.o $(BUILD)/ex09_data.o
	$(CC) $(FLAGS) $(LINK_FLAGS) $^ -o $@
test: all inventory
	$(PYTHON) tests/check.py --build $(BUILD) --source $(SRC) --cc $(CC) --flags '$(FLAGS) $(LINK_FLAGS)'
inventory:
	$(PYTHON) tests/inventory.py
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
symbols: all
	nm $(BUILD)/ex09_main.o $(BUILD)/ex09_data.o $(BUILD)/ex09
inspect: all
	readelf -S -s -r $(BUILD)/ex09_main.o $(BUILD)/ex09_data.o
	objdump -dr $(BUILD)/ex09_main.o
	size $(BUILD)/ex09_main.o $(BUILD)/ex09_data.o
clean:
	rm -rf -- build

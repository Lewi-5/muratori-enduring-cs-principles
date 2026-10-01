# Run from week-01 on Linux/WSL. Compiler/flags/source changes get distinct builds.
CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror
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
EXERCISES = 01 02 03 04 05 06 07 08 09 10 11 12 13 15
WARMUPS = $(addprefix $(BUILD)/w,01 02 03 04)
PROGRAMS = $(addprefix $(BUILD)/ex,$(EXERCISES)) $(BUILD)/ex14 $(WARMUPS)

.PHONY: all test warmups inventory verify starters bench symbols assembly clean
all: $(PROGRAMS)
$(BUILD):
	mkdir -p "$@"
$(BUILD)/ex%: $(SRC)/ex%.c support/decimal.h | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@
$(BUILD)/w%: $(SRC)/w%.c | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@
$(BUILD)/ex14_%.o: $(SRC)/ex14_%.c $(SRC)/ex14_count.h | $(BUILD)
	$(CC) $(FLAGS) -c $< -o $@
$(BUILD)/ex14: $(BUILD)/ex14_main.o $(BUILD)/ex14_count.o
	$(CC) $(FLAGS) $(LINK_FLAGS) $^ -o $@
# Warm-ups are ungraded; `make warmups` checks only them, and `make test` checks them first.
warmups: $(WARMUPS)
	$(PYTHON) tests/warmups.py --build $(BUILD) --source $(SRC) --cc $(CC) --flags '$(FLAGS) $(LINK_FLAGS)'
test: all inventory warmups
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
bench:
	$(MAKE) PACKAGE=$(PACKAGE) CC=$(CC) MODE=debug all
	$(MAKE) PACKAGE=$(PACKAGE) CC=$(CC) MODE=optimized all
	build/$(PACKAGE)/$(notdir $(CC))/debug/ex15
	build/$(PACKAGE)/$(notdir $(CC))/optimized/ex15
symbols: all
	nm $(BUILD)/ex14_main.o $(BUILD)/ex14_count.o $(BUILD)/ex14
assembly: | $(BUILD)
	$(CC) $(STRICT) -O0 -S $(SRC)/ex06.c -o $(BUILD)/ex06-O0.s
	$(CC) $(STRICT) -O2 -S $(SRC)/ex06.c -o $(BUILD)/ex06-O2.s
clean:
	rm -rf -- build

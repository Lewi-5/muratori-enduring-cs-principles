# Run from week-03 on Linux/WSL. Compiler/flags/source changes get distinct builds.
# Floating-point policy: -ffp-contract=off is set explicitly (Clang defaults to "on", which permits fused
# multiply-add). No fast-math, -Ofast, -march=native or reassociation flag is ever used.
CC = gcc
PACKAGE ?= learner
MODE ?= debug
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off
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
EXERCISES = 01 02 03 04 05 06
PROGRAMS = $(addprefix $(BUILD)/ex,$(EXERCISES)) $(BUILD)/geomath_demo

.PHONY: all test inventory verify starters symbols extras clean
all: $(PROGRAMS)
$(BUILD):
	mkdir -p "$@"
$(BUILD)/ex%: $(SRC)/ex%.c support/platform.h support/geo_consts.h | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@ -lm
$(BUILD)/geomath.o: $(SRC)/geomath.c $(SRC)/geomath.h support/geo_consts.h | $(BUILD)
	$(CC) $(FLAGS) -Isupport -I$(SRC) -c $< -o $@
$(BUILD)/geomath_demo.o: $(SRC)/geomath_demo.c $(SRC)/geomath.h support/geo_consts.h | $(BUILD)
	$(CC) $(FLAGS) -Isupport -I$(SRC) -c $< -o $@
$(BUILD)/geomath_demo: $(BUILD)/geomath_demo.o $(BUILD)/geomath.o
	$(CC) $(FLAGS) $(LINK_FLAGS) $^ -o $@ -lm
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
	nm $(BUILD)/geomath_demo.o $(BUILD)/geomath.o $(BUILD)/geomath_demo
	@echo "--- global defined symbols of geomath.o:"; nm --defined-only -g $(BUILD)/geomath.o
clean:
	rm -rf -- build

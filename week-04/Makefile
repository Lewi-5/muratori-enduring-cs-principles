# Run from week-04 on Linux/WSL. Compiler/flags/source changes get distinct builds.
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
EXERCISES = 01 02 03 04 05 06 07
PROGRAMS = $(addprefix $(BUILD)/ex,$(EXERCISES))
HEADERS = support/platform.h support/geolab_types.h support/reference_distance.h

.PHONY: all test inventory verify starters audit clean
all: $(PROGRAMS)
$(BUILD):
	mkdir -p "$@"
$(BUILD)/ex%: $(SRC)/ex%.c $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) $(LINK_FLAGS) -Isupport $< -o $@ -lm
test: all inventory
	$(PYTHON) tests/check.py --build $(BUILD) --source $(SRC) --cc $(CC) --flags '$(FLAGS) $(LINK_FLAGS)'
inventory:
	$(PYTHON) tests/inventory.py
audit:
	$(PYTHON) instructor/extras/repro_audit.py
verify:
	$(MAKE) PACKAGE=instructor CC=gcc MODE=debug test
	$(MAKE) PACKAGE=instructor CC=clang MODE=debug test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=clang MODE=optimized test
	$(MAKE) PACKAGE=instructor CC=gcc MODE=sanitize test
	$(MAKE) PACKAGE=instructor CC=clang MODE=sanitize test
	$(MAKE) audit
	$(MAKE) starters
starters:
	$(MAKE) PACKAGE=learner CC=gcc MODE=debug all
	$(MAKE) PACKAGE=learner CC=clang MODE=debug all
	$(PYTHON) tests/starters.py --cc gcc
	$(PYTHON) tests/starters.py --cc clang
clean:
	rm -rf -- build

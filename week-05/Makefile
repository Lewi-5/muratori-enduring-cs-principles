# Week 5 / geolab checkpoint 1. Run from week-05 on Linux/WSL.
# Floating-point policy: -ffp-contract=off is explicit (Clang defaults to "on"). No fast-math, -Ofast,
# -funsafe-math-optimizations, -march=native or reassociation flag is ever used; tests/check.py refuses them.
# Every configuration (package, compiler, mode, vectorization variant) builds into its own directory, so an
# interleaved benchmark never reuses or overwrites the wrong executable.
CC = gcc
PACKAGE ?= learner
MODE ?= debug
VEC ?=
PYTHON ?= python3
STRICT = -std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L
IS_CLANG := $(findstring clang,$(notdir $(CC)))
ifeq ($(MODE),debug)
FLAGS = $(STRICT) -O0
else ifeq ($(MODE),optimized)
FLAGS = $(STRICT) -O2
else ifeq ($(MODE),sanitize)
FLAGS = $(STRICT) -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie
LINK_FLAGS = -no-pie
else ifeq ($(MODE),bench)
ifeq ($(VEC),off)
VECFLAGS = $(if $(IS_CLANG),-fno-vectorize -fno-slp-vectorize,-fno-tree-vectorize)
else ifneq ($(VEC),default)
$(error MODE=bench needs VEC=off or VEC=default)
endif
FLAGS = $(STRICT) -O2 $(VECFLAGS)
else
$(error MODE must be debug, optimized, sanitize or bench)
endif
ifeq ($(filter $(PACKAGE),learner instructor),)
$(error PACKAGE must be learner or instructor)
endif
SRC = $(PACKAGE)/geolab/src
INC = $(PACKAGE)/geolab/include
BUILD = build/$(PACKAGE)/$(notdir $(CC))/$(MODE)$(if $(VEC),-vec-$(VEC))
OBJ = $(BUILD)/obj
UNITS = csv geo query cli bench main
OBJECTS = $(addprefix $(OBJ)/,$(addsuffix .o,$(UNITS))) $(OBJ)/envinfo.o
HEADERS = $(wildcard $(INC)/*.h) $(wildcard support/*.h)
CPPFLAGS = -I$(INC) -Isupport -I$(BUILD)
VARIANT = $(notdir $(CC))-$(MODE)$(if $(VEC),-vec-$(VEC))

.PHONY: all test inventory symbols bench-bins bench-data expected checkpoint verify starters mutate clean FORCE
all: $(BUILD)/geolab

$(OBJ):
	mkdir -p "$@"
# buildinfo.h records the exact flags; it is rewritten only when they change, so rebuilds stay incremental.
$(BUILD)/buildinfo.h: FORCE | $(OBJ)
	@printf '#define GEOLAB_BUILD_FLAGS "%s"\n#define GEOLAB_BUILD_VARIANT "%s"\n' '$(CC) $(FLAGS) $(LINK_FLAGS)' '$(VARIANT)' > $@.tmp
	@cmp -s $@.tmp $@ || mv $@.tmp $@; rm -f $@.tmp
$(OBJ)/%.o: $(SRC)/%.c $(HEADERS) | $(OBJ)
	$(CC) $(FLAGS) $(CPPFLAGS) -c $< -o $@
$(OBJ)/envinfo.o: support/envinfo.c $(HEADERS) $(BUILD)/buildinfo.h | $(OBJ)
	$(CC) $(FLAGS) $(CPPFLAGS) -c $< -o $@
$(BUILD)/geolab: $(OBJECTS)
	$(CC) $(FLAGS) $(LINK_FLAGS) $(OBJECTS) -o $@ -lm
	@printf '%s\n' '$(CC) $(FLAGS) $(LINK_FLAGS) $(CPPFLAGS) [each .c] ; link -lm' > $(BUILD)/compile-command.txt

test: all inventory
	$(PYTHON) tests/check.py --build $(BUILD) --package $(PACKAGE) --cc $(CC) --flags '$(FLAGS) $(LINK_FLAGS)' --include $(INC)
inventory:
	$(PYTHON) tests/inventory.py
# External (global, defined) symbols of every object: a toolchain observation (binutils nm).
symbols: all
	@for o in $(OBJECTS); do echo "== $$o"; nm -g --defined-only "$$o" | awk '{print $$NF}'; done
# The two benchmark executables for this compiler and package, at distinct paths.
bench-bins:
	$(MAKE) PACKAGE=$(PACKAGE) CC=$(CC) MODE=bench VEC=off all
	$(MAKE) PACKAGE=$(PACKAGE) CC=$(CC) MODE=bench VEC=default all
# The E05 protocol: raw outputs go to results/ (see PROTOCOL.md). Takes a few minutes; nothing is asserted about time.
bench-data: bench-bins
	$(PYTHON) tools/bench_data.py --package $(PACKAGE) --cc $(notdir $(CC)) --out results
# Regenerate fixtures/expected/ from the supplied oracle (never from the program under test).
expected:
	$(PYTHON) tools/expected.py --package $(PACKAGE) --write
# E07: the checkpoint gates.
checkpoint:
	rm -rf -- build/$(PACKAGE)
	$(MAKE) PACKAGE=$(PACKAGE) CC=gcc MODE=debug test
	$(MAKE) PACKAGE=$(PACKAGE) CC=clang MODE=debug test
	$(MAKE) PACKAGE=$(PACKAGE) CC=gcc MODE=optimized test
	$(MAKE) PACKAGE=$(PACKAGE) CC=clang MODE=optimized test
	$(MAKE) PACKAGE=$(PACKAGE) CC=gcc MODE=sanitize test
	$(PYTHON) tools/identity.py --package $(PACKAGE)
	$(PYTHON) tools/manifest.py --package $(PACKAGE)
verify:
	$(MAKE) PACKAGE=instructor checkpoint
	$(MAKE) PACKAGE=instructor CC=clang MODE=sanitize test
	$(MAKE) PACKAGE=instructor CC=gcc bench-bins
	$(MAKE) PACKAGE=instructor CC=clang bench-bins
	$(PYTHON) tools/bench_data.py --package instructor --cc gcc --out build/bench-smoke --quick
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

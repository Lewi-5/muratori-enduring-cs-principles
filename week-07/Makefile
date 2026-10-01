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
MODULES = address decode format stream
OBJECTS = $(addprefix $(BUILD)/,$(addsuffix .o,$(MODULES)))
HEADERS = include/decode.h support/address.h
.PHONY: all test inventory verify starters symbols warmups clean
all: $(BUILD)/decode8086 $(BUILD)/client $(BUILD)/playground $(BUILD)/warmups
warmups: $(BUILD)/warmups
	$(BUILD)/warmups
$(BUILD):
	mkdir -p "$@"
$(BUILD)/%.o: $(SRC)/%.c $(HEADERS) | $(BUILD)
	$(CC) $(FLAGS) -fPIC -Iinclude -Isupport -c $< -o $@
$(BUILD)/libdecode.so: $(OBJECTS) support/exports.map
	$(CC) $(FLAGS) -shared -Wl,--version-script=support/exports.map $(OBJECTS) -o $@
$(BUILD)/decode8086: $(SRC)/decode8086.c $(OBJECTS) $(HEADERS)
	$(CC) $(FLAGS) $(EXE_FLAGS) -Iinclude $< $(OBJECTS) -o $@
$(BUILD)/client: $(SRC)/client.c $(BUILD)/libdecode.so $(HEADERS)
	$(CC) $(FLAGS) $(EXE_FLAGS) -Iinclude $< -L$(BUILD) -ldecode -Wl,-rpath,'$$ORIGIN' -o $@
$(BUILD)/playground: $(SRC)/playground.c $(OBJECTS) $(HEADERS)
	$(CC) $(FLAGS) $(EXE_FLAGS) -Iinclude -Isupport $< $(OBJECTS) -o $@
$(BUILD)/warmups: $(addprefix $(SRC)/,w01.c w02.c w03.c) tests/warmups.c | $(BUILD)
	$(CC) $(FLAGS) $(EXE_FLAGS) -Iinclude $^ -o $@
$(BUILD)/contracts: tests/contracts.c $(OBJECTS) $(HEADERS)
	$(CC) $(FLAGS) $(EXE_FLAGS) -Iinclude -Isupport $< $(OBJECTS) -o $@
test: all $(BUILD)/contracts inventory
	$(BUILD)/contracts
	$(BUILD)/warmups
	$(PYTHON) tests/check.py --build $(BUILD) --cases $(PACKAGE)/cases.txt
inventory:
	$(PYTHON) tests/inventory.py
symbols: all
	nm -D --defined-only $(BUILD)/libdecode.so
	readelf -d $(BUILD)/client
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
clean:
	rm -rf -- build

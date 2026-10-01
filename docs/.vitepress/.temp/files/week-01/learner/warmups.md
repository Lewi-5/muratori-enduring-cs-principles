# Warm-ups — easing into the C field notebook

Four small, ungraded programs. Each one practises a habit that several exercises in the notebook depend on, so do them before the lesson or alongside it. Every warm-up has a typed scaffold in `src/wNN.c` with a supplied `main`; you fill in the `TODO` bodies. From `week-01`, `make warmups` builds and checks only the warm-ups and reports which ones still need work. `make test` checks them first, then the graded exercises.

Each warm-up ends with a short question. Answer it in a sentence or two in your notebook; the worked answers are on the solutions page.

### W01

**Add without overflowing (prepares E03, E04, E11 and E13).** Implement `int checked_add(unsigned long long a, unsigned long long b, unsigned long long limit, unsigned long long *out)`. When `a + b` is at most `limit`, store the sum in `*out` and return 1. Otherwise return 0 and leave `*out` unchanged; also return 0 when `out` is NULL. The catch: your test must never compute anything that could exceed `limit` or wrap past `ULLONG_MAX`. Decide *before* adding. Predict the four driver lines, including the last one, where `a` is `ULLONG_MAX`.

**Question:** `a + b > limit` looks like the obvious test. Give inputs for which it accepts a sum it should reject, and explain why the fault is silent rather than a crash.

### W02

**Search backwards with an unsigned index (prepares E05, E06 and E14).** Implement `int last_index_of(const int *values, size_t length, int target, size_t *out)`. Store the index of the *last* element equal to `target` and return 1; return 0 and leave `*out` unchanged when there is none or when `out` is NULL. `values` may be NULL only when `length` is 0. Use a `size_t` index and search from the end. Make sure index 0 can be found, and make sure an empty array never reads anything.

**Question:** a common first attempt is `for (size_t i = length - 1; i >= 0; --i)`. Explain what goes wrong for `length == 0` and for a target that is absent, and describe a loop shape that avoids both.

### W03

**Bytes and bits of a value (prepares E09 and E10).** Implement `unsigned byte_at(uint32_t value, unsigned index)`, which returns byte number `index` of the *value* (0 is the least significant byte; `index` is 0 to 3), using shifts and a mask. Also implement `unsigned bit_count(uint32_t value)`, which returns how many bits are 1. Predict the driver's output for `0x01020304` before running it.

**Question:** E09 inspects the same number `0x01020304` through its bytes in memory and may print them in a different order from `byte_at`. Why can the two disagree, and which of them depends on the machine?

### W04

**Own a copy of a string (prepares E11 and E12).** Implement `char *copy_text(const char *text)`, which returns a newly allocated copy of `text` that the caller must `free` exactly once. Return NULL for a NULL `text` or when `malloc` fails. The test replaces `malloc` with a version that can fail on request, and checks how many bytes you ask for.

**Question:** why does the copy need `strlen(text) + 1` bytes, and why may the driver change `copy[0]` but not the string literal it was copied from?

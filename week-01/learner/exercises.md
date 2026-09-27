# Assignment: the C field notebook

Implement each `src/exNN.c`. E14 uses the three supplied files instead. Use the exact examples and interfaces below so the public tests can check your work. `main` returns 0 on success; command-line errors return nonzero and print a useful diagnostic to stderr. Error text need not be identical to the reference. Output examples below are exact except values explicitly marked as measured.

Function contracts: output pointers must be non-null. For arrays, the caller supplies at least `length` initialized elements; NULL is permitted only at length zero. Inputs outside a stated precondition need not be accepted. Do not add a `main` to `ex14_count.c`. The public C unit harness includes the exercise source while renaming its `main`, so preserve the named functions and types. Small helper functions are welcome; no later-week abstraction framework is needed.

Each `.C` prompt includes implementation and at least a success and boundary test where relevant. Each `.Q` prompt requires a written explanation in your report. Write a prediction before running and then distinguish source semantics, mechanism, and observed behavior. Do not execute signed overflow or invalid memory accesses to find their “answer.”

### E01.C

Print `signed=-7 unsigned=7 long=-42 ull=42` using `int`, `unsigned int`, `long`, and `unsigned long long` arguments and matching formats. On line two print `int_min=VALUE int_max=VALUE uint_max=VALUE` using `<limits.h>`. Test both representative and boundary values without overflowing.

### E01.Q

Explain integer range versus representation, using one concrete C value and this implementation's limits. What does C11 guarantee, and why would an observed signed wraparound fail to establish a C rule?

### E02.C

Define `int values[5]`. Print `char=SIZE short=SIZE int=SIZE long=SIZE pointer=SIZE` with the pointer size for `int *`. Print `array=SIZE element=SIZE length=5 parameter=SIZE`, where parameter size comes from a helper taking `int *`. Use `%zu`. Test relationships rather than fixed byte counts. As a playground change to three elements, predict the two lines, run, then restore five for submission.

### E02.Q

Explain `sizeof values / sizeof values[0]`. What changes when a parameter is spelled `int values[5]`? Why is the same quotient not an array-length calculation inside that function? Explain the playground observation.

### E03.C

Implement `int sum_to(size_t n, unsigned long long *out)` for 0..10000, returning 1 on success and 0 without changing `*out` on rejection. Sum by a loop. CLI: `ex03 N` prints `sum=RESULT`. The supplied `decimal.h` provides `decimal_size(text, limit, &n)` for CLI validation; it accepts digits only. Test 0, 1, 10, 10000, 10001, malformed input, and missing arguments.

### E03.Q

State the loop invariant, demonstrate initialization, preservation and termination for N=3, then explain N=0 and why the chosen type and bound avoid overflow.

### E04.C

Implement `int clamp_int(int value, int low, int high, int *out)`. Return 0, leaving output unchanged, if `low > high`; otherwise return 1 with the clamped value. Main clamps 12 to [-3,8] and prints `clamped=8`. Test below, on, inside and above bounds, equal bounds, reversed bounds, and `INT_MIN`/`INT_MAX`.

### E04.Q

Explain inclusive boundaries and the error contract with examples. Why is inventing a numeric sentinel or silently swapping reversed endpoints inferior for this API?

### E05.C

Define `typedef struct { size_t count; int min; int max; } Stats;` and implement `int array_stats(const int *values, size_t length, Stats *out)`. Empty input returns 0 and sets all fields to zero (min/max then have no meaning). Nonempty input returns 1. Main uses `{4,-2,7,7}` and prints `count=4 min=-2 max=7`. Test empty, singleton, repeated values and integer extremes.

### E05.Q

Walk through the running extrema. Explain why initializing min to zero fails for some arrays and why the empty result needs a status separate from min/max.

### E06.C

Implement `long sum_index(const int *values, size_t length)` and `long sum_pointer(const int *values, size_t length)`. Precondition: at most 10000 elements, each in [-1000,1000]. Use indexing for one and an advancing pointer for the other. Main uses `{4,-2,7,7}` and prints `index=16 pointer=16`. Test empty, singleton, mixed signs and the maximum positive sum. Playground: replace 4 with 5, predict and run, then restore the fixture.

### E06.Q

Explain `p + 1`, one-past pointers, the empty NULL case, and why matching results do not imply identical generated instructions. Relate the playground change to the sum rather than to a presumed instruction count.

### E07.C

Define `typedef struct { uint64_t id; double lat_deg; double lon_deg; } GeoPoint;`. Implement `int valid_point(GeoPoint point)`. Require finite lat/lon within [-90,90]/[-180,180], inclusive. Main prints `id=42 lat=45.5 lon=-73.5` after validation. Test exact limits, just-outside limits, NaN and infinity in either coordinate. Use `PRIu64` for the identifier.

### E07.Q

Explain field meanings, units, finiteness and range checks with one valid and two invalid examples. Why is “reject only if less than the minimum or greater than the maximum” inadequate for NaN?

### E08.C

Define A as `{ char tag; double value; int count; }` and B as `{ double value; int count; char tag; }`. Print three lines using `sizeof` and `offsetof`:

```text
members char=SIZE double=SIZE int=SIZE
A size=SIZE tag=OFFSET value=OFFSET count=OFFSET
B size=SIZE value=OFFSET count=OFFSET tag=OFFSET
```

Tests check member order, non-overlap, and that the last member fits. Do not require B to be smaller.

### E08.Q

Draw A's observed byte layout with member spans and internal/tail padding. Explain alignment, what changed in B, and which observations are implementation-dependent rather than C guarantees.

### E09.C

Inspect `uint32_t value = UINT32_C(0x01020304)` through unsigned characters (or `memcpy`). Print `char_bits=BITS bytes=SIZE`, a line of space-separated lowercase hexadecimal bytes with at least two digits each, then `order=little`, `order=big`, or `order=other` based on observed bytes. Recognize big/little only for the familiar four 8-bit-byte arrangements. Test byte count and the reported classification without presupposing one order.

### E09.Q

Explain why this access is legal, interpret your output, and give the portability limit of exact-width integers and endian conclusions. Contrast with reading through an unrelated non-character pointer type.

### E10.C

Define `FLAG_READ` as `1u << 0` and `FLAG_WRITE` as `1u << 1`. Implement `unsigned set_flag(unsigned flags, unsigned mask)`, `int has_flag(unsigned flags, unsigned mask)` (all requested bits), `unsigned toggle_flag(unsigned flags, unsigned mask)`, and `unsigned clear_flag(unsigned flags, unsigned mask)`. Main starts at zero, sets/read-tests READ, toggles WRITE, then clears READ, printing `set=1 test=1 toggle=3 clear=2`. Test set twice, toggle twice, clear absent bits, and combined masks.

### E10.Q

Explain each operation bit by bit, the unsigned choice, and what is wrong with shifting by a negative count or by the width of the promoted left operand. Do not run those invalid shifts.

### E11.C

Implement `int allocated_sum(size_t n, unsigned long long *out)`. Reject `n > SIZE_MAX / sizeof(int)` or `n > 1000000` before multiplying; return 0 without changing output. N=0 returns success/sum zero without allocation. Otherwise allocate, check failure, initialize `values[i] = i % 100`, sum, and free once. CLI `ex11 N` prints `count=N sum=RESULT`. Use the supplied decimal helper if useful. Test 0, 1, 5, 101, the cap and excessive requests.

### E11.Q

Explain overflow checks, the cap, zero policy, allocation failure and ownership. Give a faulty allocate-before-checking approach and repair it. Trace the N=5 values and total.

### E12.C

Implement `int count_file(const char *path, size_t *bytes, size_t *newlines)`. On success set outputs and return 1; on open/read/close or count-overflow failure leave outputs unchanged and return 0. Use stdio in binary mode, count every byte and each `\n`, and always close an opened stream. CLI `ex12 FILE` prints `bytes=N newlines=N`. Test the supplied fixtures, a missing path, a directory read error on Linux, and a file containing byte 0xff. Tests inject a close failure in the reference validation; you need not damage a real filesystem to provoke one.

### E12.Q

Explain bytes versus newline count, empty versus missing, the type of `fgetc`'s result, normal EOF versus `ferror`, and why `fclose` must be called and checked even following a read error.

### E13.C

Implement `int parse_decimal(const char *text, unsigned long long limit, unsigned long long *out)` using `strtoull`. Accept only one or more decimal digits: no sign or whitespace. Reject empty text, junk, conversion overflow and values above limit. Return 1 on success; otherwise 0 leaving output unchanged. CLI `ex13 TEXT` uses limit 1000000 and prints `value=RESULT`. Test zero, leading zeroes, cap, each rejected class, missing arguments and a very long digit string.

### E13.Q

Explain the grammar check, `errno`, end pointer, limit check and caller status. Why are checking only the returned number or assuming `strtoull` rejects minus signs both faulty?

### E14.C

Implement the supplied `count_equal` declaration in `ex14_count.c`; main counts 2 in `{2,4,2,2,7}` and prints `matches=3`. Test empty, absent, singleton and repeated targets. Build the two object files separately, link, and run `make symbols` (or `readelf -s`). Record the `count_equal` entries.

### E14.Q

Explain declaration, definition, translation unit, object file, unresolved/resolved symbol, and linker resolution. Show the compile/link commands and explain why placing an ordinary externally linked function definition in a shared header can fail.

### E15.C

Time five trials of 1000 summations of 1024 initialized unsigned elements (`i % 100`). Use POSIX `clock_gettime(CLOCK_MONOTONIC)` and check errors. Initialize and warm up before timing; validate the sum 49776 and each trial checksum 49776000. To keep this introductory experiment inspectable, use volatile-qualified array reads to require each pass; state that limitation. Emit:

```text
size=1024 iterations=1000 trials=5 expected=49776
trial=1 seconds=MEASURED checksum=49776000
... one line for each of the five trials ...
median=MEASURED min=MEASURED max=MEASURED range=MEASURED
```

Print seconds to nine decimals. Calculate median, min, max and range. Compare strict `-O0` and `-O2` builds with `make bench`. Tests verify checksums, finite nonnegative durations and summary calculations, never a duration or speedup threshold.

### E15.Q

Explain timer units and subtraction, warm-up, result validation, median and variation with a worked calculation. Compare your two builds, identify timer/loop overhead and the volatile limitation, and explain why another machine or run might yield another ranking.

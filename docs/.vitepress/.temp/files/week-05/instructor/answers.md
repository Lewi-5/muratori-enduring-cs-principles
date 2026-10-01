# Answer key — Project 1 (`geolab` checkpoint 1)

Every learner prompt has an entry with the same ID. Measured numbers come from the reference machine and are labelled as such. The machine is a 12th Gen Intel Core i7-12650H (16 logical CPUs) under WSL 2, kernel 6.18.33.2-microsoft-standard-WSL2, running Ubuntu 22.04 with GCC 11.4.0, Clang 14.0.0, glibc 2.35 and Python 3.10.12, measured on 2026-09-22. The execution evidence is in [validation.md](validation.md). Other machines give other numbers; grade the method, not the digits.

Clauses used, from N1570:

- §6.3.1.4 ¶1–2: real floating to integer conversion is undefined when out of range; integer to floating conversion is exact when representable.
- §7.11.1.1 ¶4: a program starts in the `"C"` locale.
- §7.22.1 ¶1: `atof` and the `ato*` functions have undefined behavior when the result cannot be represented.
- §7.22.5 ¶4 and 7.22.5.2: `qsort`'s comparison function must be consistent and form a total ordering, and stability is not promised.
- §7.27.2.1: `clock` returns processor time.
- Annex F.3: `+ − × ÷` are the IEC 60559 operations.
- Annex F.5 ¶2: binary-decimal conversions with at most `DECIMAL_DIG` significant digits are correctly rounded.
- §4 ¶2: violating a “shall” outside a constraint is undefined behavior.

POSIX and Linux sources: [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html) and `stat`/`S_ISREG`.

### E01.C

Reference: [csv.c](geolab/src/csv.c), [geo.c](geolab/src/geo.c), and `parse_cli_decimal` and `cmd_generate` in [cli.c](geolab/src/cli.c).

**Assembly.** `csv.c` is week 4's reference with every helper made `static`. `make symbols` now lists exactly `generate_csv`, `load_points`, `parse_record` and `write_csv_file`, while `nm` without `-g` still shows `lcg_next`, `format_udeg` and the other helpers as local `t` symbols (recorded in validation.md). The generator's code is otherwise unchanged, and that is the point: checkpoint 1 promises byte-identical output, and the tests compare SHA-256 digests with week 4's oracle.

One behavioral change, recorded in PLAN.md's corrections: after a failure that follows a successful `fopen`, the partial file is removed only when `stat` reports a regular file.

```c
if (!ok) {
    struct stat st;
    if (stat(path, &st) == 0 && S_ISREG(st.st_mode)) remove(path);
    return 0;
}
```

The reason: `--out /dev/full` opens successfully and then fails every write. Week 4's unconditional `remove` would delete the device node if run with enough privilege.

**The number parser.**

```c
if (text == NULL || out == NULL || limit_micro < 0 || limit_micro > INT64_C(1000000000000000)) return 0;
... optional '-' (only if allow_sign) ...
if (*s < '0' || *s > '9') return 0;                      /* "", "-", ".5", "+1" */
if (s[0] == '0' && s[1] >= '0' && s[1] <= '9') return 0; /* "01" */
const int64_t whole_limit = limit_micro / 1000000;
for (; *s >= '0' && *s <= '9'; ++s) {
    int64_t d = *s - '0';
    if (too_large || whole > (whole_limit - d) / 10) too_large = 1; /* keep scanning */
    else whole = whole * 10 + d;
}
... '.' then 1..6 digits, scaled to millionths; anything left over is a grammar error ...
if (too_large) return 0;
int64_t micro = whole * 1000000 + frac;
if (micro > limit_micro) return 0;
double value = (double)micro / 1000000.0;
*out = (negative && micro != 0) ? -value : value;
```

It keeps scanning after the value is known to be too large, so every string is checked against the whole grammar and a too-large *and* malformed string is simply rejected. Nothing is written until the end.

**Why it is correct.** The grammar is checked character by character, and the value check is exact integer arithmetic. Edge cases, all in the tests:

- `90` and `90.000000` are accepted; `90.000001` is rejected.
- `-0`, `-0.0` and `-0.000` give `+0.0`, and `signbit` is checked.
- A 20-digit integer part is rejected without overflow.
- `limit_micro` values of −1, 10^15 + 1 and `INT64_MAX` are rejected.
- `1000000000` against the limit 10^15 is accepted. It is the largest value, and the guard's worst case.

**`cmd_generate`** uses the supplied scanner: all three options are required, `--count` is parsed with the maximum `GEOLAB_MAX_ROWS`, and `--out` must not be empty. It prints nothing on success, and exits 1 with `geolab: could not write FILE` after a failed write.

**Faulty approach.** `*out = atof(text)` has four problems:

- It accepts `1e2`, ` 1`, `0x1p3`, `inf` and `nan`.
- It returns 0 for `abc` with no error.
- It uses the locale's decimal point.
- Its behavior is **undefined** when the result is not representable (§7.22.1 ¶1).

A `strtod` with an end-pointer check fixes the silent zero but still accepts exponents, hexadecimal, `inf`, `nan` and leading whitespace, and still depends on the locale.

### E01.Q

**Header and implementation.** `geolab.h`, `cli.h` and `bench.h` are the contract: types, limits, and one comment per function stating what it validates, what it writes, and when it writes nothing. The `.c` files are separate translation units; each is compiled to its own object and the linker resolves the external names. A function without `static` has external linkage and is visible to every other object. With `static` it has internal linkage (C11 §6.2.2): the linker never sees it, and two translation units can each have a helper called `clamp` without a clash. The check in `make test` compares every object's `nm -g --defined-only` output with the names declared in the headers. Leaving `lcg_next` non-static makes that check fail: an undeclared external symbol is an interface nobody documented.

**Integers, not `strtod`.** Four reasons:

1. The grammar is small and fixed, so a hand parser can enforce it exactly, whereas `strtod` accepts a much larger language (exponents, hexadecimal, `inf`, `nan`, whitespace) that would have to be rejected afterwards.
2. `strtod` depends on the locale's decimal point.
3. Its conversion is correctly rounded only under Annex F, which is the same condition the integer route needs anyway.
4. The integer route makes the range check exact: `|micro| <= limit_micro` compares integers, while comparing a converted `double` with `90.0` would accept `90.0000000000000001` if the conversion rounded down to 90.

**The overflow guard, proved.** Let `W = floor(L / 10^6)`, where L = `limit_micro` is in [0, 10^15], so W ≤ 10^9. Claim: after every accepted digit, `whole ≤ max(W, 9) ≤ 10^9`.

- The check passes only when `whole ≤ (W − d) / 10`, where C's division truncates toward zero (§6.5.5 ¶6).
- **Case W − d ≥ 0.** Truncation is the floor, so `10 · whole ≤ W − d`, and the new value `10 · whole + d ≤ W`.
- **Case W − d < 0.** Then W < d ≤ 9, so W − d is in [−9, −1] and the quotient truncates to 0. The check passes only for `whole = 0`, and the new value is `d ≤ 9`.
- **Consequences.** Every product `10 · whole` is at most 10^10. `micro = whole · 10^6 + frac` is at most 10^15 + 999,999 < 2^63. No `int64_t` operation can overflow for any input string.

The extremes were attacked, with each case in the tests:

- L = 0 with `9`: `whole` becomes 9, `micro` = 9 · 10^6 > 0, rejected.
- L = 10^15 with `1000000000`: accepted exactly at the limit.
- L = 10^15 with `1000000001`: at the last digit, 10^8 > (10^9 − 1)/10, so flagged too large.
- L = 10^15 with `12345678901234567890`: flagged at the tenth digit and never multiplied again.

**Correct rounding, not exactness.** `|micro| ≤ 10^15 < 2^53`, so `(double)micro` is exact (§6.3.1.4 ¶2), and `1e6` is exact. Under Annex F, division is the IEC 60559 operation, correctly rounded to nearest (F.3). The exact quotient `micro / 10^6` *is* the decimal the user typed, as a rational number, so the result is the double nearest that decimal. That is the same double a correctly rounded `strtod` would give (F.5 ¶2); the tests compare it bit for bit with the oracle's `float(Fraction(text))` under the gate. It is not exact: `0.1` becomes 0.1000000000000000055511151231257827…, the nearest double. The contract promises the nearest double, not the decimal.

**`-0.0` on the command line, `-0.000000` in CSV.** CSV v1 is a *data* format: one spelling per value, so equal data have equal bytes and digests, and a strict grammar catches corruption. The command line is *human input*. `-0.0` means the same point as `0`, so normalizing it loses nothing and rejecting it would only annoy. Leniency stops there. `1e2`, `.5`, `5.`, `+1` and seven decimals are rejected, because each is either ambiguous or outside the precision the contract promises: a seventh decimal would be silently rounded away. The rule is to accept an alternative spelling only when it cannot change the meaning.

### E02.C

Reference: [query.c](geolab/src/query.c) and `cmd_query` in [cli.c](geolab/src/cli.c).

```c
int query_hit_compare(const void *a, const void *b)
{
    const QueryHit *x = a, *y = b;
    if (x->distance_km < y->distance_km) return -1;
    if (x->distance_km > y->distance_km) return 1;
    if (x->id < y->id) return -1;
    if (x->id > y->id) return 1;
    return 0;
}
```

`query_points` works in five steps:

1. Validate everything: the output pointers, `points` against `count`, the center, a finite radius in [0, 100000], and every point.
2. Allocate a temporary `double` array of `count` distances, checking `count ≤ SIZE_MAX / sizeof(double)`, and compute each distance once. Every distance, and the selection count, comes from that one computation.
3. Allocate exactly `selected` hits (checked multiplication) and copy the selected ones. There is no allocation when nothing is selected, so `*hits` is NULL.
4. `qsort`.
5. Free the temporary and commit.

Every failure path frees what was allocated and returns before touching `*hits` and `*nhits`. The contract suite injects a `malloc` failure at each call and checks the sentinel values; the sanitizer build checks for leaks.

An empty input still validates the center and radius. The mutation check found that the first version did not test this, and the suite now does.

`cmd_query` works in three stages:

1. **Validate.** Parse all values; call `cli_check_future_options` (3 for `--threads 4`, 2 for `--threads 0`).
2. **Compute.** `load_points` (a failure prints `geolab: STATUS at line N in FILE`, exit 1), then `query_points`, then free the points.
3. **Print.** Only then write the header and the lines with `"%" PRIu64 ",%.6f\n"`, check every write and `fflush(stdout)`, and report `geolab: output error` with exit 1.

**Faulty approach.** Allocating the hit array with `count` elements and growing a count is also correct, but it wastes memory. Recomputing the distance in the copy loop is a subtle bug. If a future `geo_distance_km` were non-deterministic, or a compiler contracted the two evaluations differently, the selection count and the copied distances could disagree. Computing once removes the question.

### E02.Q

**Deterministic although not stable.** `qsort` promises nothing about the relative order of elements that compare equal (§7.22.5.2), but the comparator returns 0 only when **both** the distance and the identifier are equal. Two such hits print identical lines: `"%" PRIu64 ",%.6f"` of equal values gives equal text. Whatever permutation `qsort` chooses among them, the output bytes are the same. The comparator is also a total order on the values that occur. It is antisymmetric, transitive and consistent, and no NaN can reach it because every distance comes from validated input and the clamped haversine. That satisfies §7.22.5 ¶4.

**`return (int)(a->d - b->d);` is wrong twice.**

1. The conversion truncates toward zero, so distances 0.3 and 0.9 “compare equal”. Then 0.3 = 0.9 and 0.9 = 1.5 but 0.3 < 1.5: the comparator no longer forms a total ordering. That violates a “shall” in §7.22.5 ¶4, so the behavior is undefined, and in practice the order is wrong.
2. A difference outside `int`'s range makes the conversion itself undefined (§6.3.1.4 ¶1). The same pattern on identifiers, `(int)(a->id - b->id)`, wraps modulo 2^64 and then converts an out-of-range value: implementation-defined, and wrong for identifiers that differ by 2^32.

**Unrounded order, and the printed tie.** Identifier 2 at (0.600366, 0.79974) is 111.19507985186856 km from (0, 0); identifier 1 at (0, 1) is 111.1950802335329 km (measured). Both print `111.195080`, but identifier 2 is 3.8e−7 km nearer, so the output is:

```
id,distance_km
3,55.597540
2,111.195080
1,111.195080
```

A sort by the printed text and then the identifier would put 1 before 2. The mutation record shows that mutant fails. The printed six decimals are a rounding of the order key for human readers, with 1 mm resolution; they are not the key. A reader cannot recover the exact order or the exact distance from them, and a consumer that re-sorts the printed lines may legitimately produce a different order among printed ties.

**Why the exact tie uses identical coordinates.** Two records with the same coordinates make the program perform *the same operations on the same inputs*, so the distances are the same double as long as the function is deterministic within one process. That is a very weak assumption. A symmetric pair, (0, +x) and (0, −x) about (0, 0), gives equal distances only if the library's `sin` satisfies `sin(−y) == −sin(y)` exactly, so that the squares match. C does not require that (Annex F does not even require `sin` to be correctly rounded). Glibc happens to be odd-symmetric (observed, not asserted), but another `libm` that reduces arguments asymmetrically would break the tie and make the “exact tie” fixture flaky.

**The boundary through the C API.** The inclusive test needs a radius equal to a computed distance and the next double below it. `nextafter(d, 0)` differs from `d` in the 17th significant digit, while the command line accepts at most six decimals. So the boundary is tested where doubles can be passed exactly, in the contract suite, and the command line is tested with values whose side of the boundary is unambiguous.

### E03.C

The exemplar is [instructor/fixtures](fixtures/README.md): seven fixtures with purposes `pole`, `antimeridian`, `exact-tie`, `printed-tie`, `empty`, `malformed` and `boundary`, each with its arguments and a sentence on what it catches. The expected outputs in [fixtures/expected](fixtures/expected) were written by `make PACKAGE=instructor expected`. What a good learner set shows:

- **Pole.** Several spellings of the pole (longitudes 0, 90 and −180) are all selected.
- **Antimeridian.** 180 and −180 are the same place.
- **Exact tie.** Duplicate coordinates are listed in a non-sorted input order, so the tie-break is really exercised.
- **Printed tie.** The pair is found by search, not guessed. Accept any pair the learner can show prints identically and is further apart than the tolerance.
- **Empty.** A radius that selects nothing.
- **Malformed.** A file whose failing line number is known.

Also accept learner fixtures that use other boundary cases, if the purpose sentence says what the fixture catches.

### E03.Q

**Independence.** The oracle ([tests/oracle.py](../tests/oracle.py)) is Python, not C, and shares no source with the program.

- It computes distances with the unit-vector central angle `atan2(|u × v|, u · v)`, not the haversine.
- It parses CSV with regular expressions and converts with `fractions.Fraction`.
- It parses command-line numbers with exact rationals.
- Its loader re-derives week 4's status order from the bytes.

It **does** share four things:

- the specification text, including any misreading of it;
- the sphere radius 6371.0088 and the value of π;
- the IEC 60559 double format;
- glibc's `sin`, `cos` and `atan2`, because Python's `math` module calls the platform `libm`.

The last one matters: a `libm` bug in `sin` would reach both implementations, softened only by the different formulas.

**The tolerance rule.** The two formulations disagree by at most 9.1e−12 km below 15,000 km, 8.8e−10 km below 19,900 km and 4.1e−8 km beyond, near antipodes (measured on 909,000 pairs; see validation.md). The rule, in `tests/fixture_lib.py`:

- The tolerance is 1e−10, 1e−8 or 5e−7 km by band, at least eleven times each maximum.
- Membership is compared exactly except for points within the tolerance of the radius.
- Each printed distance must be within print rounding (5e−7) plus the tolerance of the oracle's value.
- The order of two adjacent lines counts as wrong only if the oracle says the second is nearer by more than twice the tolerance. Records with identical coordinates must additionally be in identifier order.

A single global tolerance of 5e−7 km (the antipodal worst case) would make every pair closer than 1e−6 km “unordered”. The printed-tie pair is 3.8e−7 km apart, so its order would never be checked, and the fixture whose whole purpose is that order would test nothing. Banding by distance keeps the check honest where the formulas agree to 1e−11 km.

**A trace: `printed_tie.csv` with `--lat 0 --lon 0 --radius-km 112`.**

1. The oracle loads three rows. `0.600366` becomes `Fraction(600366, 1000000)`, whose correctly rounded double is `0x1.33632c1f42bb6p-1`.
2. The center's unit vector is (1, 0, 0).
3. Identifier 1's vector is (0.9998476951563913, 0.01745240643728351, 0); the cross product's norm and the dot product give atan2 = 0.01745329251994329…, and × 6371.0088 = 111.1950802335329 km.
4. Identifier 2 gives 111.19507985186856 km.
5. Identifier 3 gives 55.59754011676645 km.
6. All three are ≤ 112, and sorting (distance, id) gives 3, 2, 1.

That is the expected file. The program's haversine values agree with these to the last printed digit (measured).

**What differential testing cannot catch.**

1. A shared misreading of the specification. If both implementations treated the radius as exclusive, they would agree and both be wrong.
2. A wrong shared constant, such as the radius or the model of the Earth.
3. A bug in the shared `libm`.
4. Anything the oracle does not model: memory leaks, output-error handling, timing, performance, behavior on inputs the fixtures never contain.
5. A property that is only checked within the tolerance. An order error between two points 1e−11 km apart at 16,000 km is invisible by design.

### E04.C

Reference: `summarize_ns` and `bench_measure` in [bench.c](geolab/src/bench.c).

```c
memmove(scratch, samples, n * sizeof *scratch);
qsort(scratch, n, sizeof *scratch, compare_u64);      /* compare_u64 returns (x > y) - (x < y) */
s.min_ns = scratch[0]; s.max_ns = scratch[n - 1];
if (n % 2 == 1) s.median_ns = scratch[n / 2];
else { uint64_t lo = scratch[n / 2 - 1], hi = scratch[n / 2]; s.median_ns = lo + (hi - lo) / 2; }
```

`bench_measure` validates the specification in four steps:

1. Check `repeat` against [1, 1000] and `warmup` against [0, 100].
2. Check the variant, and the path for `parse`.
3. For `distance` and `query`, check the center, the radius (`query`) and every point. Zero points is `BENCH_EMPTY`.
4. Read the clock resolution and allocate the two sample arrays.

It then runs `warmup + repeat` repetitions of `run_once`, which brackets exactly one region with two `mono_now_ns` readings:

```c
if (!mono_now_ns(&t0)) return BENCH_CLOCK_ERROR;
for (size_t i = 0; i < spec->count; ++i) { ... geo_distance_km(...); total += d; }
if (!mono_now_ns(&t1)) return BENCH_CLOCK_ERROR;
c.count = spec->count;
memcpy(&c.value, &total, sizeof total);            /* after the clock stops */
```

- Every repetition's checksum is compared with the first. A difference, even in a warm-up repetition, is `BENCH_CHECKSUM_MISMATCH`.
- Only the timed repetitions are kept as samples.
- A second reading below the first is `BENCH_CLOCK_ERROR`.
- A sample is short when `resolution > UINT64_MAX / 1000 || sample < resolution * 1000`. That tests the product without letting it wrap.
- `parse` with zero rows is `BENCH_EMPTY`.
- `*out` is written only on `BENCH_OK`, and both arrays are freed on every path.

**Tests.**

- The perturbation hook wraps `geo_distance_km` inside `bench.c` only; the test translation unit defines the macro before including the source. It returns `nextafter(d, +∞)` for the calls of one chosen repetition, and the kernel must report a mismatch, both for the second repetition (a warm-up) and for a timed one.
- Allocation failures give `BENCH_OUT_OF_MEMORY` with the output bytes unchanged.

**Faulty approach.** Timing the whole `run_once`, including `free(hits)` and the hash loop, adds work that is not the operation. Timing each distance call separately adds two clock reads, about 20–40 ns each here, to a 44 ns operation. That changes the thing being measured (week 14).

### E04.Q

**Checksums as evidence, not proof.** Each repetition's result is computed, compared with the first and printed. So the work that produced it cannot be deleted as unused: the program observes the result. And a repetition that computed something different (a stale buffer, a wrong index, an uninitialized variable) is caught, as the perturbation test demonstrates. It is not proof that every intended operation ran:

- A compiler may legally transform work whose result is not observable, or compute a result another way. With link-time optimization and a `geo_distance_km` it could prove pure, it could even notice that repetitions recompute the same value. It does not do so here: separate translation units and no LTO make the call opaque (the S02 diagnostics show the call treated as clobbering memory). But the checksum does not *prove* that. Week 30 demonstrates elimination.
- Different results can share a checksum. For `parse`, any reordering of the rows has the same identifier sum. For `query`, see the hash below.

**Order statistics, not the mean.** Interference is overwhelmingly *additive*: an interrupt, a migration to another core, a frequency change or another process can only make a repetition slower. So the distribution has a hard floor and a long right tail (P02 shows one 5,210 ns sample among ~800s).

- The **minimum** estimates the cost with the least interference. It is repeatable and a natural baseline, but it may be optimistic about typical use.
- The **median** estimates a typical repetition, and a single outlier moves it by at most one position.
- The **mean** is dragged by the tail. One 5,210 ns sample in eleven raises it by 50%.

**The median cannot overflow.** After sorting, `lo ≤ hi`, so `hi − lo` is a nonnegative value that does not wrap. `(hi − lo)/2 ≤ hi − lo`, so `lo + (hi − lo)/2 ≤ lo + (hi − lo) = hi ≤ UINT64_MAX`. Every intermediate is between 0 and `hi`. The value equals floor((lo + hi)/2) because lo + (hi − lo)/2 = (2lo + hi − lo)/2 rounded down.

The counterexample for the naïve form is `lo = hi = UINT64_MAX`. Then `lo + hi` wraps to 2^64 − 2, and halving gives 2^63 − 1, not `UINT64_MAX`. The tests use exactly that pair, and one with middle values 7 and `UINT64_MAX − 1`, whose median is 2^63 + 2.

**The order-sensitive hash.** `h = h · P + id` modulo 2^64 with P = 1099511628211, so h is a polynomial in P with the identifiers as coefficients in output order. Swapping the identifiers a and b at positions i < j changes h by (a − b)(P^(n−1−i) − P^(n−1−j)) mod 2^64. That is usually nonzero, so a reordering usually changes h. It cannot detect every reordering. P is odd, so every power of P is odd and the difference of two powers is even. If a − b = 2^63, the product is a multiple of 2^64: swapping two identifiers that differ by 2^63 leaves h unchanged. A 64-bit value also cannot distinguish all 2^64+ possible outputs (pigeonhole). The hash detects likely mistakes; it proves nothing.

**What each timed region contains.**

- `parse`: `fopen`, every `fgetc` of the file (through stdio's buffer and the kernel's page cache, so the file is warm after the first repetition, which is a hypothesis to label), the parsing, every `malloc`/`realloc` of the growing array, and `fclose`. The checksum loop and `free` come after.
- `distance`: only the loop of calls and the sum.
- `query`: the whole `query_points` call. That is validation of every point, every distance, selection, two allocations, the copy, `qsort` and one `free` of the temporary. The hash and the `free` of the result come after.

Nothing inside the `distance` region prints or allocates. Printing involves stdio buffering and system calls whose cost has nothing to do with distances, and allocation involves the allocator's state. Both would add variation and cost that are not the operation.

### E05.C

The exemplar protocol is [instructor/PROTOCOL.md](PROTOCOL.md), followed exactly for the exemplar report. It is also the default of [tools/bench_data.py](../tools/bench_data.py):

- the datasets d1k, d100k and d1m;
- the builds `-O2 VEC=off` and `-O2 VEC=default`, per compiler, at distinct paths;
- `distance` and `query` at every size, plus `parse` at d100k;
- center (10, 20) and radius 2,000 km;
- repeat 21 and warm-up 3, over five process runs;
- interleaved order, with the build order alternating between runs;
- stopping rule: report all five runs; repeat a run only for a documented fault.

A learner protocol that differs is fine if every element is stated before data collection and followed, and any deviation is recorded.

### E05.Q

**Warm-up.** The first repetitions pay one-time costs:

- first-touch page faults on newly allocated memory (the `query` allocations, and in `parse` the growing array);
- cold instruction and data caches;
- cold branch predictors and TLBs;
- the CPU raising its clock frequency from idle;
- for `parse`, reading the file into the page cache.

These are named as *hypotheses*. Page faults are measured in week 19 and caches in week 22. Warm-up repetitions are still checked (their checksums count) but not kept.

**Interleaving.** Conditions drift during a session: thermal state, frequency, background work. If every `VEC=off` run happened before every `VEC=default` run, any drift would look like a difference between the builds. Alternating the build order between runs spreads the drift across both.

**Stopping rule.** Deciding in advance to report five runs as recorded removes the temptation to rerun until the numbers look good. Timing results vary, so “rerun until it agrees with my expectation” reliably produces agreement, and that agreement is evidence of nothing. The only justified rerun is for a documented fault (a checksum difference, a nonzero exit), and that is written down.

**WSL and a hybrid CPU.** WSL 2 runs Linux in a virtual machine: the hypervisor schedules its virtual CPUs onto physical ones, and the host OS (Windows) runs its own work. The i7-12650H has performance and efficiency cores with different speeds and cache arrangements. A process may start on either and be migrated. Both add *between-run* variation that the program cannot see. Pinning with `taskset -c N` restricts the Linux scheduler, but inside WSL it pins to a *virtual* CPU, which the hypervisor may still move. So pinning is optional and labelled.

**The clock.** `CLOCK_MONOTONIC` measures elapsed time from an unspecified start. It cannot be set, and it does not jump when the wall clock is adjusted (clock_gettime(2); Linux documents that NTP may slew its rate). `CLOCK_REALTIME` is the wall clock: an administrator or NTP step can move it backwards or forwards during a measurement. `clock()` returns *processor time* used by the process (C11 §7.27.2.1). That is a different quantity: it excludes time spent waiting, and on Linux it has coarser granularity. `CLOCK_PROCESS_CPUTIME_ID` is the POSIX equivalent of the same quantity. None of these counts cycles (P01).

### E06.C

**Prediction** (recorded before running; exemplar R03 in [report.md](report.md)).

Reading `geo_distance_km`, each call:

- validates two positions (eight comparisons and four `isfinite`);
- performs two subtractions, six multiplications by π/180 or ½, and three multiplications and one addition for `a`;
- calls `sin` twice and `cos` twice. `cos(lat1)` of the fixed center is recomputed on every call, because the callee cannot know it is invariant;
- takes one square root (an instruction on x86-64, `sqrtsd`, when the compiler inlines `sqrt`) and one `asin`;
- does a clamp and two multiplications.

That is five `libm` transcendental calls per point.

Assumption, stated as one: each call costs 5–20 ns on this machine, so the range is 25–100 ns per point for `distance` and about the same plus a few ns for `query`. `query` adds a validation pass, an 8-byte store per point and the selection. Its sort handles only the hits: about 1–2% of points at 2,000 km in this dataset, so the sort is cheap.

The prediction was that nanoseconds per point stay **constant** across 10^3–10^6 points, because the work per point is fixed and the data are read sequentially, 24 MB at the largest size.

**Observation** (measured 2026-09-22, gcc builds; full tables in [report.md](report.md) and [sample-results](sample-results/gcc/summary.md)). Medians of five process-run medians, in ns per point:

| variant | 1,000 pts | 100,000 | 1,000,000 |
| --- | --- | --- | --- |
| distance, VEC=off | 33.69 (31.32–35.08) | 44.14 (43.73–44.43) | 44.69 (44.32–45.65) |
| distance, VEC=default | 32.85 (32.19–36.10) | 44.48 (43.78–45.08) | 44.66 (44.10–44.77) |
| query, VEC=off | 34.56 (33.61–37.56) | 47.36 (47.16–49.80) | 49.90 (49.76–50.45) |
| query, VEC=default | 35.03 (33.35–37.18) | 48.16 (47.72–49.01) | 49.55 (49.00–50.49) |
| parse (d100k), VEC=off / default | — | 91.06 / 91.02 | — |

The largest within-run spread was 3.9 (one d1k run with a large outlier); most were below 0.5.

### E06.Q

**Prediction against observation.** The magnitudes fall inside the predicted 25–100 ns range. That is weak confirmation: a range four times wide is easy to hit. The constant-cost prediction **failed** at the small end.

At 1,000 points, `distance` costs 31–36 ns per point in every run. At 100,000 and 1,000,000 points it costs 44–46 ns. The ranges do not overlap, so these runs separate the two sizes, but that does not establish a cause or statistical significance. Between 100,000 and 1,000,000 points the ranges overlap: no separation.

A follow-up run, recorded in validation.md and taken with other work on the machine, so it is noisier, suggests the change is a function of size rather than of which points are used. The first 1,000 rows of d100k behave like d1k, and the cost rises through 2,000, 5,000 and 10,000 points. A single cold pass over 1,000 points (no warm-up, one repetition) cost 60–75 ns per point.

**Hypotheses, each for a later week.** None was measured this week.

- *Working set in the nearest cache.* 1,000 points are 24 KB, which fits one 48 KB L1 data cache (`lscpu` reports 384 KiB in 8 instances inside WSL). The data of every repetition are then already in L1. Weeks 21–22 measure working-set effects.
- *Branch prediction trained on the data.* Repeating the same 1,000 points 24 times lets the predictors learn the outcomes of `libm`'s internal branches, which depend on argument ranges. With 100,000 points the history is too long to learn. Week 27 compares predictable and unpredictable branches in otherwise identical loops.
- *Fixed per-run overhead.* This is unlikely here. At 1,000 points a repetition takes about 33 µs, 33,000 clock resolutions, and a fixed cost would make small sizes *slower* per point, not faster.

**The two builds.** Prediction: little or no difference, because every loop body calls scalar `libm` functions and GCC 11 does not enable its vectorizer at `-O2`. Observation: the ranges overlap at every size and variant, for both compilers. S02 explains why this must be so for GCC: the `VEC=off` and `VEC=default` objects are **byte-identical**. That makes the pair an A/A comparison of one program with itself, and the differences it shows are pure run-to-run variation. The single-run smoke test (validation.md) reported 44.3 versus 35.6 ns per point for the same machine code. That 25% “difference” is the most useful number of the week: it shows what one run can produce.

**Reading a different machine's result.** A learner with another CPU, a native Linux install or a newer GCC may see different absolute numbers, a different size effect or none, and possibly a real `VEC` difference. GCC 12+ enables a cheap vectorizer at `-O2`, but it still cannot vectorize these loops, which call functions. Any of these results is valid if it was collected under a stated protocol and reported with ranges. The conclusions transfer only as *hypotheses*, never as numbers.

### E07.C

`make checkpoint` works in five steps:

1. Remove `build/PACKAGE`.
2. Run the full suite with GCC and Clang at `-O0` and `-O2`, and with GCC's sanitizers.
3. Run [tools/identity.py](../tools/identity.py): four `query` commands on d100k, including one that selects every point and one near the antimeridian, must give byte-identical output from the four non-sanitizer builds.
4. Write the manifest.
5. Require `PROTOCOL.md` and `report.md` to exist.

The instructor package passes. The learner scaffold fails in step 2 for behavioral reasons (validation.md). `make verify` adds Clang's sanitizer build, both benchmark builds for both compilers, a protocol smoke run and the scaffold check.

### E07.Q

**Why output identity is expected here, and why it is only an observation.** The printed distances are identical across the four builds because the same arithmetic is performed:

- `-ffp-contract=off` forbids fusing multiply and add (Clang's default would otherwise fuse).
- No `-ffast-math` means no reassociation.
- On x86-64, `FLT_EVAL_METHOD` is 0, so every `double` operation rounds to double; there is no x87 extended precision.
- `sin`, `cos` and `asin` come from the same glibc at run time. If glibc picks an FMA variant at run time, it picks the same one for all four builds on this machine.

None of this is an ISO C guarantee. C allows contraction by default (§6.5 ¶8, `FP_CONTRACT`), allows `FLT_EVAL_METHOD` other than 0, and does not require transcendental functions to be correctly rounded. A different compiler default, a 32-bit x87 target, or another `libm` could change the last bits of a distance. Only the printed digits and printed-tie orders would then be at risk. This is why the fixtures compare with tolerances and the identity check is a *toolchain observation*.

**What checkpoint 1 promises.** Later weeks may rely on four things:

- `generate` bytes;
- the `query` output format and ordering rule;
- the exit codes and the `geolab:` prefix;
- the build variants, including the `VEC=off` baseline.

A later checkpoint may add commands and accept `--threads`, `--backend` and `--index` values. It must bump the contract version if it changes an existing output.

**Why correctness and explanation, not speed.** A speed target rewards whichever machine and moment the learner happened to measure on. A measured difference means something only when the program is correct, the conditions are recorded and the variation is known. A faster wrong program is not a result. A slower program with an honest protocol and a well-labelled hypothesis is exactly what week 5 teaches.

### P01

1. **False in general; ISO C.** `clock()` returns the processor time used by the program (§7.27.2.1), not elapsed time. A program that sleeps uses little processor time.
2. **POSIX/Linux guarantee.** `CLOCK_MONOTONIC` “cannot be set” and represents monotonic time since an unspecified point (clock_gettime(2)). Linux documents that it is affected by gradual NTP adjustment but never jumps backwards. The benchmark still checks `t1 < t0` and reports a clock error, because a contract is cheap to check.
3. **False in general.** It counts nanoseconds of elapsed time. The x86 time-stamp counter (Handmade Hero 010, week 13) counts ticks of a fixed reference frequency on modern CPUs, and even that is not the core's actual cycle count.
4. **False; ISO C.** §7.22.5.2 makes no stability promise, and glibc's `qsort` is typically a merge sort, which happens to be stable, but that is an implementation observation. The query's determinism does not depend on it (E02.Q).
5. **ISO C guarantee.** A program starts in the `"C"` locale (§7.11.1.1 ¶4), whose decimal point is `.`. It holds until someone calls `setlocale`.
6. **False in general.** A faster time has many possible causes: noise (E06: byte-identical builds differed by 25% in one run), a different instruction selection, alignment, frequency. That the compiler vectorized is a claim about the generated code, shown by a diagnostic or the disassembly (S02), not by a time.

### P02

Sorted: 790, 795, 797, 798, 799, **801**, 803, 805, 808, 812, 5210.

| Statistic | With the outlier | Without it |
| --- | --- | --- |
| Minimum | 790 | 790 |
| Median | 801 | (799 + 801)/2 = 800 |
| Maximum | 5,210 | 812 |
| Mean | 13,218/11 = 1,201.6 | 8,008/10 = 800.8 |
| Spread (max − min)/median | 4,420/801 = 5.52 | 22/800 = 0.0275 |

One sample raised the mean by 50%, moved the median by one position (1 ns), and multiplied the spread by 200. Plausible causes are an interrupt, a context switch, a migration between a performance and an efficiency core, or a page fault. Nothing in the data distinguishes them.

The minimum estimates the cost with the least interference, and the median the typical repetition. The mean of a heavy-tailed distribution estimates neither. The spread is an honest warning that this run had an outlier: report it, do not delete the sample.

### P03

1. **Per point.** 44,660,000 ns / 1,000,000 = **44.66 ns per point**, or 10^9 / 44.66 = **2.24 × 10^7 points per second**.
2. **Bytes per second.** 24 bytes per point: 24 × 10^6 bytes / 0.04466 s = **0.537 GB/s**. Counting only the 16 bytes used: 16 × 10^6 / 0.04466 = **0.358 GB/s**. Units: (bytes/point) / (ns/point) = bytes/ns = GB/s.
3. **Cycles.** At a *stated* 3.0 GHz, 44.66 ns × 3.0 cycles/ns = **134 cycles per point**.
4. **Why it is only an estimate.**
   - The frequency is not fixed: turbo, power management and thermal limits move it within a run, and performance and efficiency cores differ.
   - Under WSL the guest does not control or even see the frequency.
   - `CLOCK_MONOTONIC` counts nanoseconds, not cycles, so the conversion multiplies by an assumed number.
   - The measured time includes loop overhead and any interference, not only the distance.

### P04

```
id,distance_km
5,0.000000
7,12.500000
40,12.500000
21,100.000000
9,100.000000
12,250.250000
2,250.250000
30,19999.999999
```

- **Exact tie:** 7 and 40 have the same double (12.5), so identifier order decides.
- **First printed tie:** 21 (100.0000001) and 9 (100.0000004) both print `100.000000`. 21 is nearer, so it comes first although 21 > 9.
- **Second printed tie:** 12 (250.25) and 2 (250.25000000000003, one ulp above) both print `250.250000`. 12 is nearer, so it comes first although 12 > 2.

The %a column is what makes the order unambiguous: the decimal column's rounding hides the second difference entirely.

### P05

| # | Exit | Stdout | First diagnostic line |
| ---: | ---: | --- | --- |
| 1 | 0 | yes | none |
| 2 | 2 | no | `geolab: missing option` |
| 3 | 2 | no | `geolab: bad --lat` (95 exceeds 90) |
| 4 | 3 | no | `geolab: unsupported in checkpoint 1 (only --threads 1 --backend scalar --index none)` |
| 5 | 2 | no | `geolab: bad --backend` (`gpu` is not a planned backend) |
| 6 | 1 | no | `geolab: PARSE_OPEN_ERROR at line 0 in missing.csv` |
| 7 | 1 | no | `geolab: empty benchmark input` |
| 8 | 2 | no | `geolab: duplicate option --repeat` |
| 9 | 2 | no | `geolab: bad --seed` (no sign allowed) |
| 10 | 0 | yes | none: `-0.0` is accepted as +0.0, and radius 0 selects only points at exactly (0, 1.5) |

Usage errors are followed by a `usage:` line. The order of checks decides which diagnostic appears first. For 3, the numbers are parsed before the file is opened, so a bad latitude is reported even if the file is missing.

### S01

Run [extras/bytes_per_point.c](extras/bytes_per_point.c). The derivation:

- **Latitude.** Microdegrees are uniform over the 180,000,001 integers in [−9×10^7, 9×10^7]. A field is an optional `-`, one or two integer digits, `.`, and six digits: 8 fixed characters counting one digit. Two integer digits are needed for 160,000,002 values (|v| ≥ 10^7), and a sign for 90,000,000. So E[lat field] = 8 + 160000002/180000001 + 90000000/180000001 = **9.388889** bytes.
- **Longitude.** Integer digits number 1 for 19,999,999 values, 2 for 180,000,000 and 3 for 160,000,002, and 180,000,000 values are negative. So E[lon field] = 8 + (180000000 + 2·160000002)/360000001 + 180000000/360000001 = **9.888889** bytes.
- **Whole file.** Expected size = 19 + Σ digits(1..n) + n(3 + 9.388889 + 9.888889). For n = 10^6, Σ digits = 5,888,896 and the expected size is 28,166,692.8 bytes. The actual file is 28,166,857 bytes, a relative difference of 5.8e−6, consistent with sampling variation (measured). That is **28.17 CSV bytes per row**.

Per point, by variant:

| Variant | Read | Written |
| --- | --- | --- |
| `parse` | 28.17 bytes of CSV | 24 bytes of `GeoPoint` (reference ABI, gated) |
| `distance` | 16 of the 24 bytes of each `GeoPoint` (`lat_deg`, `lon_deg`) | nothing |
| `query` | 16 bytes, plus 8 read back from the temporary distance array | 8 bytes to that array, plus 16 bytes per hit |

With the measured medians at d1m (gcc, `VEC=off`):

- distance: 16 / 44.69 = **0.36 bytes/ns**, or 24 / 44.69 = 0.54 counting whole structures;
- query: (16 + 8 + 8) / 49.90 ≈ 0.64 bytes/ns before the hits;
- parse at d100k: 27.17 / 91.06 ≈ **0.30 CSV bytes/ns**.

**What this does not show.** Whether memory bandwidth limits any of these. Sequential reads on this class of machine are commonly an order of magnitude faster than 0.5 GB/s, which *suggests* these loops are compute-bound, but that is a hypothesis until week 21 measures bandwidth. The per-point bytes also ignore cache-line granularity: reading 16 of 24 bytes still moves whole 64-byte lines (week 23).

### S02

Run [extras/vec_report.sh](extras/vec_report.sh). Recorded output, 2026-09-22 (a toolchain observation for these compiler versions):

- **GCC 11.4.0 at `-O2`:** `-ftree-loop-vectorize [disabled]` and `-ftree-slp-vectorize [disabled]`. The vectorizer does not run at all, so `-fopt-info-vec-all` reports nothing.
- **GCC with `-ftree-vectorize` added** (only to see what it would try): `bench.c:96:20: missed: not vectorized: control flow in loop` and `statement clobbers memory: … geo_distance_km (…)`.
- **Clang 14 at `-O2`:** `bench.c:95:9: remark: loop not vectorized: could not determine number of loop iterations`, and `bench.c:97:18: remark: loop not vectorized: call instruction cannot be vectorized`.
- **`cmp`:** every GCC object is byte-identical between `VEC=off` and `VEC=default`. For Clang, only `csv.o` differs (some loop in the CSV code, not the distance loop, is vectorized by default); `geo.o`, `query.o` and `bench.o` are identical.

**Explanation.** The distance loop's body calls `geo_distance_km`, an external function in another translation unit whose code the compiler cannot see. A vectorizer turns N iterations into one iteration over N lanes. That needs a vector version of every operation in the body, and there is no vector version of an opaque scalar call. Inside `geo_distance_km`, the calls to `sin`, `cos` and `asin` are the same obstacle one level down. The early `return BENCH_INVALID` on a failed call is control flow that leaves the loop, so the trip count is not known in advance: both compilers name that separately.

So for this loop the `VEC=off` and `VEC=default` builds *must* behave alike, and for GCC 11 they are the same machine code. The timing comparison between them in E06 is therefore an A/A test that measures noise. Week 31 starts here: it removes the call and the early exit from a loop, and compares scalar, compiler-vectorized and explicit-SIMD forms. A learner whose newer GCC (12+) enables the cheap vectorizer at `-O2` will see different `cmp` results for some objects. That is a valid different observation.

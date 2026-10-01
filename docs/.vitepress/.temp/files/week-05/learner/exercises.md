# Project 1 — `geolab` checkpoint 1: milestones

Seven milestones build one program. Keep every public function signature and type in [geolab/include](geolab/include): the contract tests link your objects without `main.o` and call those functions directly. Every `.C` prompt requires code plus the tests that come with it; every `.Q` requires a worked explanation in your report or a notes file. The contract for the whole program is [CHECKPOINT-1.md](../CHECKPOINT-1.md). See [the rubric](../rubric.md) for how it is assessed.

General contract. A function that reports a status returns 1 on success and 0 on rejection unless its header says otherwise. **A rejected call leaves every output object unchanged**: validate everything, then commit. A NULL output pointer is a rejection. Never rely on signed overflow, on argument evaluation order, on the locale or on `errno` from math functions. Library functions never print or exit; only the `cmd_*` functions talk to the user. Every integer computation that can overflow is bounded or checked, sums as well as products.

**Predict before you run.** Your E06 predictions go into `report.md` before you run `make bench-data`, and are not edited afterwards.

### E01.C

**One program, several translation units.** Paste your week-4 generator, formatter, parser and loader into [csv.c](geolab/src/csv.c), and your week-3 haversine into [geo.c](geolab/src/geo.c). Keep only the functions declared in `geolab.h` external and make every helper `static`. One change from week 4: after a failure that follows a successful `fopen`, remove the partial output only if `stat` says it is a regular file.

Then implement in [cli.c](geolab/src/cli.c):

- `int parse_cli_decimal(const char *text, int allow_sign, int64_t limit_micro, double *out)`. The grammar is `-?(0|[1-9][0-9]*)(\.[0-9]{1,6})?`, with the `-` only when `allow_sign` is nonzero. Accumulate the value as an integer number of millionths with checked arithmetic and require `|micro| <= limit_micro`, where `limit_micro` must lie in `[0, 10^15]`. Convert with one division by `1e6`. `-0.0` gives `+0.0`. No `strtod`, `atof` or locale.
- `cmd_generate`. Scan the options with the supplied `cli_scan`. `--count`, `--seed` and `--out` are all required, and `--count` is at most `GEOLAB_MAX_ROWS`. Usage errors go through `cli_usage` (exit 2). A failed write prints `geolab: could not write FILE` (exit 1). Success prints nothing.

The Makefile compiles each `.c` into its own `.o`; `make symbols` lists what each object exports.

Tests:

- `generate` bytes and SHA-256 equal week 4's oracle for two recorded seeds, and `--count 0` writes only the header.
- More than 8,000 command-line number cases, from the oracle and from a named list, are each accepted or rejected. The named list covers `90`, `90.000001`, `-180`, `.5`, `5.`, `1e2`, `+1`, `01`, `1.1234567`, a 20-digit integer part, `-0.0`, empty, `nan` and more. An accepted case must equal **exactly** the correctly rounded double the oracle computed with rational arithmetic; that check is gated on Annex F.
- Every usage error exits 2 and creates no file. `--out /dev/full` fails with exit 1 and the device survives.
- Every object's external symbols are declared in a project header (a toolchain observation, skipped without `nm`).

### E01.Q

Explain:

- The header/implementation split, and what `static` changes for the linker (compare the output of `make symbols` before and after you make a helper static).
- Why the command-line parser accumulates integers instead of calling `strtod`.
- Your overflow guard for the integer part, with a proof that no `int64_t` operation can overflow for any input string and any valid `limit_micro`.
- Why one division `micro / 1e6` gives the correctly rounded value of the typed decimal, including the Annex F precondition and why that is not the same as “exact”.
- Why the command line accepts `-0.0` while CSV v1 rejects `-0.000000`: when may an input format be more lenient than a data format, and why is this one lenient about nothing else?

Show a faulty `atof`-based version and three inputs it mishandles.

### E02.C

**A deterministic query.** Implement `query_hit_compare` and `query_points` in [query.c](geolab/src/query.c) (contract in `geolab.h`), then `cmd_query` in [cli.c](geolab/src/cli.c).

- **Validate first:** the center, a finite radius in `[0, 100000]`, `points` non-NULL when `count > 0`, and every point.
- Compute each distance exactly once with `geo_distance_km`.
- Select `distance <= radius_km`, inclusive, comparing the unrounded distance with the parsed radius.
- Allocate exactly the needed array, checking `n * sizeof(QueryHit)`; it is NULL for zero hits.
- `qsort` with a comparator that returns −1, 0 or 1 by distance, then identifier.
- On failure, free anything you allocated and leave both outputs unchanged.

`cmd_query` checks the checkpoint-only options with the supplied `cli_check_future_options`, then loads, queries and prints. Print `id,distance_km` and one `ID,D` line per hit with `"%.6f"`, only after everything has been computed. Check every write and `fflush(stdout)`: a failure prints `geolab: output error` and exits 1.

Tests:

- The C suite checks that every hit set is exactly `{distance <= r}` and sorted by `(distance, id)`, on the 1,000- and 100,000-row datasets with centers at the poles, on the antimeridian and elsewhere, and radii 0, 250, 2,500 and 20,016 km.
- **Exact tie:** identical coordinates with different identifiers come out in identifier order.
- **Printed tie in reverse identifier order:** identifier 2 at (0.600366, 0.79974) and identifier 1 at (0, 1) both print `111.195080` around (0, 0), but identifier 2 is nearer and must stay first.
- The inclusive boundary through the C API: a radius equal to a computed distance includes the point, and `nextafter(radius, 0)` excludes it.
- Radius 0 at an existing point.
- Empty input, and an empty result.
- Every rejection leaves the outputs unchanged, including under an injected `malloc` failure.
- The oracle comparisons of `geolab query` output apply the tolerance rule.
- Exit codes: 2 for malformed values; 3 for `--threads 4`, `--backend simd` or `--index grid`.
- Nothing is printed on failure, and output to `/dev/full` reports `geolab: output error`.

### E02.Q

Explain:

- Why `qsort`'s output here is deterministic although C11 §7.22.5.2 promises no stability. What would have to be true of two elements that compare equal, and what do they print?
- Why `return (int)(a->d - b->d);` is wrong in two different ways.
- Why the order is decided by the unrounded value, and what goes wrong if you sort by the printed text. Use the printed-tie case.
- What the six printed decimals do and do not tell a reader of the output.
- Why an exact tie is built from **identical coordinates** rather than from two points placed symmetrically: what would you have to know about `sin` in `libm` to promise that `+x` and `−x` give bit-identical distances?
- Why the inclusive boundary is tested through the C API rather than through the six-decimal command line.

### E03.C

**Fixtures with reasons.** Add at least six hand-written CSV v1 files to [fixtures](fixtures) and list each in [fixtures/README.md](fixtures/README.md) with its purpose, arguments and one sentence on what it would catch. The required purposes are `pole`, `antimeridian`, `exact-tie`, `printed-tie`, `empty` and `malformed`; the malformed file must produce exit 1, a `geolab: PARSE_…` diagnostic and no standard output. Then run `make expected`, which writes each expected output **from the supplied oracle**, not from your program. The tests run every listed fixture, fail if a listed file is missing or a `.csv` is unlisted, and fail if an expected file no longer equals the oracle's output. **Playground:** before running, predict each fixture's output lines on paper, then reconcile.

### E03.Q

Explain:

- Why the supplied oracle is independent of your program. Name what it shares with your program and what it does not.
- The tolerance rule in `tests/fixture_lib.py`: what it compares exactly, what it compares within a tolerance, and why a single global tolerance of 5e−7 km would have made the printed-tie fixture impossible to check.
- Trace one of your fixtures through the oracle by hand: the loaded coordinates, the distances it computes, the selection and the order.
- What differential testing against this oracle cannot catch. Give at least two concrete examples.

### E04.C

**Samples and their summary.** Implement in [bench.c](geolab/src/bench.c):

- `summarize_ns` (the contract is in `bench.h`). For an even count, the median is `lo + (hi - lo) / 2` of the two middle values.
- `bench_measure`. Validate the specification. Run the warm-up and timed repetitions, bracketing **exactly** the specified region with two `mono_now_ns` readings:
  - `parse`: `load_points`, including its allocations and close;
  - `distance`: the distance loop and its left-to-right `double` sum;
  - `query`: `query_points` as one operation.
- Compute each repetition's checksum after the clock stops. **Fail if any repetition's checksum differs from the first.**
- Count short samples, below 1,000 clock resolutions, without a product that could wrap.
- Return `BENCH_EMPTY` for zero points.

The option handling and printing of `cmd_bench` are supplied.

Tests:

- `summarize_ns` against hand-computed values, including a single sample, even counts, and values near `UINT64_MAX`; rejections leave outputs unchanged.
- The checksums for each variant are recomputed independently.
- A header-only input fails every variant.
- A **perturbation hook** in the test translation unit makes one repetition compute a different distance, and the kernel must report a mismatch, both during warm-up and after it.
- Invalid specifications are rejected, and injected allocation failures return `BENCH_OUT_OF_MEMORY` with the output unchanged.
- `geolab bench` prints a parsable line for every variant.

### E04.Q

Explain:

- Why every repetition's checksum is computed, compared and printed. What evidence does this give, and why is it **not** a proof that every intended operation ran? (Collisions exist, and a compiler may transform work whose result is not observable; week 30 demonstrates that.)
- Why order statistics instead of the mean. What does the minimum estimate, and what does the median estimate?
- Prove that the median formula cannot overflow, and show a pair of values for which `(lo + hi) / 2` does.
- Why the order-sensitive hash exposes a reordering, and what it cannot detect.
- What exactly lies inside each timed region, and why nothing inside the `distance` region prints or allocates.

### E05.C

**The timing protocol.** Write [PROTOCOL.md](PROTOCOL.md) **before** collecting report data, then run `make bench-data`, which executes the supplied runner [tools/bench_data.py](../tools/bench_data.py) and writes raw outputs to `results/`. The protocol states:

- the datasets (seeds and counts) and both builds, `VEC=off` and `VEC=default`;
- the warm-up and repetitions, and the number of process runs (at least five);
- the order of runs (interleaved);
- what you held constant, and whether you pinned the CPU;
- what is recorded;
- your **stopping rule**, fixed in advance.

If you change the runner's parameters, say so in the protocol. The runner checks that the file set exists and that every line parses. Nothing asserts a time.

### E05.Q

Justify each element of your protocol:

- Why warm-up. Name at least three mechanisms, and label each as a hypothesis: the course measures them in weeks 19 and 22.
- Why interleaving.
- Why a stopping rule prevents you from choosing the result you like.
- Why WSL and a hybrid performance/efficiency CPU add variation.
- Why `CLOCK_MONOTONIC` rather than `CLOCK_REALTIME` or `clock()`. Cite the man page and C11 §7.27.2.1.

### E06.C

**Prediction, then observation.** First, in `report.md` (R03), predict `median_ns_per_point` for `distance` and `query` at 1,000, 100,000 and 1,000,000 points:

- Count the `libm` calls and other floating-point work per point by reading your haversine.
- State a per-call cost range as an assumption.
- Say whether you expect nanoseconds per point to stay constant as the dataset grows.

Then run the protocol and fill the observation table (R04). For each variant, size and build, give the five process-run medians, their minimum and maximum, and the within-run spread `(max_ns − min_ns) / median_ns`. When the median is zero, mark the ratio undefined and report the raw samples.

### E06.Q

Compare your prediction with the observation using this rule: overlapping ranges of process-run medians show no clear separation, and non-overlapping ranges describe these runs without establishing statistical significance or a cause. Explain how someone should read a different valid result from another machine. Say what could make nanoseconds per point change with dataset size, and label each mechanism as a hypothesis and name the later week that tests it. Say what you expected from the `VEC=off`/`VEC=default` comparison for a loop that calls scalar `libm` functions, and check it against the compiler's own diagnostics (S02) rather than assuming it.

### E07.C

**Checkpoint release.** Run `make checkpoint`. It does five things:

1. A clean build with GCC and Clang at `-O0` and `-O2`, each running the full test suite.
2. The sanitizer run.
3. A byte-identity check that `query` output on the 100,000-row dataset is identical across the four builds.
4. The submission manifest (`build/learner/MANIFEST.txt`).
5. A check that `PROTOCOL.md` and `report.md` exist.

Finish `report.md` (R01–R05).

### E07.Q

Explain:

- Why output identity across the four builds is expected here: `-ffp-contract=off`, no reassociation, `FLT_EVAL_METHOD == 0` on x86-64, and one `libm` at run time.
- Why that identity is an observation of this toolchain rather than a C guarantee.
- What checkpoint 1 promises to later weeks and what a later checkpoint may change.
- Why a project passes on correctness and explanation rather than on speed.

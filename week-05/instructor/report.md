# Project 1 report — exemplar

This is an illustrative completed report. Its measurements are real, recorded on the reference machine on 2026-09-22 and kept in [sample-results](sample-results). A learner's numbers will differ. Grade the structure and the reasoning, not the digits.

### R01

**Environment** (from the `env` block of every output, `uname`, `lscpu`, and the tool versions).

| Item | Value | Source |
| --- | --- | --- |
| CPU | 12th Gen Intel Core i7-12650H, 16 logical CPUs, hybrid performance/efficiency cores | `/proc/cpuinfo`, `nproc` |
| Virtualization | WSL 2: Linux in a virtual machine on Windows 11 | `uname` |
| Kernel | 6.18.33.2-microsoft-standard-WSL2 x86_64 | `uname(2)` |
| OS, C library | Ubuntu 22.04, glibc 2.35 | `ldd --version` |
| Compilers | GCC 11.4.0; Clang 14.0.0 | `__VERSION__`, `--version` |
| Python (harness only) | 3.10.12 | `python3 --version` |
| Build `VEC=off` | `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L -O2 -fno-tree-vectorize` (GCC) or `… -O2 -fno-vectorize -fno-slp-vectorize` (Clang) | `env flags=` |
| Build `VEC=default` | the same without the vectorization switches | `env flags=` |
| Clock | `CLOCK_MONOTONIC`, reported resolution 1 ns | `clock_getres` |

No forbidden flag appears (`-ffast-math`, `-Ofast`, `-funsafe-math-optimizations`, `-march=native`, `-ffp-contract=fast`). The test driver checks this, and the `env flags=` lines show it.

### R02

**Correctness, established before any timing.**

- `make checkpoint` passed. That means GCC and Clang at `-O0` and `-O2`, plus GCC with AddressSanitizer and UndefinedBehaviorSanitizer. `make verify` adds Clang's sanitizer build.
- The three contract suites passed:
  - more than 8,000 command-line numbers, each compared bit for bit with the oracle's rational value (gated on Annex F);
  - query order and membership over 6 centers × 4 radii on two datasets, plus the exact tie, the printed tie, the inclusive boundary and rejections with injected allocation failures;
  - order statistics at the `uint64_t` extremes, the perturbation hook, and empty inputs.
- The forced-skip builds skipped the gated checks.
- Eight `geolab query` outputs agreed with the independent oracle under the tolerance rule, and so did the seven fixtures.
- `generate` reproduced week 4's digests.
- The `query` output on d100k was byte-identical across the four builds.
- The protocol's checksums were identical across all five runs and both builds of each compiler (`faults.txt`: none).

**What this does not cover.**

- Behavior on inputs no test contains.
- The correctness of anything the oracle shares with the program: the specification, the radius constant, and glibc's `libm`.
- Leaks on the one error path no test reaches, an allocation failure inside `cmd_query` (validation.md).
- Any claim about speed.

### R03

**Prediction**, from the model in the answer to E06.C. Honesty note: the implementing agent had seen one smoke-run number before writing this exemplar, so it illustrates the form of a prediction; it is not evidence of blind prediction.

- **Model:** five `libm` calls per point (`sin` ×2, `cos` ×2, `asin`), plus about a dozen arithmetic operations, a square root and the validation. Assumption: 5–20 ns per `libm` call on this machine.
- **Predicted `median_ns_per_point`:**
  - `distance`: 25–100 ns at every size, most likely about 40–60.
  - `query`: the same plus 2–5 ns, for the extra validation pass, the temporary store and the selection. The sort handles only about 1–2% of points.
- **Size:** cost per point **constant** from 10^3 to 10^6 points, because the per-point work is fixed and access is sequential.
- **Builds:** `VEC=off` and `VEC=default` indistinguishable, because the loop calls scalar functions.

### R04

**Observation and uncertainty**: GCC builds, five process runs each, `median_ns_per_point`, with the range of the five medians. Full data, including Clang, are in [sample-results/gcc/summary.md](sample-results/gcc/summary.md) and [sample-results/clang/summary.md](sample-results/clang/summary.md).

| Variant | Size | `VEC=off`: median (range) | `VEC=default`: median (range) | Largest within-run spread |
| --- | --- | --- | --- | --- |
| distance | 1,000 | 33.69 (31.32–35.08) | 32.85 (32.19–36.10) | 0.38 / 3.91 |
| distance | 100,000 | 44.14 (43.73–44.43) | 44.48 (43.78–45.08) | 0.28 / 0.21 |
| distance | 1,000,000 | 44.69 (44.32–45.65) | 44.66 (44.10–44.77) | 0.12 / 0.18 |
| query | 1,000 | 34.56 (33.61–37.56) | 35.03 (33.35–37.18) | 1.83 / 1.58 |
| query | 100,000 | 47.36 (47.16–49.80) | 48.16 (47.72–49.01) | 0.48 / 0.37 |
| query | 1,000,000 | 49.90 (49.76–50.45) | 49.55 (49.00–50.49) | 0.16 / 0.13 |
| parse | 100,000 | 91.06 (90.43–92.69) | 91.02 (90.74–91.46) | 0.10 / 0.11 |

No short samples in any run: the shortest repetition, about 31 µs, is 31,000 clock resolutions.

**Variation.** Between-run ranges are about 1–4 ns at 1,000 points and under 2 ns at larger sizes. Within-run spreads are mostly below 0.5, with occasional single outliers at 1,000 points (3.9 in one run). Short repetitions are the most exposed to one interruption.

**Comparisons**, applying the rule from the protocol:

- `VEC=off` against `VEC=default`: the ranges overlap for every variant and size. No separation. The two GCC builds are byte-identical machine code (S02), so this is an A/A comparison and its differences are noise. A single-run smoke test had shown 44.3 against 35.6 ns per point for the same code (validation.md).
- 1,000 points against 100,000: the ranges do not overlap for `distance` or `query`. These runs separate the sizes; that alone does not establish significance or a cause.
- 100,000 against 1,000,000: `distance` ranges overlap. `query` ranges nearly touch (49.80 against 49.76 for `VEC=off`); no clear separation.
- Clang against GCC: not compared. The runs were not interleaved between compilers, so drift over the session cannot be separated from a compiler effect.

**Claim ledger.**

| # | Claim | Label |
| ---: | --- | --- |
| 1 | `clock()` measures processor time, not elapsed time | C11 §7.27.2.1 |
| 2 | `CLOCK_MONOTONIC` cannot be set and does not jump with wall-clock changes | POSIX/Linux (clock_gettime(2)) |
| 3 | A program that never calls `setlocale` prints `.` in `%.6f` | C11 §7.11.1.1 ¶4 |
| 4 | `micro / 1e6` is the correctly rounded value of the typed decimal | C11 Annex F (F.3) |
| 5 | `qsort` does not promise stability; the output is still deterministic | C11 §7.22.5.2, plus the comparator argument |
| 6 | GCC 11.4 does not enable its loop vectorizer at `-O2` | compiler (`gcc -Q --help=optimizers`) |
| 7 | The `VEC=off` and `VEC=default` GCC objects are byte-identical | observed on this machine (`cmp`) |
| 8 | `query` output is byte-identical across GCC and Clang at `-O0` and `-O2` | observed on this machine (toolchain) |
| 9 | Distances agree with the independent formula within 9.1e−12 km below 15,000 km | oracle comparison, measured |
| 10 | 1,000 points cost about 33 ns per point and 100,000 about 44 | observed on this machine |
| 11 | The 1,000-point case fits a 48 KB L1 data cache | hardware (lscpu) plus arithmetic; the causal link is a hypothesis |

**The evidence permits** four conclusions:

- The scalar baseline on this machine is about 44–45 ns per point for `distance` and 48–50 for `query` at 10^5–10^6 points, and about 91 ns per row for `parse` at 10^5.
- The two vectorization settings made no observable difference, and for GCC they could not.
- Smaller datasets were cheaper per point in these runs.
- One run can mislead by 25%.

**It does not permit** four others:

- a cause for the size effect;
- any claim about memory bandwidth or caches;
- any comparison between the compilers;
- any claim about another machine.

### R05

**Manifest:** `build/instructor/MANIFEST.txt`, written by `make checkpoint`. It covers the `geolab` sources and headers, the fixtures and their expected files, `PROTOCOL.md`, `report.md`, the Makefile, and `results/` when present.

**Defense (source → mechanism → observation).**

- **Source:** in `query_hit_compare`, the order is decided by comparing `distance_km` values, then identifiers, and returns −1, 0 or 1.
- **Mechanism:** a total order on (distance, id), in which equal elements print identical lines, makes `qsort`'s output a function of the input even though `qsort` is not stable. The unrounded distance is the key, not its six-decimal rendering.
- **Observation:** the printed-tie fixture prints identifier 2 before 1, both at `111.195080`. The mutant that sorts by the printed value fails the suite. Four different builds produce identical bytes for 100,000 points.

**The scalar baseline for later weeks:**

- dataset d1m (seed 5, SHA-256 `513c4440…0a42`);
- build `gcc -O2 VEC=off`;
- command `geolab bench --input build/data/d1m.csv --variant distance --repeat 21 --warmup 3 --lat 10 --lon 20 --radius-km 2000`;
- five process-run medians of 44.69, 44.32, 45.65, 44.35 and 44.79 ns per point (median 44.69), on the machine in R01, on 2026-09-22.

**Open question for week 6.** What machine instructions does the distance loop actually execute, and how many of them? The diagnostics say it calls `geo_distance_km` and then `sin`, `cos` and `asin`, but what do those calls turn into, and where do the ~45 ns go?

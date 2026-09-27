# Completed exemplar — `geolab` data-pipeline notebook

The predictions in this document are **illustrative prior hypotheses**, not a claim that an automated agent performed a human learner's before/after exercise. The sample observations were taken from the actual reference build recorded in [validation.md](validation.md). Different valid observations are accepted, and no machine's digits are presented as universal. Full E01.C–E07.C, E01.Q–E07.Q, P01–P06 and S01–S02 responses are in [answers.md](answers.md); this notebook integrates them rather than replacing them with an output table.

### R01

Example environment: 2026-09-21, x86-64, Intel Core i7-12650H, Ubuntu 22.04 under WSL2, Linux kernel 6.18.33.2-microsoft-standard-WSL2. Compilers: GCC 11.4.0-1ubuntu1~22.04.3 and Clang 14.0.0-1ubuntu1.1. glibc 2.35 (Ubuntu 2.35-0ubuntu3.15) supplies `libm`. GNU binutils 2.38, GNU Make 4.3, Python 3.10.12. Versions were read from each tool's `--version` output, `ldd --version` and `/proc/cpuinfo`.

Commands: `make PACKAGE=instructor CC=gcc test`, the Clang equivalent, each again with `MODE=optimized`, and `make verify` for the whole matrix including AddressSanitizer/UndefinedBehaviorSanitizer, the reproducibility audit and the scaffold checks. Flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off` with `-O0`, or `-O2`; the sanitize mode uses `-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie` and links `-no-pie`. Every link adds `-lm`. **None of `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` or `-march=native` appears in any strict-build command**; the test driver asserts this and refuses to run otherwise. The only place they (and `-ffp-contract=fast -march=x86-64-v3`) were used is the labelled experiments recorded in E07.Q and S02, each compiled by hand outside the course build. Each fact's source: tool output for versions; the Makefile for flags; `check.py` for the forbidden-flag assertion.

### R02

Predictions were written before running; observations are the reference build's.

| Exercise | Illustrative prediction (before running) | Sample observation | Source → mechanism → explanation |
| --- | --- | --- | --- |
| E01 | The first output for seed 0 is the high half of the increment, because the state is advanced *before* the output and the seed is 0: 1442695040888963407 = `0x14057B7EF767814F`, so `14057B7E`. | `seed=0 first=14057B7E,1A08EE11,9AF67822`; `bound7=4,3,5,5,5,0,1,5,4,5`. | The recurrence with defined unsigned wraparound; the oracle and `bc` agree on the values. |
| E02 | `-1` → `-0.000001`, `-500000` → `-0.500000`, a `UINT64_MAX` record is 44 characters. | Exactly those. *Illustrative preserved prediction:* a learner who predicted that a `%d.%06d` version prints the sign of −1 would find `0.000001` and must keep the wrong prediction beside the observation. | Integer division of −1 by 10⁶ truncates to 0, so a sign taken from the quotient is lost; the correct code tests `value < 0` once. |
| E03 | A 1,000-row file has between 21,912 and 26,912 bytes: 19 header bytes, plus per row `digits(id) + 19` (shortest: `d,0.000000,0.000000\n`) to `digits(id) + 24` (longest: `d,-89.999999,-179.999999\n`), and the identifiers 1…1000 have 2,893 digits in total. A better estimate from the mean field lengths (latitude 9.39, longitude 9.94, identifier 2.893 digits, plus two commas and a newline) is about 25,245. | 25,253 bytes for seed 1; SHA-256 `3b13098d…145da`; identical for GCC/Clang at `-O0`/`-O2`. | The range follows from the grammar; the mean from the distributions (a uniform degree is one digit below 10, so the expected length is 1 + 8/9 = 1.889 integer digits for latitude). Determinism from defined unsigned arithmetic, sequenced draws, integer formatting, binary mode. |
| E04 | Five hand-chosen lines: `1,0.000000,0.000000` accepted; `01,1.000000,1.000000` `PARSE_BAD_ID`; `5,91.000000,0.000000` `PARSE_LAT_RANGE`; `9,-0.000000,0.000000` `PARSE_BAD_LAT`; `18446744073709551616,0.000000,0.000000` `PARSE_BAD_ID`. | All five as predicted; 8,510 oracle lines agree (1,248 valid). | Canonical grammar and a fixed order of error classes; the overflow guard `v ≤ (UINT64_MAX − d)/10` rejects the last line, and a product-only guard would have accepted it as identifier 0. |
| E05 | 3,000 rows need one `malloc` of 1,024 elements and two `realloc`s (2,048 and 4,096); every error path frees everything; a directory path is an I/O error on Linux. | Exactly that on the reference platform (24,576 / 49,152 / 98,304 bytes); zero live blocks after every injected and fixture failure; no leak under LeakSanitizer. | Checked doubling with a temporary pointer; single-exit cleanup. `fgetc` results in an `int`. |
| E06 | `within = 5` for the built-in dataset; the sum is `R (rad(19) + 3π + π/3) ≈ 68829.75`; the haversine and the reference agree to about 10⁻¹² km on that dataset. | `points=12 within=5 sum_km=68829.754665 min_km=0.000000 max_km=20015.114442`; `reference_max_abs_diff_km=1.819e-12`. | Analytic central angles; a different method (unit vectors) as reference. |
| E07 | `ramp` exact for all three; `cancel`: naive 1 (the `+1` after 1e16 is lost), Neumaier 2; `tenths`: the naive sum is visibly off in the last six or seven digits of 100000 (each of a million additions to a running sum near 10⁵ can lose up to half an ulp, 7·10⁻¹² of it), pairwise and Neumaier are exact. | `ramp` exact; `cancel` 1, 1, 2; `tenths` naive 100000.00000133288 (error 1.33·10⁻⁶), pairwise and Neumaier exact; `grid` accumulated 1.33·10⁻¹¹ versus explicit 2.2·10⁻¹⁶. | Rounding at every addition of a large running sum; compensation recovers the lost low bits; the index-based grid has at most two roundings. |

### R03

**Implementation-dependent observations.** (1) *The last digits of a distance sum.* The `sum_km` of the built-in dataset prints as `68829.754665` on this machine, but its last digits come from `sin`, `cos` and `asin` in glibc 2.35 (not required to be correctly rounded, and possibly different on another glibc or CPU); the portable relationship the tests use is agreement with the analytic value `R (rad(19) + 3π + π/3)` and with the unit-vector reference to a stated tolerance. (2) *Signedness of `char`.* It is signed on x86-64 Linux (*measured*: `(char)0xFF == EOF` evaluates to 1), unsigned on some ARM ABIs; the portable relationship is storing `fgetc` in an `int`, and the `high_byte.csv` fixture fails on a `char` variable wherever `char` is signed. (3) *How large the naive summation error is* (91,595 ulps on `tenths`) depends on the order of the additions and on whether a compiler vectorizes the loop; the portable relationship is the bound `γ_{n−1} Σ|xᵢ|`.

**Claim ledger.**

| Statement | Label |
| --- | --- |
| A computation on unsigned operands is reduced modulo 2^N and never overflows. | C11 §6.2.5¶9 |
| `-x` for `x == INT32_MIN` (32-bit `int`) is undefined. | C11 §6.5¶5 |
| Conversion between an IEC 60559 format and decimal with `DECIMAL_DIG` or fewer digits is correctly rounded, so `strtod("0.123456")` equals `(double)123456 / 1e6`. | Annex F.5¶2 (with correctly rounded division, Annex F) |
| `remove()` on an empty directory deletes it. | POSIX/Linux |
| `fopen` of a directory for reading succeeds and the first `fgetc` fails with `EISDIR`, so `load_points` reports `PARSE_IO_ERROR`. | glibc/Linux (observed by the fixture test under `__linux__`) |
| `sizeof(GeoPoint)` is 24. | observed on this machine (and prescribed by the System V ABI; not C11) |
| The bytes of the generated file for (seed 1, 1,000 rows) have SHA-256 `3b13098d…145da`. | oracle (fixed by the specification, independent of platform) |
| `-O2 -ffast-math` changes the Neumaier sum of `cancel` from 2 to 1. | observed on this machine (GCC 11.4 and Clang 14) |

The categories are not interchangeable: a C11 statement holds on every conforming implementation; an Annex F statement holds only where `__STDC_IEC_559__` is defined; POSIX/Linux and glibc statements hold on those systems and can change with a version; an oracle statement is a consequence of a specification that this course wrote; an observation is one build on one machine and must never be cited as a guarantee.

### R04

Measured on the reference build (GCC 11.4 and Clang 14, glibc 2.35, `-O0` and `-O2` identical; the tolerance is the value in [tests/tolerances.h](../tests/tolerances.h)).

| Quantity | Measured | Tolerance | Reasoning |
| --- | --- | --- | --- |
| E07 `tenths`, naive vs exact | +1.333·10⁻⁶ abs (1.33·10⁻¹¹ rel, 91,595 ulps) | bound `γ_{n−1} Σ|xᵢ|` = 1.11·10⁻⁵ | Derived worst case (A); the measurement is 12% of it. |
| E07 `tenths`, pairwise | 0 | bound `γ₂₄ Σ|xᵢ|` = 2.66·10⁻¹⁰ | Derived (A), depth 17 plus 7 in-block additions. |
| E07 `tenths`, Neumaier | 0 | ≤ 2 ulps; bound `2u|s| + γ²Σ|x|` = 2.2·10⁻¹¹ | Derived (A) from Ogita–Rump–Oishi. |
| E07 `hashed`: naive / pairwise / Neumaier | 1 / 1 / 0 ulps (1.5·10⁻⁵ abs for the first two) | same bounds; naive bound 7.93, pairwise 1.9·10⁻⁴ | Measured errors are far below the bounds because rounding errors cancel. |
| E07 `cancel` | naive 1 (error 1), pairwise 1, Neumaier 0 | Neumaier exactly 2 (all four orderings) | Σ|x|/|s| = 10¹⁶, so plain sums may lose everything; the compensated sum is exact here. |
| E07 grid, explicit vs exact `i/10` | 1.480·10⁻¹⁶ (1.33 u) | ≤ 1.5 u (1 + 2⁻⁵²) = 1.665·10⁻¹⁶ | Derived (A): δ₀ = 2⁻⁵⁴ plus one rounding. |
| E07 grid, accumulated vs exact | 1.333·10⁻¹¹ (120,055 u) | ≤ (i + 1) u | Derived upper bound (A); reported, not asserted to exceed the explicit error. |
| E06 per-point distance, haversine vs reference | ≤ 3.3·10⁻⁹ km (worst: the pole seen from (−89.98°, 21.24°), nearly antipodal) | — (not asserted per point) | Haversine conditioning near antipodes (week 3); a `long double` truth shows the reference is accurate to 5.5·10⁻¹² km. |
| E06 `sum_km` vs reference sum, 4 centers × 10⁴ points | ≤ 3.1·10⁻¹⁵ relative | 2·10⁻¹² | `(n−1)u` = 1.11·10⁻¹² (A) plus per-point disagreement ≤ 3.3·10⁻¹³ (B); measured is 0.28% of the accumulation bound. |
| E06 `min_km` / `max_km` vs reference | ≤ 8.1·10⁻¹³ / 1.3·10⁻¹⁴ relative | 10⁻¹¹ relative, floor 10⁻⁹ km | (B): 12× the largest measurement. |
| E06 built-in dataset, per equator point | ≤ 10⁻¹² relative to the analytic value | 10⁻¹² relative | (B), as in week 3. |

**Conclusion (cautious).** On these inputs the compensated sum was never worse than the others and the naive sum was worst on `tenths` and `cancel`, while on `hashed` all three were within an ulp; that says nothing about other data. No claim is made about speed. The E06 differential shows the haversine and the reference agreeing far inside the tolerances, with the largest disagreement explained by conditioning rather than by a defect — which is exactly what a differential test cannot certify: both implementations share the sphere model and the constant R.

### R05

**Submission inventory:** `ex01.c`–`ex07.c` with their helpers copied as needed; the Makefile and flags; test logs for GCC and Clang at `-O0`, `-O2` and the sanitizer configuration; this notebook; P01–P06 answers; optional S01 (`stretch_layout.c`) and S02 (`repro_audit.py`) results. **Durable connection (source → mechanism → observation):** *a Handmade Hero blackboard about `position += step` (source) → each addition rounds and the errors of repeated additions accumulate, whereas a value computed from its index has a bounded error (mechanism) → 1.33·10⁻¹¹ versus 1.48·10⁻¹⁶ relative error over a million grid points, and a compensated sum that recovers what a plain sum loses (observation).* The same connection holds in any language with IEEE doubles: audio sample positions, animation time, simulation clocks. **Unresolved question for week 5:** what would have to be controlled to time the processor fairly — the file (page cache warm or cold, which the first read of `load_points` touches), the compiler flags and vectorization (the summation loop is a dependency chain, so its cost is latency, not throughput), the clock (`clock_gettime` resolution and monotonicity), warm-up and repetitions, and whether `sqrt`/`sin`/`asin` from libm dominate. **Time spent:** the core target is the unpiloted 600 minutes; this exemplar was produced by an automated agent, so no human completion time is claimed. A learner records actual minutes per section here.

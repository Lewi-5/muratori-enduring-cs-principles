# Completed exemplar — geospatial math library notebook

The predictions in this document are **illustrative prior hypotheses**, not a claim that an automated agent performed a human learner's before/after exercise. The sample observations were taken from the actual reference build recorded in [validation.md](validation.md). Different valid observations are accepted. Full E01.C–E07.C, E01.Q–E07.Q, P01–P06 and S01–S02 responses are in [answers.md](answers.md); this notebook integrates them rather than replacing them with an output table.

### R01

Example environment: 2026-09-20, x86-64 Ubuntu 22.04 under WSL2, Linux kernel 6.18.33.2-microsoft-standard-WSL2. Compilers: GCC 11.4.0-1ubuntu1~22.04.3 and Clang 14.0.0-1ubuntu1.1. glibc 2.35 (Ubuntu 2.35-0ubuntu3.15) supplies `libm`. GNU binutils 2.38 supplies `nm`. Versions were read from each tool's `--version` output and `ldd --version`.

Commands: `make PACKAGE=instructor CC=gcc test`, the Clang equivalent, each again with `MODE=optimized`, and `make verify` for the whole matrix including AddressSanitizer/UndefinedBehaviorSanitizer and scaffold checks. Flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off` with `-O0`, or `-O2`; the sanitize mode uses `-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie` and links `-no-pie`. Every link adds `-lm`. **None of `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` or `-march=native` appears in any command**; the test driver asserts this and refuses to run if any of them, `-fassociative-math`, `-ffp-contract=fast` or `-mfma` is present. `-ffp-contract=off` is set explicitly because Clang defaults to `on` in C, which lets the compiler fuse a multiply and an add into one rounding (§F.7). There is no benchmark, timing comparison or background-load assertion this week.

### R02

Illustrative predictions are retained alongside observations. A learner would record their own predictions before reading the outputs; the numeric ones for E02, E03 and E05 are shown here in full.

| Exercise | Illustrative prediction (before running) | Reference/sample observation | Source → mechanism → explanation |
| --- | --- | --- | --- |
| E01 | `1.0` has exponent 1023 (bias); `0.5` 1022; `-2.0` sign 1 exponent 1024; `0.1` exponent 1019 and a repeating `9…9A` fraction. | Exactly those; `0.1` fraction `0x999999999999A`; `DBL_TRUE_MIN` exponent 0 fraction 1; NaN exponent 2047 (payload `0x8000000000000` here, not asserted). | `memcpy` exposes the object bytes; the fields follow from the IEC 60559 layout; the fraction of 0.1 rounds up because the discarded bits `1001…` exceed half a unit. |
| E02 | `0.1 + 0.2` is 1 ulp above `0.3`; `(0.1+0.2)+0.3` and `0.1+(0.2+0.3)` also 1 ulp apart. | left 0.60000000000000009, right 0.59999999999999998, 1 ulp; sum 0.30000000000000004, target 0.29999999999999999, 1 ulp. | The exact sum is an exact tie between two doubles; round-half-even picks the upper. Grouping changes intermediate roundings. |
| E03 | `sin(GEO_PI)` is small and positive, about 1.2e−16, because `GEO_PI` is below π by about 1.2e−16. | `1.2246467991473532e-16`; `sin_deg(180)` prints `0`; `wrap(180)=-180`. | π − `GEO_PI` = 1.2246467991473531772e−16 from 60-digit arithmetic; `sin(π − ε) ≈ ε`. `sin_deg` reduces exactly instead of converting 180° to radians. |
| E04 | Axis and pole vectors are exact; `(45,45)` is (0.5, 0.5, 0.7071…). | Same; pole vectors have `x = y = 0` printed as `0`, not `-0`. | Exact-quadrant `sin_deg`/`cos_deg`, and a helper that turns `-0.0` into `+0.0`. |
| E05 | Haversine and the vector formula agree to about 1e−15 relative; the law of cosines is worst on `identical` and on `one_metre_equator`, off by about 1e−4 km and by several parts in 1e4 respectively (a rounding of 1e−16 in `cos c` becomes about √(2·1e−16) ≈ 1.5e−8 rad ≈ 9.5e−5 km near zero). | Haversine and vector within 4.3e−15 relative; cosines 9.49e−5 km on `identical` and relative error 6.8e−4 on `one_metre_equator`. | `acos` has derivative 1/sin c, about 1/c for small c, so a fixed rounding in its argument is magnified by 1/c. Haversine (`asin` near 0) and `atan2` are well conditioned there. |
| E06 | Twelve driver cases classify as listed; the non-integer crossing is `(1.5, 0.5)`. | Matches; independent integer oracle agrees on all 6,561 pairs (all three kinds occur). | Orientation cross products are exact integers below 2^53 on the domain; the parallel branch precedes any division. |
| E07 | Every case reports `ok=1`; the plain-libm pole case will show a tiny nonzero error. | All seven `ok=1`; `pole_all_longitudes` abs error 6.8e−13 km; 16 global symbols. | The library is a header-defined interface; `static` hides helpers; `cos(deg_to_rad(90))` is 6.1e−17, not 0. |

Illustrative first-draft mistakes, kept visible: I first predicted the law of cosines would be off by about 1e−9 km on `identical` (mixing up radians and kilometres); the observation 9.49e−5 km, and the rule error ≈ ε/c times R, corrected the prediction. I also predicted `sin_deg(180)` would print `-0`; the printed `0` follows from the zero-normalizing helper, and the bad prediction is preserved rather than edited.

### R03

Implementation-dependent observation one: `sin(GEO_PI)` printed `1.2246467991473532e-16` under glibc 2.35. The portable relationship the tests use instead is `0 < sin(GEO_PI) < 1e-15` (gated), never a digit string, and E03's real exactness claim is about `sin_deg`, which does not depend on libm's last digit. Observation two: the NaN produced by `NAN` had fraction `0x8000000000000`; the tests assert only that it is a NaN with exponent 2047, and that decompose-then-compose reproduces the bytes. Observation three: the law of cosines error on `identical` is nonzero at latitude 40 and exactly 0 at 12.5 (the rounding depends on the data); tests assert only that it is finite and nonnegative.

| Claim | Category | Limit |
| --- | --- | --- |
| `fmod` returns an exact result. | C11 Annex F §F.10.7.1 ¶2 (checked in the N1570 text); the `fmod(3)` manual page does not state it. | Needs subnormal support; the definition is `x − ny` (§7.12.10.1). |
| `0.1 + 0.2 != 0.3` under binary64. | Annex F / IEC 60559, verified by exact decimal arithmetic. | C11 alone does not pin the format or the constant's rounding (§6.4.4.2 ¶3). |
| A decimal constant like `0.1` may be any of the two nearest doubles in C11 alone. | C11 §6.4.4.2 ¶3 | Annex F §F.5 makes it correctly rounded when IEC 60559 is supported. |
| `sin(GEO_PI)` printed 1.2246467991473532e−16. | glibc/libm observation | Other libm versions may differ in the last digits; the sign and magnitude follow from `GEO_PI < π`. |
| Fused multiply-add can change a result. | Compiler behavior permitted by `FP_CONTRACT` and §F.7; controlled here by `-ffp-contract=off`. | GCC in ISO mode already defaults to off; Clang defaults to on. |
| The four builds gave bit-identical outputs. | Observed on this machine | No claim about other CPUs; some glibc builds pick FMA variants of `sin` at run time. |
| `nm` lists 16 global names for `geomath.o`. | Toolchain (binutils) observation | Symbol names and letters are not part of C. |

### R04

Error table. All values measured on this build (GCC 11.4, glibc 2.35, x86-64), from [extras/measure.c](extras/measure.c); absolute error in km, relative error in parentheses where the expected value is nonzero.

| Case | Haversine | Vector | Law of cosines |
| --- | --- | --- | --- |
| identical (40, 33.25) | 0 | 0 | 9.49e−5 |
| one_metre_equator | 2.2e−19 (1.95e−16) | 2.2e−19 (1.95e−16) | 7.6e−7 (6.8e−4) |
| one_km_meridian | 0 | 0 | 1.0e−9 (1.0e−9) |
| quarter_meridian | 1.8e−12 (1.8e−16) | 0 | 0 |
| half_circle | 0 | 0 | 0 |
| antimeridian_pair | 3.1e−13 (2.8e−15) | 4.8e−13 (4.3e−15) | 1.1e−11 (1.0e−13) |

For E02, the two sums are each exactly one ulp from their targets (0.1 + 0.2 versus 0.3: absolute difference 5.55e−17). Tolerance chosen: relative 1e−12 with an absolute floor of 1e−9 km. Reasoning: the largest measured relative error of the two well-conditioned formulas is 4.3e−15, so 1e−12 gives a 230× margin and is still tight enough that a formula error of a part per trillion would be detected; the absolute floor covers `identical`, where the expected value is 0 and relative error is undefined. The law of cosines is not held to the tolerance because its error is data-dependent and ill-conditioned by construction; it is only required to be finite and nonnegative. A cautious conclusion: on these six cases haversine and the vector formula were equally accurate to within a few 1e−15; neither is “best”, and the S02 sweep shows they trade places: the vector formulation was better near antipodes, where the haversine error grew as (4/δ)·(a rounding in `s`) and then collapsed to exactly π, while for points one ulp apart the haversine path was exact and the vector path was off by 10.5 %.

### R05

Submission inventory: seven exercises in nine C files (E01–E06 as `ex01.c`–`ex06.c`, and E07's `geomath.h`, `geomath.c`, `geomath_demo.c`), `support/geo_consts.h`, `support/platform.h`, the Makefile, test output and this notebook. Instructor extras add `measure.c`, `stretch_edges.c` and `stretch_antipodal.c`. Full numbered explanation, practice and stretch answers are in answers.md.

A durable defense is E03's `wrap_lon_deg`: the source calls `fmod` and applies at most one correction; the mechanism is that `fmod` is exact under Annex F with subnormal support (§F.10.7.1) and the correction subtracts two numbers within a factor of two of each other, so Sterbenz's lemma makes it exact. The historical observation was that eleven huge integer-valued inputs matched an independent modular-arithmetic oracle and that the naive `floor` formula returned −180.00000000000003 for `nextafter(180, 0)`. The current suite adds `±2^60` to make thirteen; these sampled checks illustrate rather than prove the general guarantee. In another language the syntax changes but the discipline (know which operations are exact, and prove the one that is not obvious) does not.

An appropriate next question for week 4: six-decimal text coordinates carry up to 0.0556 m of rounding per axis, roughly 1.8e7 times the double spacing near 180°; when thousands of distances are summed, does the sum's error track the text rounding (systematic or random?) or the arithmetic rounding, and which tolerance applies to which comparison? The revised 600-minute core estimate assigns 110 to reading, 20 setup, 155 to E01–E04 including the basis example, 135 to E05–E07 using the supplied E06 oracle, 75 to report and explanations, 55 to practice/checks, and 50 to debugging. This is **not measured human completion data**. An experienced C programmer should attempt the learner package without answers, logging time and help points by exercise before the budget is accepted. Optional stretch time is separate.

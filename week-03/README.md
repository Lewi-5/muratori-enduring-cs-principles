# Week 03 — Numbers in a box

<!-- companion-navigation -->
**[Read the full Week 3 companion chapter](../docs/content/weeks/week-03.md).** Understand why finite representations change numerical reasoning. The companion builds from floating-point fields to tolerances, geometry, and a reusable math interface.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Build a **geospatial math library notebook**: seven C exercises that end in one small library (`geomath.h`, `geomath.c`), a report of predicted versus measured error, and worked answers. A `double` is not a real number: it is one of finitely many binary fractions, and every operation rounds. You take a `double` apart into its sign, exponent and fraction; learn to compare and measure error honestly; wrap longitudes with the antimeridian policy stated; convert latitude/longitude to a unit vector; compute great-circle distance three ways and find out which is ill-conditioned; and classify segment intersections with exact predicates on a stated domain. This week makes **no performance claim**.

Prerequisites are [week two](../week-02/README.md) and [week one](../week-01/README.md): checked arithmetic and explicit error returns, separate translation units, internal versus external linkage, and reading object bytes. Week 1's E01 (range versus representation) and E07 (finite, in-range `GeoPoint`) and week 2's E01 (object bytes) are assumed; week 2's open question, “what do the bytes of a `double` show?”, is E01 here. The [course syllabus](../PLAN.md) provides the sequence; [solPlan.md](../solPlan.md) explains the educational purpose. The [week-three specification](PLAN.md) records all requirements, including the corrections found while implementing it.

## Working through the package

Use x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils. From `week-03`:

```sh
make                              # warning-clean learner scaffolds
make test                         # fails until you implement the TODO functions
make CC=clang test
make MODE=optimized test
make symbols                      # nm for geomath objects (E07)
```

Read [the exercise contracts](learner/exercises.md), work in [learner/src](learner/src), and complete [the notebook template](learner/observations.md). [Practice and stretch work](learner/practice.md) extends the reasoning; [the rubric](rubric.md) explains assessment. E01–E06 are standalone `exNN.c` files with supplied drivers; **record your numeric predictions for E02, E03 and E05 before you run the drivers**. In E04 and E05 you copy the earlier helpers you wrote into the file (there is no shared learner library; the copies are kept non-static so an unused copy does not break `-Werror`). E07 assembles the pieces into three files compiled as separate translation units. The default build never compiles the instructor solutions.

Reference flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off`, at `-O0` (debug) or `-O2` (optimized), linking `-lm`. **`-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` and `-march=native` are forbidden** and the test driver refuses to run with them, because they permit reassociation and fused multiply-add and would change the numbers under study. `-ffp-contract=off` is explicit because Clang's default lets it fuse a multiply and an add; GCC's ISO-mode default is off (both checked on the reference toolchain; see the validation record). Debug, optimized and sanitizer builds have separate directories for each compiler and package. Run `make clean` after changing a compiler installation or overriding flags within the same mode.

Tests use analytic values, exactly representable inputs, ulp distances and the tolerances in [tests/tolerances.h](tests/tolerances.h), each justified in the [validation record](instructor/validation.md) by a derivation or a recorded measurement. **No test asserts a nontrivial transcendental `libm` approximation bit-for-bit; exact special values remain checked.** Exact expectations apply to selected mathematically representable results, integer predicates on the stated domain, and byte decomposition. Under Annex F, `sqrt(4)` is exact while `sqrt(2)` is correctly rounded but inexact; a correct rounding guarantee is different from mathematical exactness. The reference-platform checks (E01's decomposition, E02's IEC 60559 relationships) are gated on `__STDC_IEC_559__` with 64-bit `double` and report “skipped” elsewhere; a forced-skip build (`-DGEO_FORCE_NO_IEC`) tests the gating path, not another ABI.

## Readings and workload

Links and Handmade Hero indexed boundaries checked 2026-09-20. CE is subscription material; all authored exercises and solutions here are original.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [CE: The Haversine Distance Problem](https://www.computerenhance.com/p/the-haversine-distance-problem) | Full, 30:28, duration from the [official TOC](https://www.computerenhance.com/p/table-of-contents) | The problem the whole year returns to: what is computed, over what inputs, with which formula. The paid episode has its own constants and data; this week uses its own. |
| [HH047: Vector Lengths](https://guide.handmadehero.org/code/day047/) | 10:33–20:10 and 1:10:42–1:12:54 | Length, normalization and the zero-length case; direction versus magnitude. |
| [HH048: Line Segment Intersection Collisions](https://guide.handmadehero.org/code/day048/) | 6:56–14:20 and 23:08–29:15 | Parametric intersection, the divide-by-zero (parallel) case, and a floating-point failure in geometry code. |
| [HH090: Bases Part I](https://guide.handmadehero.org/code/day090/) | 31:05–39:12 and 47:14–57:29; optional 39:12–47:14 | Coordinate bases and the dot product as measurement. |
| [HH091: Bases Part II](https://guide.handmadehero.org/code/day091/) | 6:16–16:03; optional 0:54–6:16 and 20:20–31:09 | Origins and basis vectors described in terms of others. |
| [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | §5.2.4.2.2, 6.3.1.4–6.3.1.5, 7.12 (`fmod`, `hypot`, `atan2`, `asin`), Annex F (**§F.10.7.1 for `fmod` exactness**) | Language authority, distinct from what IEC 60559 hardware and glibc do. |
| [Goldberg, What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html) | Rounding error, relative error versus ulps, guard digits | Vocabulary for error measurement; read for method, not theorems. |
| [fmod(3)](https://man7.org/linux/man-pages/man3/fmod.3.html), [math_error(7)](https://man7.org/linux/man-pages/man7/math_error.7.html) | The definition of the result; how math functions report errors | Linux facts outside ISO C. **`fmod(3)` does not state that the result is exact**; that guarantee is in C11 Annex F. This course checks arguments itself and never relies on `errno`. |

Required video time is about 84 minutes (30:28 + 11:49 + 13:31 + 18:22 + 9:47), plus about 26 minutes of focused reference consultation. The revised **core target is ten hours for experienced C programmers** using the scaffolds: readings 110 minutes, setup 20, E01–E04 155 (30, 30, 35, 60; E04 includes the basis example), E05–E07 135 (65, 40, 30; E06 uses the supplied oracle), report and written explanations 75, practice and checks 55, debugging 50. The E05 driver is the playground and is included in E05's time. Optional segments add about 24 minutes; stretch work is additional. This estimate has not been learner-piloted and may still be too dense. An experienced C programmer should attempt the learner package without the answer key, log reading, implementation, tests and explanation time by exercise, and record points requiring help; revise the budget from that pilot. If it overruns, review reducing the E05 lattice and report breadth while retaining all core correctness and reasoning. Record overruns rather than omitting requirements to fit a claimed time.

## Instructor entry

[Instructor materials](instructor/README.md) contain spoilers: annotated C, complete written answers, a worked report, optional solutions and a 27-prompt checklist. `make verify` runs six reference configurations (both compilers, debug/optimized/sanitized), the forced-skip gates, a measurement program that checks every tolerance, and then compiles all learner scaffolds. The [validation record](instructor/validation.md) distinguishes actual execution evidence from illustrative notebook predictions.

# Week 04 — Deterministic data and a reference processor

<!-- companion-navigation -->
**[Read the full Week 4 companion chapter](../docs/content/weeks/week-04.md).** Establish reproducible input and trustworthy results before timing them. The companion explains deterministic generation, strict parsing, ownership, and accumulation.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Build a **`geolab` data-pipeline notebook**: seven C exercises that write a dataset as a pure function of `(seed, count)`, format and parse it as exact fixed-point text, load it with bounded, leak-free reads, run a scalar reference processor over it, and study how the order and method of summation change a result. Three ideas run through the week. *Determinism* is engineered: integer arithmetic with defined wraparound, text formatted from integers, and a fixed order of draws make the bytes identical under every compiler and optimization level. *Parsing* is a contract: a canonical grammar, explicit error classes, bounded reads and an exact conversion from text to `double`. A *reference implementation* is the simple version that faster versions must later agree with; it earns that role by being written by a different method and checked against an independent oracle. This week makes **no timing and no speed claim**.

Prerequisites are [week three](../week-03/README.md), [week two](../week-02/README.md) and [week one](../week-01/README.md): checked arithmetic, stdio error handling, allocation with ownership, `struct` layout, and floating-point error measurement. Week 1's E12 (file reading), E11 (allocation) and E13 (checked parsing) and week 3's E05 (distance formulas) are assumed; week 3's closing question, “how do six-decimal text coordinates and the accumulation of many distances affect a result?”, is what this week answers. The [course syllabus](../PLAN.md) provides the sequence; [solPlan.md](../solPlan.md) explains the educational purpose. The [week-four specification](PLAN.md) records all requirements, including the corrections found while implementing it.

## Working through the package

Use x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils. From `week-04`:

```sh
make                              # warning-clean learner scaffolds
make test                         # fails until you implement the TODO functions
make CC=clang test
make MODE=optimized test
```

Read [the exercise contracts](learner/exercises.md), work in [learner/src](learner/src), and complete [the notebook template](learner/observations.md). [Practice and stretch work](learner/practice.md) extends the reasoning; [the rubric](rubric.md) explains assessment. Each `exNN.c` is standalone with a supplied driver; **record your E03 size prediction and your E04 status predictions before you run the drivers**. Later exercises copy the helpers you wrote earlier into their own file (there is no shared learner library; the copies are non-static so an unused copy does not break `-Werror`). The default build never compiles the instructor solutions. The public fixtures in [fixtures](fixtures) are stored byte-exact (`fixtures/*.csv -text` in `.gitattributes`); do not open and re-save them in an editor.

Reference flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off`, at `-O0` (debug) or `-O2` (optimized), linking `-lm`. **`-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` and `-march=native` are forbidden** and the test driver refuses to run with them: E07 studies arithmetic that reassociation and fused multiply-add would change. Debug, optimized and sanitizer builds have separate directories for each compiler and package. Run `make clean` after changing a compiler installation or overriding flags within the same mode.

**The oracle.** [tests/oracle.py](tests/oracle.py) re-implements the LCG, the record formatter, the canonical grammar and exact summation (`math.fsum`) with Python integers and floats, independently of both the learner and the reference code; it is itself checked against fixed known-answer vectors that were computed a second way (with `bc`). The expected file bytes and SHA-256 digests come from it. This is the one place where fixed expected outputs are legitimate: the format is fully specified and platform-independent. Layout, addresses and libm digits remain off limits, and no test asserts a `libm` result bit-for-bit. Tolerances live in [tests/tolerances.h](tests/tolerances.h) and are justified in the [validation record](instructor/validation.md). Claims that depend on Annex F conversions or on the x86-64 layout of `GeoPoint` are gated on `__STDC_IEC_559__` with a 64-bit `double`; a forced-skip build (`-DGEO_FORCE_NO_IEC`) tests the gating path, not another ABI.

## Readings and workload

Links and Handmade Hero indexed boundaries checked 2026-09-20. CE is subscription material; all authored exercises and solutions here are original, and the paid episodes' JSON format and generator are not reproduced.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [CE: “Clean” Code, Horrible Performance](https://www.computerenhance.com/p/clean-code-horrible-performance) | Full episode, 22:40, duration from the [official TOC](https://www.computerenhance.com/p/table-of-contents) | Motivation for asking how structure and representation affect cost. Its measured multipliers come from one program on one machine; no timing is done this week. |
| [CE: Generating Haversine Input JSON](https://www.computerenhance.com/p/generating-haversine-input-json) and [Writing a Simple Haversine Distance Processor](https://www.computerenhance.com/p/writing-a-simple-haversine-distance) | Full episodes, 15:40 and 12:09; optional [Initial Haversine Processor Code Review](https://www.computerenhance.com/p/initial-haversine-processor-code), 29:22, after E06 | The shape of the task: produce a dataset, process it, keep a reference answer. Our format and generator differ; nothing here reproduces theirs. |
| [HH146: Accumulation vs. Explicit Calculation](https://guide.handmadehero.org/code/day146/) | 42:07–56:04 | Why repeatedly adding a step drifts and computing each value from its index does not. The audio context is incidental. |
| [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | §6.2.5 (unsigned wraparound), 7.20.1.1 and 7.20.2 (exact-width types and limits), 7.21 (`fopen`, `fgetc`, `fputs`, `fclose`, `remove`, `ferror`), 7.22.3 (`malloc`, `realloc`, `free`), 7.4 (`isdigit`), 7.11 (locales), **Annex F.5 “Binary-decimal conversion” ¶2** | Primary authority for language and library claims. |
| [malloc(3)](https://man7.org/linux/man-pages/man3/malloc.3.html) | `realloc` and `free` | The library contract, including what happens to the original block when `realloc` fails. |
| [Linear congruential generator](https://en.wikipedia.org/wiki/Linear_congruential_generator) | Period and low-order bits; treat the parameter table as a survey | Secondary source for the weakness of low bits. The course's constants are fixed by the plan and checked against the Hull–Dobell conditions. |
| [Goldberg, What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html) | The “Rounding Error” material and the section “Errors In Summation” (including its Theorem 8 on Kahan's summation formula) | Vocabulary and bounds for summation error, revisited from week 3. |

Required video time is about 64 minutes (22:40 + 15:40 + 12:09 + 13:57), plus about 36 minutes of focused reference consultation, for about **100 minutes**. The revised **core target is ten hours for experienced C programmers** using the scaffolds: readings 100 minutes, setup 20, E01–E04 155 (25, 35, 45, 50), E05–E07 140 (55, 50, 35), report 70, practice and checks 60, debugging 55. The E02/E04 drivers are the playground and are included in those times. The optional code review adds about 29 minutes; stretch work is additional. This estimate has not been learner-piloted. An experienced C programmer should attempt the learner package without the answer key, log reading, implementation, testing and explanation time by exercise, and record points requiring help. Revise the budget from that pilot; record overruns rather than omitting correctness or explanations to fit a claimed time.

## Instructor entry

[Instructor materials](instructor/README.md) contain spoilers: annotated C, complete written answers, a worked report, optional solutions and a 27-prompt checklist. `make verify` runs six reference configurations (both compilers, debug/optimized/sanitized), the forced-skip gates, a measurement program that records every number the answer key quotes, the reproducibility audit, and then compiles all learner scaffolds. The [validation record](instructor/validation.md) distinguishes actual execution evidence from illustrative notebook predictions.

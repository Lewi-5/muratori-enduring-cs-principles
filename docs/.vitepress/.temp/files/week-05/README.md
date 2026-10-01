# Week 05 — Project 1: a validated scalar `geolab` baseline

<!-- companion-navigation -->
**[Read the full Week 5 companion chapter](../docs/content/weeks/week-05.md).** Turn the earlier mechanisms into a correct baseline and a defensible measurement experiment. The companion explains the checkpoint, protocol, fixtures, and interpretation of uncertainty.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Build the first **section project**: one `geolab` program, assembled from several translation units, with three commands whose contracts are written down in [CHECKPOINT-1.md](CHECKPOINT-1.md):

- `generate` writes week 4's dataset, byte for byte.
- `query` selects the points within a radius and prints them in a deterministic order.
- `bench` times one of three operations under a stated protocol.

The new idea is **measurement as an experiment**. A timing is an observation of one build of one program on one machine. It becomes evidence only when four things hold: the result was checked correct first, the conditions were recorded, the prediction was written down before running, and the variation was measured rather than assumed away. The week records a **scalar baseline** that later weeks compare against. It includes the `VEC=off` build that the vectorization path starts from in week 31. **There is no speedup threshold**, and a faster number is never, by itself, a better grade.

Prerequisites are [week four](../week-04/README.md) (the generator, the strict parser and loader, the scalar processor) and [week three](../week-03/README.md) (the validated haversine). Earlier weeks supply separate translation units and linkage, checked arithmetic and floating-point error measurement. Week 4's closing question, “what would have to be controlled to time the processor fairly?”, is what this week answers. The [course syllabus](../PLAN.md) gives the sequence, and the [week-five specification](PLAN.md) records every requirement, including the corrections found while implementing it.

## Working through the package

Use x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils. From `week-05`:

```sh
make                              # the learner project, warning-clean
make test                         # fails until you implement the TODO functions
make CC=clang MODE=optimized test
make symbols                      # external symbols of each object (E01)
make expected                     # fixtures/expected from the supplied oracle (E03)
make bench-bins                   # the VEC=off and VEC=default executables, at distinct paths
make bench-data                   # the protocol in PROTOCOL.md -> results/ (E05, E06)
make checkpoint                   # the release gates (E07)
```

Read [the milestone contracts](learner/exercises.md) and work in [learner/geolab](learner/geolab). Write [the protocol](learner/PROTOCOL.md) and [the report](learner/report.md). [Practice and stretch work](learner/practice.md) extends the reasoning, and [the rubric](rubric.md) explains assessment. The headers in `geolab/include`, `main.c`, the option scanner in `cli.c` and the output plumbing of `cmd_bench` are supplied. The mechanisms are yours: the command-line number parser, the query, the order statistics and the measurement kernel. Copy your week-3 and week-4 code into `geo.c` and `csv.c`, keeping every helper `static`. **Record your E06 predictions before you run `make bench-data`.**

Supplied support: [support/monotonic.h](support/monotonic.h) reads `CLOCK_MONOTONIC` in nanoseconds, with checked conversion. [support/envinfo.c](support/envinfo.c) prints the environment block that starts every `bench` output. [tests/oracle.py](tests/oracle.py) is an **independent oracle**: it re-implements the generator, the CSV grammar, the command-line number grammar with exact rationals, and the query with a *different* distance formula. The tests compare against it using the tolerance rule in [tests/fixture_lib.py](tests/fixture_lib.py). You explain the oracle; you do not write another one.

Reference flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L`, at `-O0`, `-O2`, and with sanitizers. `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` and `-march=native` are forbidden, and the test driver refuses them. **No test asserts a timing.** Timings belong in the report, labelled with the machine, build and date.

## Readings and workload

Links and Handmade Hero indexed segments were checked on 2026-09-22. CE is subscription material; all authored exercises and solutions here are original.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [CE: Single Instruction, Multiple Data](https://www.computerenhance.com/p/single-instruction-multiple-data) | Full episode, 35:31, duration from the [official TOC](https://www.computerenhance.com/p/table-of-contents) | How much work one instruction can do; why a scalar baseline is recorded now. No SIMD this week. |
| [CE: Caching](https://www.computerenhance.com/p/caching) | Full episode, 22:55 | Why the same arithmetic can cost different amounts depending on where data lives. A question to ask; week 22 measures it. |
| [CE: Python Revisited](https://www.computerenhance.com/p/python-revisited) | Full episode, 36:22 | The cost of layers between source and machine. The course authors no Python comparison code. |
| [HH010: QueryPerformanceCounter and RDTSC](https://guide.handmadehero.org/code/day010/) | 3:49–15:30; optional 21:48–38:10 | Cycle counts versus wall-clock time. This course uses POSIX `clock_gettime`. |
| [HH112: A Mental Model of CPU Performance](https://guide.handmadehero.org/code/day112/) | 17:54–31:38 and 39:41–48:33; optional 48:33–51:01 | A budget in cycles; latency versus throughput. |
| [HH113: Simple Performance Counters](https://guide.handmadehero.org/code/day113/) | 48:58–1:00:48; optional 2:04–8:45 | A ballpark estimate before measuring. |
| [clock_gettime(2)](https://man7.org/linux/man-pages/man2/clock_gettime.2.html) | `CLOCK_MONOTONIC`, `CLOCK_PROCESS_CPUTIME_ID`, `CLOCK_REALTIME`, `clock_getres` | The clock contract: POSIX/Linux, not ISO C. |
| [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | §7.22.5 and 7.22.5.2 (`qsort`), §7.11.1.1 ¶4 (the `"C"` locale at startup), §7.21.6.1 (`fprintf`), §7.27.2.1 (`clock`), Annex F.5 ¶2 | Primary authority for ordering, formatting and time. |

Required viewing is about 141 minutes, plus about 19 minutes of reference consultation, for about **160 minutes**. The **core target is ten hours** for experienced C programmers using the scaffold and the supplied oracle:

| Activity | Minutes |
| --- | ---: |
| Readings | 160 |
| Setup | 15 |
| E01–E07 (35, 55, 35, 55, 40, 40, 25) | 285 |
| Report | 55 |
| Practice | 30 |
| Debugging | 55 |

The E06 timing runs execute unattended within E06's time. Optional viewing and stretch work are additional. **This estimate has not been piloted with learners.** Record overruns rather than cutting correctness or explanations to fit it.

## Instructor entry

[Instructor materials](instructor/README.md) contain spoilers: the complete reference project, the written answer key, an exemplar protocol and report built from real recorded runs, the S01/S02 programs, and the mutation check. `make verify` runs the instructor checkpoint (five configurations plus Clang's sanitizer), the cross-build identity check, both benchmark builds for both compilers, a protocol smoke run, and the learner-scaffold check. The [validation record](instructor/validation.md) separates actual execution evidence from illustrative material.

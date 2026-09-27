# Week 02 — Objects, bytes, and storage

<!-- companion-navigation -->
**[Read the full Week 2 companion chapter](../docs/content/weeks/week-02.md).** Build a model of object layout and identity over time. The companion develops alignment, padding, lifetime, and references before walking through the inspector exercises.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Build an **object-layout inspector notebook**: ten C exercises, one integrated CLI, predictions and explanations. Draw a layout before running the program, then distinguish what C guarantees from what the ABI and compiler chose. This week observes representation and storage; it makes no speed claims.

Prerequisites are [week one](../week-01/README.md), especially E08 (padding), E09 (bytes), E11 (allocation) and E14 (linking). The [course syllabus](../PLAN.md) provides the sequence; [solPlan.md](../solPlan.md) explains the educational purpose. The corrected [week-two specification](PLAN.md) records all requirements and the review amendments.

You will learn to round offsets safely, predict and draw aggregate layout, address array elements, distinguish storage duration from placement, initialize typed objects in allocated storage, compare index and pointer references, and trace data symbols across translation units.

## Working through the package

Use x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils. From week-02:

```sh
make                              # warning-clean learner scaffolds
make test                         # fails until you implement the TODO functions
make CC=clang test
make MODE=optimized test
make symbols                      # nm for E09 objects and executable
make inspect                      # readelf, objdump and size for E09
```

Read [the exercise contracts](learner/exercises.md), work in [learner/src](learner/src), and complete [the notebook template](learner/observations.md). [Practice and stretch work](learner/practice.md) extends the reasoning; [the rubric](rubric.md) explains assessment. Use the supplied demo drivers to focus on mechanisms. E10 supplies token parsing, but its integration main and layout/map helpers remain learner work. Earlier helpers may be copied into later source files; no shared library hides them. The default build never compiles instructor solutions.

Reference flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror -O0`, with `-fno-common` to make data-definition errors visible. Optimized mode uses `-O2`. E09 compiles two `.o` files before linking. Debug, optimized and sanitizer builds have separate directories for each compiler/package. Run `make clean` after changing a compiler installation or overriding build flags within the same mode.

Language tests use relationships and synthetic arithmetic inputs, not fixed byte counts. E03/E10 explicitly label System V x86-64 Linux comparisons; E07 labels its numeric-address and 64-byte-alignment assumptions. Unsupported targets skip those observations. A forced skip build checks the gating code, not portability to every ABI. The course target provides exact-width integer types, `uintptr_t`, and 8-bit bytes; E01 explicitly skips its octet formatter on other byte widths.

## Readings and workload

Links and HH indexed boundaries checked 2026-09-20. CE is subscription material; all authored exercises and solutions here are original.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [CE: Instructions Per Clock](https://www.computerenhance.com/p/instructions-per-clock) | Full, 25:05, duration verified in the [official TOC](https://www.computerenhance.com/p/table-of-contents) | Motivation: layout facts alone do not determine execution speed |
| [HH014: Platform-independent Game Memory](https://guide.handmadehero.org/code/day014/) | 15:03–37:27; optional 0:58–15:03 | A platform-supplied block partitioned into state; adapt Windows/C++ examples to C11 allocation rules |
| [HH064: Mapping Entity Indexes to Pointers](https://guide.handmadehero.org/code/day064/) | 11:31–17:52 and 28:27–39:24; optional 22:00–28:27 | References stored as indices and resolved when used |
| [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | §§6.2.2, 6.2.4, 6.2.6.1, 6.2.8, 6.3.2.3, 6.5¶6–7, 6.5.6, 6.5.9, 6.7.2.1, 6.7.5, 6.7.9; library headers §§7.15, 7.19, 7.20.1.1, 7.22.3 | Language authority: consult the relevant section per exercise |
| [System V x86-64 ABI](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf) | §3.1.2, including aggregates | Reference layout model; ABI rather than C guarantee |
| [malloc](https://man7.org/linux/man-pages/man3/malloc.3.html), [nm](https://sourceware.org/binutils/docs/binutils/nm.html), [readelf](https://sourceware.org/binutils/docs/binutils/readelf.html) | Allocation contracts and symbol/section/relocation options | Linux/toolchain context for E07/E09/S02 |

Required video time is about 65 minutes, plus 35 minutes of focused reference consultation. The revised **core target is ten hours for experienced C programmers**, using the scaffolds: readings 100 minutes, setup 20, E01–E05 150, E06–E10 200, report 70, practice/checks 60. The E03/E04 playground is included in exercise time. Optional videos add about 21 minutes; stretch work is additional. This estimate has not been learner-piloted. Record overruns rather than omitting correctness or explanations to fit a claimed time.

## Instructor entry

[Instructor materials](instructor/README.md) contain spoilers: annotated C, complete written answers, a worked report, optional solutions and a 33-prompt checklist. `make verify` runs six reference configurations (both compilers, debug/optimized/sanitized), checks the skip paths, then compiles all learner scaffolds. [Validation](instructor/validation.md) distinguishes actual execution evidence from illustrative notebook predictions.

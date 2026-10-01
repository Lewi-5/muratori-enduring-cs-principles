# Week 15 — Sorting: complexity and measured cost

[Lesson](../docs/content/weeks/week-15.md) · [Beginner section](../docs/content/beginners/week-15.md) · [Further reading](../docs/content/further-reading/week-15.md)

Implement three stable uint32_t-key sorts, prove ordered permutation and stability, count defined operations, then compare repeated measured costs on identical inputs.

Prerequisites: Week 5 correctness and measurement discipline, Week 4 deterministic unsigned data, and Week 11 compiler choices. Weeks 13 and 14 provide timing context when available; this package supplies its own checked monotonic harness. This package has no link-time dependency on an unfinished week. Use x86-64 Linux/WSL, GCC/Clang, C11, make and Python 3.10+. All substantial code is C; solutions remain separate from typed learner stubs.

## Work locally

```sh
cd week-15
make
make test
make warmups
make PACKAGE=instructor test
make verify
make PACKAGE=instructor MODE=optimized all
build/instructor/gcc/optimized/bench 1024 9
```

Default learner stubs compile warning-clean but intentionally fail correctness until implemented. make verify checks both compilers at debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer, plus negative starter gates and checked beginner examples. [lab.h](include/lab.h) defines exact domain, caller preconditions, output and error contracts. One graded submission includes E01–E05 and R01–R05. Six practice, two stretch, three warm-ups and three reading questions have complete separate answers. [Validation](instructor/validation.md) records actual checks.

## Read and watch

Direct episode URLs, durations and assigned indexed markers were checked on 2026-10-01. Required viewing: 100:13 of indexed viewing; allow up to 120 minutes with pauses. CE is subscription material; the assignments are original. The beginner path adds 2–4 hours to a 600-minute core estimate, unpiloted: viewing/reference 120, implementation 260, independent validation 100, notebook/practice 120. Optional stretch and deeper readings add time. Record actual learner workload.

- [HH231: Order Notation](https://guide.handmadehero.org/code/day231/): 2:57–23:37. Scale and asymptotic reasoning
- [HH232: Examples of Sorting Algorithms](https://guide.handmadehero.org/code/day232/): 24:17–39:53. Algorithm choice and actual input scale
- [HH233: Can We Merge Sort In Place?](https://guide.handmadehero.org/code/day233/): 3:57–16:18. Merge storage and validation
- [HH234: Implementing Radix Sort](https://guide.handmadehero.org/code/day234/): 3:55–27:34. Stable digit passes
- [CE: Repetition Testing](https://www.computerenhance.com/p/repetition-testing): Full, 27:57. Favorable repeated observations and hidden state
- [C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf): §§6.2.4, 6.5.7, 7.22.3, 7.22.5.2. Object lifetime, defined shifts, allocation and sorting contracts.
- [clock_gettime](https://man7.org/linux/man-pages/man3/clock_gettime.3.html): CLOCK_MONOTONIC and return/error contract. Primary Linux timer boundary, not an algorithm complexity rule.

## Source → mechanism → observation

A growing input exposes algorithmic work; a timer observes a particular implementation and environment. Stable digit passes allow radix sorting without key comparisons. The C contracts state what is valid and unchanged on error; the tests exercise those obligations; observations support only the recorded workload and platform. The [rubric](rubric.md) accepts other correct designs and valid different observations.

Sorting uses stable tagged records and independent ordered-permutation expectations. The uint32_t domain excludes signed/floating mappings. Sorting scratch is caller-owned and disjoint; algorithms allocate nothing. Counter instrumentation is part of the timed code. Bench copies original data outside the interval, includes the sort/counters inside, and validates/consumes outside; this is a warmed sort-only scope, excluding allocation, copy and I/O. A minimum is an observed favorable trial, not typical latency. Repeat across sizes/shapes; no crossover or speed threshold is mandatory.

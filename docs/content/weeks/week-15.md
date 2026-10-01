---
prev:
  text: Week 14 · Profiling
  link: /weeks/week-14
next:
  text: Week 16 · Object lifetimes
  link: /weeks/week-16
---

# Week 15 · Sorting: complexity and measured cost

Implement three stable uint32_t-key sorts, prove ordered permutation and stability, count defined operations, then compare repeated measured costs on identical inputs. Start with the [beginner section](/beginners/week-15) for the slower path. A growing input exposes algorithmic work; a timer observes a particular implementation and environment. Stable digit passes allow radix sorting without key comparisons.

## Bring these ideas

Week 5 correctness and measurement discipline, Week 4 deterministic unsigned data, and Week 11 compiler choices. Weeks 13 and 14 provide timing context when available; this package supplies its own checked monotonic harness. The [package guide](/materials/week-15/README) explains exact contracts, tools, workload and limitations.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-15
make
make test
```

After implementation run build/learner/gcc/debug/playground. [lab.h](/source/week-15/include/lab.h) defines obligations; [contracts](/source/week-15/tests/contracts.c) test independent evidence. Preserve predictions before opening solutions.

## Guided exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->

## Practice and stretch

<!-- practice -->

## Notebook

<!-- report -->

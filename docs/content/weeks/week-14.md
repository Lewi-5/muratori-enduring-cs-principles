---
prev:
  text: 'Week 13'
  link: '/weeks/week-13'
next:
  text: 'Week 15 · Sorting: complexity and measured cost'
  link: '/weeks/week-15'
---

# Week 14 · Nested and recursive profiling

A whole-batch duration invites attribution to smaller regions. Nested and recursive events require explicit invocation accounting, and their hooks change execution. Begin with the [beginner section](/beginners/week-14) and use the [guided reading](/further-reading/week-14) for the seven-text comparison.

## Model before measurement

The caller supplies ordered timestamps from one domain. Each begin creates its own stack frame; each end contributes one inclusive duration and its self duration. Same-ID recursion retains separate starts, then combines every invocation into the ID bucket. Failed events preserve complete state.

## What the report means

Covered time sums self over recorded roots and omits gaps. Inclusive totals overlap and can exceed covered time. Completed reports are overflow checked and require an empty active stack. The fixed example covers100 units while inclusive totals sum to140.

## Read and watch

<!-- readings -->

The five CE episodes total 106:34. Selected HH 177 and 178 segments add
7:33, for 114:07 of viewing. Use a 120-minute viewing session, with deeper
manual consultation and experiments in the implementation budget.

## Build and inspect

```sh
cd week-14
make
make test
make warmups
make inspect
python3 tools/measure.py gcc optimized learner
```

Use the [package guide](/materials/week-14/README) for the full protocol, output fields and independent instructor verification. The workload folds 512 IDs 32 times, checks 4202496 and prints outside the timed region. Keep nine baseline/instrumented pairs with alternating order,33 instrumented hits and possible negative differences. Actual compiler artifacts and raw logs belong in the notebook; the [reference report](/materials/week-14/instructor/report) is a separate exemplar.

## Guided exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->

## Practice and stretch

<!-- practice -->

## Notebook and handoff

Keep prediction, observed evidence, inference and limitation distinct. Neither instruction count nor a single duration supports a universal speed claim. Week 15 will extend measurement to throughput and repetition; the current profiler keeps its bounded serialized contract.

<!-- report -->

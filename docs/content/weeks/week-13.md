---
prev:
  text: 'Week 12'
  link: '/weeks/week-12'
next: 
  text: 'Week 14 · Nested and recursive profiling'
  link: '/weeks/week-14'
---

# Week 13 · Clocks and repeatable timing

A passing state trace establishes correctness under its contract. To compare real elapsed work, choose a clock, keep raw samples and record the workload. Begin with the [beginner section](/beginners/week-13) and use the [guided reading](/further-reading/week-13) for the seven-text comparison.

## Model before measurement

The harness accepts an injected reader and work callback. Validate normalized timespec fields, checked deltas and complete output publication independently of real clock behavior. A failed end read cannot undo completed work. Collect bounded raw samples and declare the lower-median summary policy.

## What the report means

Linux CLOCK_MONOTONIC measures elapsed time while awake; a zero interval is allowed. The optional CPUID-guarded fenced RDTSCP experiment reports ticks separately. Empirical calibration is not core frequency; AUX and capability flags are diagnostics with stated limits.

## Read and watch

<!-- readings -->

The two CE episodes total 79:48. Selected HH 010 and 113 segments add
13:39, for 93:27 of viewing. Reserve the rest of the 120-minute session for
pauses, unit checks and notes; consult manuals during the exercises.

## Build and inspect

```sh
cd week-13
make
make test
make warmups
make inspect
python3 tools/measure.py gcc optimized learner
```

Use the [package guide](/materials/week-13/README) for the full protocol, output fields and independent instructor verification. The workload folds 512 IDs 32 times, checks 4202496 and prints outside the timed region. Keep nine raw work/empty intervals and optional counter samples. Actual compiler artifacts and raw logs belong in the notebook; the [reference report](/materials/week-13/instructor/report) is a separate exemplar.

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

Keep prediction, observed evidence, inference and limitation distinct. Neither instruction count nor a single duration supports a universal speed claim. Week 14 adds nested instrumentation using this checked clock.

<!-- report -->

---
prev:
  text: Week 15 · Sorting
  link: /weeks/week-15
next: false
---

# Week 16 · Object lifetimes and allocation ownership

Trace automatic, static and allocated objects, repair returned-local and ownership mistakes, implement failure-atomic allocation operations and interpret isolated diagnostics. Start with the [beginner section](/beginners/week-16) for the slower path. A pointer value does not extend an object’s lifetime. Explicit ownership and commit-after-success rules make allocation, resizing and release obligations observable.

## Bring these ideas

Week 2 objects/storage, Week 10 lifetime versus architectural stack, and Week 11 compiler/frame observations. Week 15’s sort scratch is an optional ownership example; no unfinished package is linked. The [package guide](/materials/week-16/README) explains exact contracts, tools, workload and limitations.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-16
make
make test
```

After implementation run build/learner/gcc/debug/playground. [lab.h](/source/week-16/include/lab.h) defines obligations; [contracts](/source/week-16/tests/contracts.c) test independent evidence. Preserve predictions before opening solutions.

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

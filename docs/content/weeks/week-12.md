---
prev:
  text: 'Week 11 · ABI and x64 assembly'
  link: '/weeks/week-11'
next:
  text: 'Week 13 · Clocks and repeatable timing'
  link: '/weeks/week-13'
---

# Week 12 · Project 2: a specified simulator

Separate correct instruction functions are a starting point. A reviewable system also needs ownership, complete traces, failure semantics and evidence for the whole program. This checkpoint integrates the decoder/simulator subset from Weeks 6–10 and the real x64 comparison from Week 11. Begin with the [beginner section](/beginners/week-12) to separate a passing trace from a performance claim.

## Prepare code, then execute state

CodeImage holds borrowed immutable bytes and a boundary map prepared once. The caller keeps both alive and unchanged; modifying bytes requires new preparation. A prepared map is host validation metadata, not a guest register or prediction mechanism. The executor implements the exact prior subset with checked targets, wrapping data words and a bounded stack.

Every failed step/run preserves the complete Machine. A finite budget makes a nonterminating attempt reportable. These are explicit teaching policies, not a claim that real hardware undoes earlier instructions after a fault. The [checkpoint manifest](/materials/week-12/CHECKPOINT-2) states acceptance and submission evidence; [project.h](/source/week-12/include/project.h) defines precise ownership and output contracts.

## Publish a complete trace

TraceRecord captures pre-IP, all post CPU fields and changed data bytes in numerical order. A same-value store contributes no delta, and POP does not erase saved bytes. Validate execution and capacity before writing caller output, then replay immutable input. A capacity error reports required records without leaking state or a partial trace.

The original main program loops through a near call, saved AX and byte memory increment. Predict its 25 instructions before comparing the full golden. Two more goldens cover wrapping words and original PUSH SP. Hand-derived values and a separate mathematical trace oracle supplement the pinned predecessor comparison.

## Compare the right contracts

Actual debug/optimized GCC and Clang artifacts show the supplied arithmetic subject and real geolab boundaries. Explain the System V scalar argument/result locations, a local without a dedicated optimized slot, and the relocation that names an external transfer. A tail jump may satisfy a C call's effects while using the caller's existing continuation.

C semantics, ISA effects, course policies, ABI agreements, compiler choices and microarchitecture answer different questions. The [guided reading](/further-reading/week-12) connects those layers; the [complete exemplar report](/materials/week-12/instructor/report) includes actual object observations. No timing or prediction-success conclusion follows from guest steps or a short listing.

## Read and watch

<!-- readings -->

## Build and inspect

```sh
cd week-12
make
make test
make warmups
make inspect
make CC=clang MODE=optimized inspect
```

After implementation, use the supplied CLI and playground. The [package guide](/materials/week-12/README) specifies commands, accepted bytes, budgets and the trace format. Six reference configurations and separate learner gates distinguish finished correctness from a compiling scaffold.

## Guided checkpoint exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->

## Practice and stretch

<!-- practice -->

## Notebook and handoff

Preserve predictions and actual evidence, including complete failure outputs and your compiler manifests. Submit one coherent Project 2 package under the rubric. Week 13 introduces explicit clocks and repeatable timing, with state correctness already checked.

<!-- report -->

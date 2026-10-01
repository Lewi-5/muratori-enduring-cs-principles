---
prev:
  text: Week 10 · Stack discipline, calls and lifetimes
  link: /weeks/week-10
next:
  text: 'Week 12 · Project 2'
  link: '/weeks/week-12'
---

# Week 11 · The ABI and generated x64 assembly

Week 10 gave a routine a saved continuation. Now separately compiled C routines need agreements about argument locations, register ownership and stack alignment. This week implements small C subjects and inspects completed geolab functions under System V AMD64 LP64. The [beginner section](/beginners/week-11) develops the distinction between ISA, ABI, compiler choice and unmeasured processor behavior.

## Map the signature before the listing

geo_distance_km takes four doubles and a pointer, writes the distance through the pointer and returns an integer status. The floating arguments use a separate register pool from the pointer. query_hit_compare instead receives pointers to two objects. The [package guide](/materials/week-11/README) identifies exact boundaries and the planner's deliberately restricted scalar domain.

## Follow values that survive a call

The callback exercise keeps seed and output pointer alive across an indirect call. Generated code may save those values in preserved registers or stack slots. Entry and post-prologue RSP offsets differ; a correct explanation labels the point in execution rather than treating an offset as an eternal property of a parameter.

## Compare implementation, not imagined costs

The supplied local_example can lose its stack slot under optimization while keeping the same numerical result. Object relocations identify external calls before link resolution. Return-predictor state is separate from architectural stack contents, and neither instruction count nor an 8086 cycle table measures a modern x64 function. The [guided readings](/further-reading/week-11) connect each question to the appropriate primary rule and companion explanation.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-11
make
make test
make inspect
make MODE=optimized inspect
```

After implementation, run `build/learner/gcc/debug/playground`. [lab.h](/source/week-11/include/lab.h) gives checked function contracts. The [inspection tool](/source/week-11/tools/inspect.py) generates actual compiler/object artifacts and manifests; it does not impose an exact universal listing. There is one optional short reference probe, accessed explicitly after your attempt.

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

Preserve predictions, annotations and toolchain identity. Week 12 combines the historical simulator with a qualified modern x64 comparison as Project 2; architectural state, ABI correctness and timing claims remain different forms of evidence.

<!-- report -->

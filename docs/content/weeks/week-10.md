---
prev:
  text: Week 9 · Branches and bounded guest memory
  link: /weeks/week-09
next:
  text: Week 11 · The ABI and generated x64 assembly
  link: /weeks/week-11
---

# Week 10 · Stack discipline, calls and lifetimes

You branch to a routine, then need to resume after the instruction that called it. Nested routines need several saved continuations, with the newest retrieved first. This week extends the C simulator with register PUSH/POP and near CALL/RET. Begin with the [beginner section](/beginners/week-10) if the byte order, SP direction or difference between stack contents and C lifetime is unfamiliar.

## A continuation is ordinary guest data

CALL calculates the following IP, pushes it as a two-byte word, then transfers. RET reads a word at SP and selects it as next IP. Saving a register between those operations places a data word in the same stack region; restore it before returning. The processor has no special knowledge that your word was intended as AX rather than a continuation. This model adds target-boundary checks as an explicit teaching restriction.

Our original nested fixture reaches an inner routine, returns to the outer routine, restores saved AX into BX, and returns to the caller. Draw each saved word before comparing the golden trace. Correctly balanced SP alone cannot prove the right registers were restored.

## The historical instruction matters

Original 8086 PUSH SP stores its decremented value, while modern x86 stores its earlier value. POP SP's destination write determines the final SP after the internal read/increment. INC/DEC preserve CF while changing the other modeled arithmetic flags. These operation-specific rules are checked, not inferred from a vaguely similar ADD or a modern disassembler.

The [package guide](/materials/week-10/README) defines exact accepted bytes, the stack window and the flat-memory simplification. The pinned prerequisites make Week 10 independently buildable. [Week 11](/weeks/week-11) connects its saved continuations to actual compiled x64 calls.

## State changes have a boundary

A failed RET must not leak its tentative POP. A failed run must not leak earlier memory stores. Both step and runner use local Machine state and commit only on success. A finite instruction budget makes an infinite loop a deterministic error. Code is immutable and predecoded in full, including unreachable bytes; those are teaching policies, not complete 8086 fetch behavior.

The [guided reading page](/further-reading/week-10) separates C scope and storage duration from architectural stack operations. Old guest bytes can remain after POP, but unchanged contents cannot extend the lifetime of a returned C automatic local.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-10
make
make test
make warmups
```

After implementation, run `build/learner/gcc/debug/playground` for the nested-call example. [machine.h](/source/week-10/include/machine.h) defines the contracts; [the test harness](/source/week-10/tests/contracts.c) compares explicit values, boundaries and unchanged-state expectations. Reference tests and learner checks remain separate.

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

Preserve predictions and explain what each observed transition proves. Week 11 compares these historical calls with generated x64 functions under an ABI, adding argument locations, register ownership, alignment and optimization choices. This week's trace models state, not modern CPU cycles.

<!-- report -->

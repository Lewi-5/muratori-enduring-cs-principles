---
prev:
  text: 'Week 8 · Registers and flags'
  link: '/weeks/week-08'
next:
  text: 'Week 10 · Stack discipline'
  link: '/weeks/week-10'
---

# Week 9 · Branches and bounded guest memory

Your simulator can change registers, but cannot repeat an instruction body or touch a decoded memory operand. This week adds conditional next-fetch selection and a flat array of guest bytes. Start with the [beginner section](/beginners/week-09) for the following-IP calculation and the distinction between a guest offset and host storage.

## Turn a stream cursor into IP

A relative jump adds its signed displacement to the position following the complete instruction. Jcc tests flags without changing them; JMP always transfers. After CMP, unsigned “below” uses CF while signed “less” uses SF different from OF. The same stored byte pattern can answer different questions because signedness belongs to the interpretation.

The executor accepts all sixteen short Jcc forms and short/near relative JMP. It checks taken targets against decoded instruction boundaries or the end boundary. Full predecode also rejects malformed unreachable bytes. Those are explicit teaching policies; hardware can decode bytes at positions this subset rejects. See the [package contract](/materials/week-09/README) for the complete predicate table and unsupported forms.

## Make memory expressions do work

The eight address expressions use old word register values plus signed displacement, modulo 65536. Direct addresses remain unsigned. Data width chooses one byte or a little-endian word; a word at FFFF uses the separately indexed byte at 0000. Code lives in a separate immutable array. This flat model omits segments and self-modifying code.

Read all source values and calculate the destination address before writes, so aliasing cases such as MOV BX,[BX] use the pre-state. MOV preserves flags, CMP writes only arithmetic flags and ADD/SUB update data and those flags. Defined numeric byte operations keep guest endian and address rules independent of host alignment and pointer representation.

## A finite attempt with a complete commit

A positive instruction budget prevents an accidental infinite loop from hanging the exercise. Both a failed step and a failed whole run preserve every register, flag, IP and data byte. Returned offsets and tentative successful step counts describe the attempt. Reaching the halt boundary on the final allowed step succeeds.

The supplied driver validates before replaying stdout, and the original fixture repeats a memory increment three times. The golden thirteen-step trace is hand-derived; a separate Python oracle checks every trace field for 255 starting counts. The [guided reading](/further-reading/week-09) connects these transitions to source loops and explains the boundaries of the model.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-09
make
make test
make warmups
```

Implement the typed stubs, then run `build/learner/gcc/debug/playground` and compare your predicted thirteen transitions. [machine.h](/source/week-09/include/machine.h) defines ownership and failure contracts. The [contract tests](/source/week-09/tests/contracts.c) and [independent loop oracle](/source/week-09/tests/check.py) check successful state and complete rollback.

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

Preserve predictions, actual trace output and a precise claim about what passed. Week 10 stores a following instruction position as a little-endian word in guest memory, then restores it on return. This week's next-fetch and memory rules supply the mechanism for that continuation. Neither execution count nor replay speed establishes processor cycles.

<!-- report -->

---
prev:
  text: Week 6 · Bytes to instructions
  link: /weeks/week-06
next:
  text: Week 8 · Register state and arithmetic flags
  link: /weeks/week-08
---

# Week 7 · Memory operands and a decoder API

You decode `89 D9` successfully, then try `8B 46 FE` and receive an unsupported-mode error. Week 6 deliberately stopped there. The mode now describes a location, and the instruction needs an address description before its length and operands are known. This week adds that description and makes the decoder usable from another compiled program.

## From a register to a location

You see the familiar register field and assume the other three bits name another register. They do only in mode 11. In memory modes the same field chooses one of eight address formulas. The extra constant is a displacement: an adjustment to the location. It is separate from an immediate value used by the operation itself.

The full address table is in the package guide and the Intel manual. Word address registers are used even for byte-sized data. Mode 00/rm=6 is the unsigned direct-address exception; mode 01/rm=6 is bp plus a signed byte. The beginner section walks this distinction before the core assignment.

## Build a description before executing anything

You want to print a memory move but do not know bp's current contents. The decoder does not need them. It records a recipe such as bp minus two. The formatter can display that recipe. A later simulator will evaluate it against state and access guest memory under a bounded model.

Do not turn an encoded guest address into a C pointer. The host program's address space and the modeled processor's memory are different objects. Week 9 will introduce their explicit relationship. Week 8 first uses decoded register-only instructions to model state transitions.

## A form determines its own length

You are decoding an arithmetic immediate after a displacement. Reading from the old fixed offset two gives the displacement as the immediate. The mnemonic can still look right, so inspect lengths and operand fields together.

Follow opcode → ModR/M → address bytes → immediate. Establish the operation before reading its tails, then validate each extent. The whole instruction is committed only on success, preserving Week 6's transaction. The stream validates all instructions before it writes text.

## A boundary another source file can use

You move parsing into one module and formatting into another. The caller should rely on documented types and behavior, rather than knowing the private helper sequence. The public header supplies declarations; compiled definitions supply the code. The library's API also states who owns storage, what may overlap, and what changes on each failure.

The shared object brings those compiled definitions into another process image through the Linux loader. Its PIC and search-path flags are toolchain conventions. A version function announces this week's API layout; both sides still need matching headers and compatible machine conventions.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-07
make
make test
make symbols
```

After completing E01–E03, run `build/learner/gcc/debug/playground` to compare four address and immediate forms. `build/learner/gcc/debug/client` calls your shared library. The [package guide](/materials/week-07/README) gives exact forms and workload, the [public header](/source/week-07/include/decode.h) gives the caller contract, and the [oracle](/source/week-07/tests/oracle.py) constructs independent expected encodings.

## Guided exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->

## Practice and stretch

<!-- practice -->

## Notebook and next week

Preserve your hand partitions and library evidence. Explain which observation concerns encoded fields, which concerns text and which concerns linking or loading. Week 8 will add register state and flags; Week 9 will evaluate the memory descriptions you have now built.

<!-- report -->

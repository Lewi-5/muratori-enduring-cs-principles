---
prev:
  text: Week 5 · A validated scalar baseline
  link: /weeks/week-05
next: false
---

# Week 6 · Bytes to instructions

You open a binary file and see `89 D9`. The bytes do not say “move” in any human language. Yet an 8086 instruction table gives them a precise interpretation. Starting one byte later in a different stream can produce another valid-looking instruction, even when that was not the intended boundary.

This week you build a decoder that turns a specified subset of 8086 encodings into text. You will not execute those instructions or build a simulator yet. The small architecture and subset make it possible to account for each field, each length, and each rejected input.

## Why use an older architecture here?

Week 5 raised questions about what compiled code actually does. A modern x86-64 instruction stream adds prefixes, addressing forms, and many instructions before you can see the basic decoding problem clearly. The 8086 subset isolates that problem.

The transferable ideas are unsigned byte handling, field extraction, explicit interpretation, bounded parsing, and independent evidence. They connect directly to Week 1's bit operations, Week 2's representation work, and Week 4's parser statuses. Memory addressing is planned for Week 7; do not guess it into this week's implementation.

Work through E01–E03 as helpers, E04–E05 as instruction decoding and presentation, then E06 as stream composition. Do the required E07 hand decodings before running tools. The ten-hour estimate assumes prior C experience and remains unpiloted.

By the end, you should be able to derive an accepted instruction by hand, identify how many input bytes it consumes, return the right rejection status without partial output, and explain why decoding text neither executes an instruction nor guarantees a unique reassembly. An **ISA**, or instruction set architecture, specifies the programmer-visible instructions and their encodings. A **register** is a named storage location in that architecture; an **immediate** is a value carried inside an instruction's bytes.

## Bytes need a grammar and a starting point

### Fields are small numbers inside a byte

You write `D9` in hexadecimal. It denotes the same eight bits as `11011001`. In the ModR/M byte, the first two bits form `mod`, the next three form `reg`, and the last three form `r/m`:

```text
D9 = 11 | 011 | 001
     mod  reg   r/m
```

The groups have numeric values 3, 3, and 1. Shifting a desired group down to bit zero and masking away unrelated bits extracts its number. Shifting alone is insufficient when higher groups remain.

The field name **ModR/M** reflects its role in selecting modes and register-or-memory operands. In this week's accepted subset, `mod = 11` selects register mode. A different value is meaningful in the ISA but unsupported by this decoder.

### A register code is interpreted in context

You see register field four and look for a name. Width matters: the 8086's byte table names `ah`, while the word table names `sp`. The tables are not two spellings of the same eight objects. Some byte names identify high or low halves of the first four word registers.

The width bit is therefore part of the interpretation, not merely a display preference. Modern x86-64 adds further rules, including prefixes that affect register naming. Keep that comparison labelled and outside the implementation's scope.

### A complete example: 89 D9

The first byte, `89`, is `10001001` in binary. The `100010dw` form identifies a register/memory `mov`; here `d = 0` and `w = 1`. The second byte has `mod = 3`, so the operands are registers. Its `reg` field names `bx` and its `r/m` field names `cx` in the word table.

With `d = 0`, `r/m` is the destination. The canonical output is therefore `mov cx, bx`, and the instruction consumes two bytes. The derivation uses the format, mode, width, and direction together; recognizing only the mnemonic would leave most of the work unexplained.

This example decodes bytes into a description. It does not change a register or show that the bytes were ever executed.

## Interpreting immediates safely

### The encoded order is not the host's order

You read the bytes `34 12` as a 16-bit immediate. The 8086 encoding puts the least significant byte first, so the numeric value is `0x34 + 256 × 0x12 = 0x1234`. Arithmetic constructs that value independently of how your host stores its own integers.

This differs from Week 2's object inspection. There you observed a host representation. Here you implement a specified external representation. Copying two bytes directly into a host integer would accidentally let the host's byte order choose the result.

### A bit pattern and a signed value are different steps

You read `FE` as an unsigned eight-bit pattern, numerically 254. Interpreting that pattern as a two's-complement signed eight-bit value gives `254 - 256 = -2`. Sign extension preserves that signed value in a wider representation.

The course uses wider arithmetic to make the conversion explicit. A narrowing cast to a signed type is not a portable substitute for the required interpretation under C11. Also remember integer promotions: an eight-bit unsigned operand can be promoted to `int` before a shift. Prove the chosen shift is safe rather than relying on the original variable's type name.

## Decoding is a transaction

### Do not read a byte merely because the opcode suggests it

You recognize an instruction requiring two immediate bytes but only one remains. The encoding tells you what would be needed; the input extent tells you what exists. Test availability before reading. Checking `offset <= avail` and then `size <= avail - offset` avoids an overflowing `offset + size`.

A temporary instruction object lets you reject an invalid or incomplete request without partially modifying the caller's result. This is the same validate-then-commit idea used by the CSV parser.

### Formatting and stream output have their own boundaries

You decode a valid instruction but the text buffer is one byte too short. That is an output-capacity failure, not a byte-decoding failure. Formatting into a temporary buffer allows a complete result or no result under the stated contract.

For a whole stream, a first pass validates instructions and counts required text. A second pass writes only when the whole stream is acceptable and fits. Track input offsets and output lengths separately; the reported byte failure begins at the failing instruction's first byte.

### Reassembly cannot recover every original choice

Two byte sequences can produce the same canonical text. For example, a different direction-bit arrangement can express the same register move. An assembler must choose an encoding, and text alone need not reveal which original encoding was used.

The analogy is a sentence with two equivalent phrasings: preserving meaning does not preserve the original wording. Here the equivalence is an ISA and formatting matter, not an invitation to ignore differing instruction semantics.

## Read and watch with a question

Watch the decoding episodes with the manual's field tables beside you. Ask which bits identify a form, which bits select operands, and which additional bytes are required. Treat material about memory modes as preparation for Week 7, not an expanded acceptance requirement now.

<!-- readings -->

## Tools and local workflow

```sh
cd week-06
make
make test
```

After implementing the decoder, write a tiny binary from explicit hex bytes and compare interpretations:

```sh
python3 tools/hex2bin.py t.bin 89 d9 83 c6 fe
build/learner/gcc/debug/decode8086 t.bin
objdump -D -b binary -m i8086 -M intel t.bin
```

The first command creates or replaces `t.bin` in the package directory. The decoder reads it. `objdump` is a separate toolchain witness: `-b binary` describes the input format, `-m i8086` selects the architecture, and `-M intel` chooses syntax. It may print hexadecimal immediates where the course prints signed decimal; compare meaning before comparing strings.

The [supplied types](/source/week-06/support/decode_types.h) and [decoder header](/source/week-06/learner/src/decode.h) define the interfaces. The [oracle](/source/week-06/tests/oracle8086.py) constructs encodings rather than decoding them, giving a different direction of reasoning. Neither a tool nor an oracle should remain an unexplained authority in your report.

## Guided exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->
<!-- exercise:E06 -->
<!-- exercise:E07 -->

## Practice and stretch

<!-- practice -->

## Your notebook and the next question

Keep three witnesses separate: your decoder's result, the encoding oracle's expectation, and `objdump`'s interpretation. When they differ, ask whether the issue is bytes, fields, architecture, supported scope, or presentation convention.

Week 7 is planned in the syllabus and adds memory modes and displacements. You have reached the end of the currently implemented companion. A useful handoff question is: what extra information must the decoder inspect before it can determine an instruction's length when a memory operand is present?

<!-- report -->

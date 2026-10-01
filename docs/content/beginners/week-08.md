# Week 8 beginner section · An instruction changes state

[Lesson](/weeks/week-08) · [Further reading](/further-reading/week-08)

## Purpose and prerequisites

You finished Week 7 and can print `mov al, 127`. The decoder can tell you what those bytes mean, but it cannot tell you what AL holds afterward. The missing piece is state: a record of the modeled machine’s current values. This week adds that record and functions that change it one instruction at a time.

Allow about 2–4 hours for this on-ramp and three warm-ups, in addition to the ten-hour core estimate. Both estimates are unpiloted. Bring Week 6’s register tables and signed patterns, Week 7’s decoded operands, and Week 1’s unsigned arithmetic and functions that preserve outputs on failure. You should be able to follow a struct, an array and a mask; refresh Beej’s chapters if the C syntax is unfamiliar.

By the end you can explain why a write to AH changes AX, why one addition can set overflow without carry, why comparison updates flags without storing a subtraction result, and why a program’s file position differs from its modeled instruction pointer.

## Vocabulary

| Term | Plain meaning |
| --- | --- |
| State | Values the modeled machine currently holds |
| State transition | The change from before an instruction to after it |
| Register view | A name that reads or writes a whole register or part of one |
| Guest | The historical processor our C program models |
| Host | The real machine running our C program |
| Width | How many bits belong to an operation’s data: eight or sixteen here |
| Flag | A stored one-bit fact about an arithmetic result |
| Carry or borrow | An unsigned calculation exceeding the upper range, or subtracting more than available |
| Signed overflow | A signed mathematical result outside the operation width’s signed range |
| Parity | Whether the selected bits contain an even number of ones |
| IP | The modeled 16-bit instruction pointer |
| File cursor | The position of the next encoded instruction in the supplied input bytes |

## Concepts

### The decoder and simulator answer different questions

You print a decoded MOV and expect a register to have changed. Printing never made that change. Decoding reads bytes and constructs an instruction description. Execution reads that description and the current state, then constructs the next state. Keeping these functions separate lets you inspect the meaning before deciding its effect.

Think of a recipe and the contents of your bowl. Reading the recipe identifies the requested operation; carrying it out changes the bowl. The analogy stops at the exact rules: our state transition is a deterministic mathematical operation on register bits, with specified flags and error behavior. It is not a model of how long a real kitchen or processor takes.

The C struct stores the guest register patterns as unsigned words. The host’s own hardware registers are a different mechanism used to run this program. A field named AX in the struct does not become the host’s physical AX, and a guest instruction count does not measure host CPU cycles.

### Two byte names share one word

You begin with AX containing hexadecimal 1234 and execute a write to AH. It is tempting to store AH in a separate array slot. That would allow AH and AX to disagree after the next word write. The ISA instead defines AH as AX’s high eight bits and AL as its low eight bits.

A numeric mask selects AL. A right shift by eight followed by a mask selects AH. Writing a byte clears only that portion of the word and merges the new byte into it. The other portion stays intact. This is the same field-extraction idea used for Week 6’s opcode byte, now applied to modeled register storage.

| Word view | Low byte view | High byte view |
| --- | --- | --- |
| AX | AL | AH |
| CX | CL | CH |
| DX | DL | DH |
| BX | BL | BH |
| SP, BP, SI, DI | No byte view in this subset | No byte view in this subset |

The names share numeric bits regardless of the host’s byte order. Reading the first stored byte of a uint16_t through a pointer would ask the host layout to choose the mapping. Masks and shifts express the guest rule directly. Also keep the width-dependent code tables distinct: byte code four is AH, while word code four is SP.

### One wrapped result, two range questions

You add one to the byte pattern 7F hexadecimal. The retained eight bits become 80. As unsigned numbers, 127+1=128 fits within 0..255. As signed numbers, 127+1 lies above the upper limit 127. The result pattern is the same; the two range questions have different answers.

The carry flag records the unsigned question. The overflow flag records the signed question. Now start from FF and add one: unsigned 255+1 exceeds the byte range, but signed -1+1=0 fits. This case sets carry without signed overflow. Keeping both flags makes it possible for a later instruction to choose the intended interpretation.

The simulator calculates in a wider unsigned type, then retains only the selected width’s bits. It can reason about signed range without asking the host to perform an overflowing signed calculation. C’s unsigned conversion and arithmetic rules are the implementation tools; the 8086’s result and flag rules are the behavior being modeled.

### Flags contain more than “negative”

You see a flags word after an ADD and want to treat it as a single success or failure indicator. Its bits answer several questions. ZF says whether the selected-width result is zero. SF records its top bit. OF says whether signed arithmetic exceeded range; it cannot be inferred from SF alone.

PF counts one bits in the low result byte. The count may be zero; zero is even. A word result’s high byte does not participate in this flag. AF records a carry or borrow across the four-bit boundary at the low nibble. A nibble is four bits, so this boundary separates bits zero through three from bit four.

These are historical instruction-set rules. They are not properties automatically returned by C’s `+` operator. E02 computes each flag explicitly. The package guide lists their bit masks so a hexadecimal trace word can be decoded one question at a time.

### Comparison saves evidence without saving its result

You compare AL with an immediate and notice that AL has the same bits afterward. That is expected. CMP calculates subtraction flags and discards the subtraction result. It leaves evidence for a later decision while preserving both operand values.

MOV has another rule: it changes its destination but preserves flags. A MOV between a comparison and a later decision therefore does not erase that comparison’s evidence in our selected subset. ADD and SUB replace the six arithmetic flags. Each instruction has its own state effects; “every instruction changes flags” would be the wrong general rule.

If source and destination are two views of the same word, read their old values before writing. For `mov al, ah`, first capture AH, then change AL. For `add al, ah`, capture both before storing the low-byte result. A partially updated source would describe a different state transition.

### File progress and guest IP are different positions

You run a short program with guest IP near its largest value. A successful instruction can make that 16-bit IP wrap to zero. Your input file has not restarted. A separate file cursor still points after the bytes already consumed.

The cursor has type size_t and describes an offset from the start of this supplied byte array. Guest IP has sixteen bits and describes modeled architectural state. This week’s runner is sequential, so it chooses bytes through the cursor and advances guest IP as an observed field. Week 9 will need a deliberate instruction-fetch and branch model instead of borrowing this cursor as a guest address.

### A failed program can preserve its starting state

You successfully execute the first MOV, then discover a truncated instruction near the end. If you have been writing directly into caller state, failure leaves that first MOV visible. The caller must now reason about a partly executed program.

Our whole-program contract runs against a temporary copy and commits only on success. The returned record still reports the failing byte offset and how many tentative steps succeeded. Those fields describe the attempted run, even though the caller state rolls back. The single-step function has a smaller boundary: each successful step commits once. Name the boundary whenever you describe preservation.

## Walk-through

Open `docs/examples/week-08/state.c` and compile it with the course’s C11 warning flags. The first part updates a high-byte view numerically. The next two additions show that carry and signed overflow are separate questions. The small snippet handles those selected examples; E02 generalizes the rules to all operands and both widths.

<!-- snippet:state -->
```c
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint16_t ax=0x1234;
    ax=(uint16_t)(((uint32_t)ax & 255u) | (255u << 8));
    printf("ax=%04x ah=%u al=%u\n",(unsigned)ax,(unsigned)(ax >> 8),(unsigned)(ax & 255u));
    unsigned a=127, b=1, full=a+b, result=full & 255u;
    int carry=full>255, overflow=(a<128 && b<128 && result>=128);
    printf("127+1 result=%u carry=%d overflow=%d\n",result,carry,overflow);
    a=255; full=a+b; result=full & 255u;
    carry=full>255; overflow=(a<128 && b<128 && result>=128);
    printf("255+1 result=%u carry=%d overflow=%d\n",result,carry,overflow);
    return 0;
}
```

<!-- output:state -->
```text
ax=ff34 ah=255 al=52
127+1 result=128 carry=0 overflow=1
255+1 result=0 carry=1 overflow=0
```

The first line shows that the low byte remains hexadecimal 34, decimal 52. The addition lines show raw unsigned result values and the two range predicates. Their output is checked against this file under GCC and Clang at `-O0` and `-O2`. They establish these arithmetic examples, not a complete CPU simulation or a timing measurement.

## Warm-ups

Work in week-08/learner/src/w01.c through w03.c. `make` compiles the supplied drivers and stubs. `make warmups` checks only these exercises after you implement them; the full `make test` also requires the core simulator.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

Use the explanation prompts attached to W01–W03: why does a numeric low-byte mask avoid host byte order, which byte survives a high-byte replacement, and why does a carry test not decide signed overflow? Write your reasoning before comparing with their separate answers.

## Ready for the lesson

You are ready for E01 when you can draw the word/byte bank and predict a preserved half. You are ready for E02 when you can state the two range questions for one result. Carry that distinction into E03’s state transition and E04’s whole-program contract. The playground will then show the combined mechanism in a short trace.

## Read alongside

Beej’s Guide to C §14.1, “Signed and Unsigned Integers,” and chapter 24, “Bitwise Operations,” explain the host tools. Scott’s “The Comparator and Zero” offers a gentle flag idea; its teaching CPU differs from the 8086. The [guided readings](/further-reading/week-08) supply exact chapter/page citations, modern-condition-code explanations and the primary ISA reference.

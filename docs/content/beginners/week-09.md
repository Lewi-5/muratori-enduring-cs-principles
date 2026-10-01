# Week 9 beginner section · Choose the next instruction

[Lesson](/weeks/week-09) · [Further reading](/further-reading/week-09)

## Purpose and prerequisites

You have a simulator that changes a register correctly, then moves on to the next instruction. You want it to count down from three and repeat a memory update each time. Writing the same instructions three times would work for that one count, but a program should also handle four or five without changing its code. It needs a way to choose what instruction comes next.

There is a second missing piece. Week 7 could print an expression such as `[BX+SI-7]`; Week 8 deliberately refused to execute it. Printing an address describes where data should be found. Loading or storing data must actually use that description, with rules for the size and ordering of the bytes.

Bring Week 8's register and flag ideas and Week 1's C arrays. You should recognize a byte, an unsigned integer, an array index and a function that reports failure. Week 7's decoder supplies the memory expression, so you can concentrate on its meaning. Allow 2–4 hours for this on-ramp and three warm-ups. The ten-hour core assignment is separate; both estimates are unpiloted.

By the end, you can calculate a backward target, explain why signed and unsigned comparisons choose different branches, and draw a word at the last guest address. You can also explain why a budget failure leaves the caller's memory unchanged.

## Vocabulary

| Term | Meaning here |
| --- | --- |
| IP | Instruction pointer: the guest byte position of the next instruction to fetch |
| Branch or jump | An instruction that selects a new next position |
| Conditional | Performed only when a stated test is true |
| Following IP | Position immediately after the complete current instruction |
| Relative displacement | Signed distance added to that following IP |
| Effective address | Numeric data offset calculated from an operand expression |
| Guest | The machine being modeled by our C program |
| Host | The real machine and C storage running that program |
| Little endian | A word's low byte is stored at its starting address |
| Boundary | Position at which a decoded instruction begins, or the accepted end position |
| Budget | Maximum successful instruction steps allowed in an attempted run |
| Transaction | An attempt whose complete state changes are published together on success |

## Concepts

### A stream position becomes a choice

You read the last line of a countdown body and want to read its first line again. A sequential file cursor normally advances past the bytes it consumed. The guest IP has a different job once jumps exist: it chooses the next fetch position, which may be earlier than the current position.

Most instructions still choose the position immediately after themselves. A jump instead adds a signed distance to that following position. The distance begins after the entire jump encoding, not at its opcode. In our fixture, a jump at byte position 15 takes two bytes. Its following position is 17, and displacement -8 selects position 9. Counting from 15 would produce 7, a different location.

A recipe that says “repeat steps four to six while servings remain” is a useful analogy. You keep a place in the instructions and sometimes move that place backward. The analogy stops at exact storage: guest IP counts encoded bytes, so instructions of different lengths occupy different amounts of space. It also says nothing about the condition flags or our accepted boundaries.

### The same pattern can answer two comparison questions

You subtract one from the byte pattern `80` hex and see `7F`. Taken as unsigned numbers, that is 128 minus 1, yielding 127. Taken as signed byte values, it starts at -128 and subtracts 1, whose mathematical result -129 does not fit. The stored result is still `7F`; the overflow flag tells you the signed calculation crossed its range.

A comparison instruction computes subtraction flags without storing its result. A later conditional jump chooses the question. JB, “below,” asks whether the unsigned left value was smaller and tests carry/borrow. JL, “less,” asks about signed values and tests whether sign and overflow differ. This distinction exists because the register stores a bit pattern without declaring a permanent signedness.

For `80` compared with `01`, carry is clear, sign is clear and overflow is set. JB stays on the sequential path because 128 is not below 1. JL transfers because -128 is less than 1. Looking only at the sign flag would lose the overflow information and answer the signed question incorrectly. The jump itself changes IP and preserves all flags.

### An address is a number before it is a byte access

You see `[BX+SI-7]` in decoded text and need to decide which array element holds the operand. Read the old word values of BX and SI, add the displacement, and retain the low sixteen bits. Only then use that numeric result as an index into guest data memory. A byte operand still uses word address registers; its data size does not shrink the address calculation.

The guest has 65536 data positions numbered 0 through 65535. Think of numbered lockers: the number identifies a place to put data, but it is not the data already inside. In C, an address expression in our simulator is a number, while a host pointer identifies accessible storage in the running process. The locker analogy does not authorize converting a guest number into a host pointer. Our implementation accesses `memory[index]` after producing a valid index.

Code lives in a separate immutable array. Writing guest data position 9 cannot alter instruction byte 9. Real 8086 addressing includes segments and can support code changes; this course chooses a narrower model so that a branch's code and a load's data remain easy to inspect. Week 10 keeps these same choices when it adds the stack.

### One word can use two distant array positions

You store word `1234` at the last guest offset, `FFFF`. A word needs two bytes: the low byte `34` starts at `FFFF`, and the high byte `12` goes at the next guest offset. This model defines the next offset modulo 65536, so that second position is `0000`.

That guest rule does not enlarge the host array. Reading `memory[65536]` in C would exceed the actual object. Instead, calculate the wrapped second index first and read `memory[0]`. Both separate byte accesses then remain in bounds. Assemble the result numerically by shifting the high byte eight bits and combining it with the low byte.

It may be tempting to cast a byte pointer to `uint16_t *` and load a word. That uses the host's byte order and alignment requirements, and it can violate C's object-access rules. At the last element it also cannot reach our wrapped byte at index zero. Explicit byte operations explain the guest representation on any host supporting the course's fixed-width types.

### A loop needs a stopping policy

You accidentally branch back while comparing an unchanged value. The test remains true forever. A simulator used for an exercise must eventually return an understandable result instead of leaving the test command stuck. Each run therefore receives a positive instruction budget and reports M_LIMIT if it has used that many successful steps without reaching the end.

The runner tries the program on a local copy of all registers and data. If a later target is invalid or the budget expires, none of the tentative stores becomes caller-visible. It still returns the number of steps it tried successfully. Those two facts fit together: the count describes the attempt, while the unchanged Machine describes what was committed.

We also predecode all instruction boundaries before execution. An in-range target can still point into an immediate rather than to the start of an instruction. Such a taken target is rejected. This is a course validation restriction: real hardware can begin decoding bytes at positions our model rejects. An untaken jump does not attempt its destination, so we do not validate that destination.

## Walk-through

You can see target calculation, wrapped byte placement and two comparison interpretations without implementing the whole simulator. Save or open [flow.c](/source/docs/examples/week-09/flow.c), compile it with a C11 compiler, and compare its output. This is a small arithmetic example, not a complete Jcc implementation: the signed conversion shown deliberately handles this particular high-bit value.

<!-- snippet:flow -->
```c
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    unsigned next=17, pattern=248;
    int32_t displacement=(int32_t)pattern-256;
    unsigned target=(next+(uint32_t)displacement) & 65535u;
    uint8_t memory[65536]={0};
    unsigned address=65535;
    memory[address]=0x34;
    memory[(address+1u) & 65535u]=0x12;
    unsigned word=(unsigned)memory[address]
        | ((unsigned)memory[(address+1u) & 65535u] << 8);
    printf("following=%u displacement=%d target=%u\n",next,(int)displacement,target);
    printf("data[ffff]=%02x data[0000]=%02x word=%04x\n",
           (unsigned)memory[65535],(unsigned)memory[0],word);
    unsigned value=128;
    int signed_value=(int)value-256;
    printf("unsigned 128 < 1: %d; signed -128 < 1: %d\n",value<1,signed_value<1);
    return 0;
}
```

<!-- output:flow -->
```text
following=17 displacement=-8 target=9
data[ffff]=34 data[0000]=12 word=1234
unsigned 128 < 1: 0; signed -128 < 1: 1
```

The first line begins at the following position, not the jump opcode. Pattern 248 is `F8`, and subtracting 256 gives -8 in a representable signed type. The mask retains the low sixteen address bits after defined unsigned arithmetic.

The second line names the two actual data positions. It does not claim a contiguous host word at the last byte; the code reads two individually valid array elements. Shifting `12` hex by eight puts it in the high half, then combining with `34` recovers `1234`.

The last line prints C's false and true results as 0 and 1. It shows why the two interpretations need different predicates; E02 connects those questions to carry, sign and overflow flags. The checked example produces these values with GCC and Clang at both -O0 and -O2. No CPU timing conclusion follows from this output.

## Warm-ups

Implement the typed stubs in the learner package and run `make warmups`. Each contract requires unchanged output on failure, so handle bad arguments before assignment. The [separate solutions](/materials/week-09/instructor/warmups) explain the reasoning when you are ready to compare.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

1. From which position is a relative displacement measured?
2. Why does signed JL need overflow as well as sign?
3. Which two host indices store a guest word at FFFF?
4. Does an untaken jump change flags or validate its destination?
5. What commits after a run exceeds its budget, and why can its step count still be nonzero?

Answers appear with the [warm-up reasoning](/materials/week-09/instructor/warmups). Use those answers to check a calculation you have already made; recognition alone is less useful than reproducing the reasoning on paper.

## Ready for the lesson

You are ready when you can calculate 17-8, explain the two comparison results, and draw the wrapped word without an out-of-bounds host access. The [main lesson](/weeks/week-09) adds the full condition table, decoded boundaries, old-state operand capture and the complete thirteen-step memory loop. Preserve your prediction before running its playground.

## Read alongside

Start with Scott's address and jump chapters for a picture of selecting a next instruction. Use Beej's array bounds and integer representation sections while you implement the warm-ups. The [guided further reading](/further-reading/week-09) connects those introductory accounts to CS 341's host pointer rules, CS:APP's conditions and Hennessy/Patterson's ISA choices. Those books help explain mechanisms; machine.h remains the source for the exact course model.

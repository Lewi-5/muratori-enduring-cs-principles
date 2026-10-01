# Week 12 beginner section · What does a passing trace prove?

[Lesson](/weeks/week-12) · [Further reading](/further-reading/week-12)

## Purpose and prerequisites

You run your simulator and see the expected final register value. That is encouraging, but several questions remain. Did a return word survive correctly? Did an invalid later jump undo the earlier memory write? Did the same-value store appear in the trace? A final register alone cannot answer every question about the whole program.

Project 2 brings the earlier pieces together and asks you to present evidence a colleague can review. The purpose is to make the modeled machine reliable and its limits explicit. You also compare two small real C subjects with generated x64 assembly, keeping correctness and performance claims separate.

Bring the register/flag ideas from Week 8, memory/branches from Week 9, saved return words from Week 10 and the calling-convention idea from Week 11. You can begin with C arrays, unsigned integers and checked function results; the supplied decoder and stack helpers let you focus on their composition. Allow 2–4 hours for this page and its three warm-ups, in addition to the unpiloted ten-hour core assignment.

You finish able to explain a prepared boundary map, distinguish changed-byte traces from write logs, and say what state evidence establishes without turning it into a timing claim. The [checkpoint contract](/materials/week-12/CHECKPOINT-2) tells you exactly what to submit.

## Vocabulary

| Term | Meaning here |
| --- | --- |
| ISA | Instruction-set architecture: the specified effects of encoded instructions |
| Subset | The particular forms the course model accepts |
| Prepared image | Immutable code plus a map of its instruction boundaries |
| Borrowed storage | Storage another object uses while its owner keeps it alive |
| Delta | A difference between old and new state |
| Golden fixture | Fixed input with separately derived expected output |
| Oracle | A method used to derive or check expected results |
| Transaction | Changes published together on success, with required outputs preserved on failure |
| ABI | Agreement about values and preserved state at compiled function boundaries |
| Relocation | Object-file information telling the linker how to resolve a symbolic reference |
| Microarchitecture | A processor's implementation mechanisms, such as prediction and scheduling |
| Manifest | A recorded list of sources, commands, versions and generated artifacts |

## Concepts

### Prepare once, keep the meaning stable

You execute a loop a hundred times and check the same code boundaries before every instruction. The bytes have not changed. Instead, preparation can decode the whole code region once and mark where accepted instructions begin. Later steps consult that map when a jump or return chooses a destination.

The map resembles a table of chapter beginnings in a book. It helps you choose a valid chapter start without searching the whole book each time. The analogy stops at storage and lifetime: a CodeImage borrows actual code bytes, and the caller must keep them alive and unchanged. A saved contents table cannot let you read a book that no longer exists.

Mutating the code can change instruction lengths even when its host pointer is unchanged. The old map then describes different bytes. Retire the image and prepare again after any such change. This ownership rule is part of the API; it is not a prediction mechanism inside the simulated CPU.

Preparation validates every encoding, including unreachable bytes, but does not promise every possible run will succeed. Whether a return pops a valid target depends on guest data and SP. Whether a loop halts depends on its state and conditions. Different checks belong at different moments because they need different information.

### Keep the tentative work separate from the published state

You store a byte successfully, then encounter an invalid return. If a whole-run API promises failure preserves caller state, restoring only registers would leave the earlier store visible. The runner must keep a complete local Machine, including all data bytes, until the program reaches its accepted halt.

The return record can still say one or several tentative steps succeeded. That number describes the attempted run. The unchanged caller Machine describes what was published. This is similar to filling in a draft before submitting it, but the analogy has a limit: the C implementation must enforce actual output boundaries, not merely label partial changes as a draft.

A trace has additional outputs: a record array and its count. If that array is too small, publishing half the trace would make the caller infer a partial result. Validate execution first, determine the required count, check capacity, then replay immutable input to fill the accepted output. A late execution error takes precedence over capacity because a malformed attempt has no successful complete trace to publish.

These are course API policies. Real hardware generally does not undo an entire program's earlier effects after a later fault. Explaining rollback correctly includes naming where the promise comes from.

### Changed bytes are only one view of memory

You write zero to a byte that is already zero. The instruction executed a store, but comparing old and new state shows no difference. This week's trace records changed bytes, so that store contributes an empty delta.

A word store can change two bytes. At FFFF, its low byte stays at FFFF and its high byte wraps to 0000 by our guest rule. Trace entries are sorted by numeric address, so 0000 appears first. Sorting a report does not move the high byte or reverse the encoding. Byte order describes storage meaning; delta order describes presentation.

POP reads a saved word and changes SP without erasing the old bytes. Its delta can be empty while registers change. A record includes all post CPU fields as well as memory differences, so the reader can inspect those two kinds of state. It still does not record all accesses, cache traffic or speculative work.

### Wrapping guest arithmetic still needs valid host C

You add one to guest byte 255 and want result zero with carry set. Performing the guest calculation does not require overflowing a signed host integer. Sum in a wider unsigned type, retain the low eight bits and calculate the carry separately.

The guest's bits have the behavior its ISA specifies. The host C program has its own requirements for representable arithmetic, shifts, accessible array elements and object lifetime. A model is useful only when the program implementing it remains valid. A sanitizer can catch selected problems in exercised cases, but passing it does not replace reasoning about those contracts.

The modern comparison also uses defined unsigned arithmetic. A compiler may remove a named intermediate while preserving its numerical effect. The absence of a stack slot is then an implementation choice, not evidence that the source variable was ignored or that every local must have a physical frame location.

### The same evidence cannot answer every question

You see a correct guest trace and a short optimized x64 listing. The trace answers which guest state changes occurred under this model. The listing answers what one compiler emitted with particular flags. Neither tells you elapsed time or how well a processor predicted a return.

Keep six roles apart. C specifies host program validity and observable effects. The ISA specifies guest instruction effects. The course adds boundaries, budgets and rollback. The ABI specifies compiled argument/result locations and preservation. The compiler chooses instructions satisfying those requirements. Microarchitecture supplies prediction, caches, pipelines and execution scheduling.

The roles meet in a running program, but their evidence remains distinct. A hardware return predictor is not the saved guest return word. A prepared boundary map is not either of them. A reduced instruction count can suggest a performance question; answering it requires the timing protocol introduced next week.

## Walk-through

Open [evidence.c](/source/docs/examples/week-12/evidence.c) and compile it as C11. It contains four small defined calculations you can check before implementing the full project. It is an introductory arithmetic example, not the decoder, trace or ABI planner.

<!-- snippet:evidence -->
```c
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    unsigned sum=255u+1u;
    uint8_t result=(uint8_t)(sum & 255u);
    const uint8_t starts[6]={1,0,0,1,0,1};
    uint16_t word=0x1234;
    uint8_t bytes[2]={(uint8_t)(word & 255u),(uint8_t)((unsigned)word >> 8)};
    uint64_t value=UINT64_MAX;
    uint64_t doubled=value*UINT64_C(2);
    printf("byte result=%u carry=%u\n",(unsigned)result,sum/256u);
    printf("target 1 boundary=%u; target 3 boundary=%u\n",
           (unsigned)starts[1],(unsigned)starts[3]);
    printf("word 1234 bytes=%02x %02x\n",(unsigned)bytes[0],(unsigned)bytes[1]);
    printf("defined unsigned result=%llu\n",(unsigned long long)(doubled+UINT64_C(1)));
    return 0;
}
```

<!-- output:evidence -->
```text
byte result=0 carry=1
target 1 boundary=0; target 3 boundary=1
word 1234 bytes=34 12
defined unsigned result=18446744073709551615
```

The first line sums 255+1 in a wider unsigned value, then masks to a byte. Quotient by 256 supplies carry for this byte calculation. It does not calculate signed overflow, which asks a different range question.

The second line reads a map with starts at 0 and 3 and an accepted end at 5. Position 1 is inside the represented code region but absent from the map. That distinction is why a taken target can be numerically in range and still fail our model's boundary check.

The third line stores the low eight bits of 1234 hex first, then the high eight bits. Two contiguous local bytes demonstrate the representation. The full executor must separately select valid array indices when the guest start is FFFF.

The last line uses uint64_t modulo arithmetic. Doubling the maximum unsigned value yields one less than that maximum; adding one returns the maximum. No signed overflow is involved. A compiler can merge these operations into another valid expression. This output is checked with GCC and Clang at -O0 and -O2; it does not specify their exact generated instructions.

## Warm-ups

Implement the typed learner stubs and run `make warmups`. Work out the example results first, then compare with tests. [Separate written solutions](/materials/week-12/instructor/warmups) explain failures and portability limits.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

1. Does a valid boundary map keep borrowed code alive after its owner's storage ends?
2. Must an empty memory delta mean no store instruction executed?
3. Which position does CALL save, and does POP erase that word?
4. What publishes when a valid run needs more trace records than capacity?
5. What can an optimized-away local and a short instruction listing establish about correctness and cycles?

The [warm-up answer page](/materials/week-12/instructor/warmups) answers these questions after your attempt. Try to give one calculation and one limit instead of recognizing a sentence you have just read.

## Ready for the lesson

You are ready when you can explain the four output lines, draw a saved continuation and separate an attempted run from committed state. In the [main lesson](/weeks/week-12), predict the original 25-step call/loop/memory fixture and compare its complete fields, not only final AX. Use the checkpoint manifest to keep the evidence reviewable.

## Read alongside

Start with Scott for the role of encoded instructions, then Beej for valid host integer and array operations. The [guided reading page](/further-reading/week-12) connects those to C-library buffer contracts, CS 341's bug checks, assembly comparisons and modern CPU mechanisms. The deeper readings explain why a state simulator has a useful but limited purpose.

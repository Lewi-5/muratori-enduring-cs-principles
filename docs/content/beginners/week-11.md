# Week 11 beginner section · A call is an agreement

[Lesson](/weeks/week-11) · [Further reading](/further-reading/week-11)

## Purpose and prerequisites

You can draw Week 10's saved return word and follow RET. Now you compile a C helper in a separate file and wonder how it receives arguments. The processor's CALL instruction is only part of that answer. The caller and callee also need an agreement about registers, stack positions and which values may change. This week makes that agreement visible in generated assembly.

Bring Week 7's translation units, Week 10's stack and Week 5's geolab function contracts. You should recognize a function parameter, an output pointer and an unsigned integer. You do not need to write assembly for the core. Allow 2–4 hours for this page and three warm-ups in addition to the unpiloted ten-hour core estimate.

By the end you can distinguish the instruction, the ABI agreement, the compiler's implementation and an unmeasured performance question. You can also explain why a source local may have no stack slot without ceasing to have correct C behavior.

## Vocabulary

| Term | Meaning here |
| --- | --- |
| ISA | Instruction set architecture: what machine operations mean |
| ABI | Binary interface agreement between compiled components |
| AMD64/x64 | The 64-bit x86 architecture used on our host |
| LP64 | This environment's model with 64-bit long and pointers, 32-bit int |
| GP register | A general-purpose register carrying integer bits or addresses |
| XMM register | A register used here for scalar double arguments/results; it also supports packed operations |
| Spill argument | An argument placed on the stack after its register class is exhausted |
| Caller-clobbered | The caller must assume this register may change during a call |
| Callee-preserved | The callee must restore this register's incoming value if it changes it |
| Prologue | Instructions preparing a particular function's stack/register state |
| Relocation | A recorded request for the linker to resolve an address or symbol use |
| Leaf | A routine with no nested call in the execution being considered |
| Red zone | ABI-reserved bytes below RSP usable under its conditions, not live caller storage across a nested call |
| Optimization | Transforming implementation while preserving required observable behavior |
| Return predictor | Processor mechanism that guesses a return destination before its actual target is resolved |

## Concepts

### The caller and callee need shared locations

You pass a double and a pointer, then open the assembly and see different register families. Why not one list of registers for every source parameter? System V AMD64 uses separate classes. In our deliberately small model, integer values and pointers share six GP argument registers; doubles independently use eight XMM argument registers. Exhausting one pool does not exhaust the other.

The output pointer of geo_distance_km is its fifth source parameter, but the first parameter using the integer/pointer pool. The four earlier doubles do not take those GP locations. The function writes a distance through the pointer and separately returns an integer success status. “Output” therefore need not mean “return register.” Follow the public C signature before choosing a machine location.

This agreement belongs to the target ABI. Windows x64 uses a different agreement; compiling on the same instruction-set family does not make them interchangeable. The course uses Linux/WSL so that callers, libraries and our probe share System V rules. Full struct, vector and variadic classification is more complex; lab.h restricts the planner rather than hiding that complexity behind a misleading universal rule.

### A register can change internally and still be preserved

You keep a seed value, call a callback and add the seed afterward. The callback is allowed to change caller-clobbered argument registers. Your function must therefore keep its live seed elsewhere or recover it before use. The compiler can choose a preserved register or a stack slot. The ABI does not require one fixed choice.

“Preserved” is an entry-to-exit obligation: a callee may use RBX internally after saving its incoming value, then restore that value before returning. It does not mean RBX never changes during the function. RSP has its own restoration obligation too, because returning with the wrong stack position can retrieve the wrong continuation. A test of numerical output and a listing showing save/restore provide different pieces of evidence; neither justifies assuming every possible hand-written callee obeys the ABI.

### A stack offset depends on the moment you observe

You read an argument at RSP plus an offset, then a prologue pushes a register. The argument did not move in memory, but RSP moved. Its offset from the new RSP is different. Always label a diagram as caller-before-CALL, callee entry or after a particular prologue step.

For ordinary calls in our scalar subset, the caller aligns RSP to sixteen before CALL. CALL stores an eight-byte return address, so entry RSP has remainder eight modulo sixteen. The first spilled scalar argument follows that return word. After another register push, RSP has moved down by eight again. No fixed “argument offset” can be used without naming that reference point.

A leaf may use the System V red zone below RSP without subtracting it. This is an ABI permission, not a claim that those bytes can keep the caller's live data safe across another call. A nested callee has its own stack usage and can occupy overlapping bytes. Do not generalize one leaf observation into a nonleaf storage rule.

### A source variable need not have a physical slot

You declare doubled in C and expect to find a memory location labeled with its name. At little optimization the compiler may store it for a straightforward translation or debugging. Under optimization it may combine multiplication and addition directly into a result. C requires the correct value and effects; it does not require a stack write merely because a local name exists.

LEA's familiar bracketed expression can calculate a number without loading memory. In some listings it implements simple unsigned arithmetic directly. The same C function may use LEA, ADD or another valid sequence under another compiler. Do not confuse assembly syntax resembling an address with a guaranteed data read, and do not grade a source solution by whether it emits one favorite instruction.

This is Week 10's lifetime distinction again. A live automatic object's source-level rules do not demand one permanent processor-stack location. An expired object is still invalid even if old bytes remain; an optimized live computation may have no corresponding stack bytes at all.

### Prediction answers an earlier, different question

You see RET in disassembly and want to infer where the CPU fetched next. The architectural instruction resolves the actual continuation from the stack. A modern predictor can guess earlier so the front end can fetch likely instructions before that resolution. Its guessed state is not the stored return word.

The teaching simulator implements only the architectural state. It has no prediction mechanism. A listing shows instruction operations and code structure but not whether a particular return was predicted correctly. That requires processor-specific measurement and context. Likewise, a historical instruction-cost table is a model with assumptions; it does not turn a modern x64 instruction count into elapsed cycles.

## Walk-through

You first check the numerical behavior before interpreting an optimized listing. This standalone snippet has a local doubled and two calls with unsigned inputs. The source and exact output are checked against GCC and Clang at both optimization levels. The snippet is a behavior example; the separately compiled support/local.c in the assignment is the artifact subject whose public boundary remains available for inspection.

<!-- snippet:local_value -->
```c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
static uint64_t local_value(uint64_t value)
{
    uint64_t doubled=value*UINT64_C(2);
    return doubled+UINT64_C(1);
}
int main(void)
{
    printf("value=7 result=%" PRIu64 "\n",local_value(7));
    printf("value=max result=%" PRIu64 "\n",local_value(UINT64_MAX));
    return 0;
}
```

<!-- output:local_value -->
```text
value=7 result=15
value=max result=18446744073709551615
```

The first result is ordinary twice-the-input plus one. The second uses defined unsigned wrap: twice the maximum wraps, then adding one returns the maximum. Both compiler modes must preserve those numerical results. They can fold the standalone calls completely, so their output does not prove local_value was called at runtime or had a stack frame. Inspect the separately compiled subject and identify the actual evidence before claiming where the local went.

## Warm-ups

Use lab.h's restricted convention and register-code table. These exercises isolate locations, preservation and reservation before combining them in the planner.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

Explain why the fifth parameter can be the first GP argument, how a preserved register can change temporarily, why an entry offset changes after a push, why a missing stack slot does not mean an incorrect local calculation, and why RET's architectural target is not a return-prediction measurement. Attempt each explanation before reading the [instructor warm-up answers](/materials/week-11/instructor/warmups).

## Ready for the lesson

Begin E01 by mapping the C signatures, then implement the checked C functions. Generate your own artifacts and keep compiler version, target, flags and source hash together. Read relocation lines beside unresolved calls. Accept a different valid compiler sequence when you can connect it to the same C behavior and ABI obligations. The optional assembly probe comes after that analysis; the core is complete without hand-writing assembly.

## Read alongside

Read Beej [§17.4 Compiling with Object Files](https://beej.us/guide/bgc/html/split/multifile-projects.html#compiling-with-object-files) and [§23.7 Pointers to Functions](https://beej.us/guide/bgc/html/split/pointers-iii-pointers-to-pointers-and-more.html#pointers-to-functions). Dive Into Systems [§7.5 Functions in Assembly](https://diveintosystems.org/book/C7-x86_64/functions.html) bridges C and x64 calls. CS:APP §§3.7.3–3.7.5 develop data transfer and local storage: printed pp. 281, 284, 287; PDF pp. 273, 276, 279. Their diagrams help interpret actual listings rather than guarantee one frame layout. Use the primary ABI when a register/location rule, rather than a compiler observation, is in question.

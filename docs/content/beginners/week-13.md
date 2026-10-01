# Week 13 beginner section · Wall time versus timestamp counters

[Lesson](/weeks/week-13) · [Further reading](/further-reading/week-13)


## Purpose and prerequisites

You have checked that a program returns the right checksum. Now you run it twice and see different durations. Before changing the code, you need to know what the numbers mean: which clock produced them, what interval was included, and whether reading the clock itself matters at this scale.

This week builds a small timing harness: code that runs a specified task between two clock readings and records its result. You already know C functions, arrays, unsigned arithmetic and return-status checks from Weeks 1–5. Week 12 adds the habit of collecting evidence for a complete program. If function pointers are unfamiliar, read Beej’s section on pointers to functions before implementing E02; the supplied typedefs keep the declarations manageable.

Allow 2–4 hours for this page and its warm-ups alongside the unpiloted ten-hour core plan. Your goal is to explain a duration in the correct units, preserve evidence after a failed attempt, and avoid treating every counter tick as a processor core cycle. You do not need to understand every detail of an operating-system timer implementation before using its documented contract.

## Vocabulary

| Term | Meaning here |
| --- | --- |
| Timestamp | A reading locating an instant in one clock’s domain |
| Duration | Difference between two ordered readings in that domain |
| Monotonic | A clock that does not move backward during the supported use |
| Resolution | Granularity of representable clock readings |
| Accuracy | Agreement with a relevant reference quantity |
| Overhead | Extra work introduced by measuring or bookkeeping |
| Callback | A function passed to another function for it to call |
| Context | Caller-owned state supplied to a callback |
| Sample | One recorded measurement and associated checksum/diagnostics |
| Batch | Several work units measured together |
| TSC | Timestamp counter, read by x86 counter instructions |
| Calibration | Estimating a relationship between different measurement units |
| CPUID | An x86 instruction reporting processor capabilities |
| AUX | Auxiliary value returned with RDTSCP, useful as a diagnostic |
| Fence | An instruction imposing particular execution-order constraints |

## Concepts

### First choose the question

Suppose your task is waiting to be scheduled while another program runs. If you ask how much elapsed time a caller waited for its result, that pause belongs in the measurement. If you ask how much processor execution time the process consumed, a different clock is appropriate. The Linux monotonic clock answers the elapsed question while the system is awake; process CPU clocks answer an execution-time question. Linux monotonic time excludes system suspend, so an overnight suspended laptop is another case requiring an explicit choice. The [Linux manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html) defines these distinctions.

A stopwatch analogy helps: you record start and finish rather than interpreting the current calendar date. Its limit is that a software clock has documented adjustments, resolution, suspend behavior and possible read failures. A familiar stopwatch story cannot establish those properties. We use CLOCK_MONOTONIC because its contract fits this assignment’s elapsed batches, not because every timer behaves alike.

### Keep representation and units together

The timespec object has a seconds field and a nanoseconds-within-the-second field. A nanosecond is one billionth of a second. The local normalized form requires nonnegative seconds and nanos below one billion. Two seconds plus 300 nanoseconds becomes 2,000,000,300 nanoseconds. Writing that integer does not prove that the source clock can distinguish every nanosecond.

uint64_t is an unsigned integer with exactly 64 bits on the supported implementation. It can hold a large but finite nonnegative range. Conversion must check the multiplication and addition before performing them. A malformed nanos field is an argument error; an otherwise normalized duration beyond the integer range is an overflow error. Those are different explanations, even when both preserve the caller’s old output.

Unsigned subtraction wraps when the mathematical result is negative. Consequently, a reversed pair must be rejected before subtracting. Equality succeeds with zero. Two consecutive reads may return the same representable value; inventing a one-nanosecond duration would change the evidence. A report of one-nanosecond resolution from clock_getres describes granularity, not exact read cost or agreement with a physical reference.

### Make correctness independent of speed

Waiting for a real clock to produce a particular value makes an unreliable correctness test. Instead, supply a callback returning known timestamps. With start 100 and end 110, a ten-unit interval is a deterministic expectation. Another callback can deliberately fail on a chosen read. These injected tests establish the API’s arithmetic and error behavior; they do not measure clock quality.

The ClockSource combines a reader function and a context pointer. Context is storage the caller owns, such as a position in a fixed timestamp array. Work similarly combines a task function and its state. The library never owns those contexts. They must remain alive and unchanged except for the callbacks’ documented effects throughout the call.

Output publication is a transaction for library results: build a complete local sample and copy it only after all steps succeed. Imagine preparing a laboratory notebook entry and signing it after every required field is available. The analogy’s limit is that the experiment already happened. If work incremented a counter before the end read failed, preserving the sample cannot undo that increment. Retrying a measurement may repeat work, so choose workloads whose effects you understand.

### Measure enough useful work to interpret endpoints

Reading two endpoints takes time. If the task is extremely short, those reads can be large compared with the task. Measuring 32 identical folds together increases useful work per pair of endpoints. A checksum checks that the work produced the expected result; printing it after timing prevents terminal output from becoming the task being measured.

The workload lives in a separate translation unit and builds without link-time optimization, which would allow more whole-program transformations. This makes call boundaries reviewable in actual object files. It does not promise identical machine instructions for every compiler. Inspect the emitted kernel and record the flags when making a performance comparison.

Warm-up runs reduce an obvious first-use difference but cannot eliminate scheduling, cache state or virtualization effects. Keep all nine raw samples. A minimum describes one observed short interval; a lower median describes the middle-ranked value under a stated rule; a maximum preserves a long interval worth investigating. None is automatically the exact cost of the task.

### A counter needs a unit story

The optional x86 experiment reads a timestamp counter using RDTSCP. The counter tick rate may differ from the current core’s execution frequency. Think of a metronome and a musician: the reference beat can stay steady while the player changes speed. The analogy cannot establish a particular processor’s counter behavior, synchronization or virtual-machine implementation.

CPUID checks advertised support before any optional counter read. The invariant bit is recorded separately. LFENCE/RDTSCP/LFENCE follows the stated Intel ordering assumptions; RDTSCP alone is not a universal serialization of every instruction or store. The [Intel manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) specify the instruction constraints. Our reader does not establish global visibility of earlier stores.

The AUX diagnostic is kept at both endpoints. A difference flags a concern; equality cannot prove that migration never occurred. Calibration compares counter ticks with a monotonic elapsed window and estimates ticks per second. The windows include different endpoint work. A plausible ratio is useful evidence for this run, while core cycles, cross-core synchronization and VM fidelity remain separate questions.

## Walk-through

Start with fixed values whose meaning is known. The snippet below converts two seconds plus 300 nanoseconds, then subtracts an earlier timestamp in the same domain. The constants fit; the full E01 function must additionally validate arbitrary supported inputs and overflow.

<!-- snippet:interval -->
```c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint64_t seconds=2, nanos=300, begin=2000000100;
    uint64_t end=seconds*UINT64_C(1000000000)+nanos;
    if(end<begin)return 1;
    printf("end=%" PRIu64 " elapsed=%" PRIu64 " ns\n",end,end-begin);
    return 0;
}
```

<!-- output:interval -->
```text
end=2000000300 elapsed=200 ns
```

Read the output in three steps. First check that the seconds-to-nanoseconds conversion gives 2000000300. Then check that the earlier timestamp 2000000100 belongs to the same domain. Finally subtract to get 200 nanoseconds. The output is arithmetic evidence, not a real 200-nanosecond observation.

Now run the playground after E01–E03. Its four durations are 10,40,30,20, so sorted order is10,20,30,40. The lower median is 20. The four work callbacks return checksum 42. A late failure test verifies that no partial sample array publishes even though callbacks already ran.

## Warm-ups

Try the three small typed functions before the main exercises. Keep a sentinel output for each rejected input. Predict the edge cases before running `make warmups`; compare separate answers only after your attempt.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

- Can a zero elapsed duration be valid? Yes: equal readings are allowed; the test must preserve that observation.
- Does a failed measurement undo its task? No: only library output publication is transactional.
- Are timestamp-counter ticks always core cycles? No: state the clock and calibration assumptions.
- Does a short minimum prove a universal runtime? No: it describes one sampled host/workload interval.

## Ready for the lesson

You are ready when you can reproduce the fixed walk-through, explain each failure’s output policy and identify the unit or accounting definition in a report. Complete the three warm-ups, then work through [Week 13](/weeks/week-13). Preserve predictions before executing and keep actual measurement rows alongside your conclusions. The [warm-up answers](/materials/week-13/instructor/warmups) remain separate spoilers.

## Read alongside

Use the [guided reading](/further-reading/week-13) one rung at a time: Scott for physical coordination, Beej for C representation, Dive Into Systems for a systems bridge, then UIUC, CS:APP and Hennessy/Patterson for error handling and measured claims. Return to the public API when a textbook uses a different clock or profiling definition.

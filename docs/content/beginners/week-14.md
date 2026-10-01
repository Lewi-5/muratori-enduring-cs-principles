# Week 14 beginner section · Inclusive time, exclusive time and measurement overhead

[Lesson](/weeks/week-14) · [Further reading](/further-reading/week-14)


## Purpose and prerequisites

You know that one batch took a certain duration, but the batch contains several stages. You want to know which stage is worth investigating. Placing measurements around each stage creates a new problem: an outer interval includes its children, and recursion can enter the same named region again before the first invocation finishes.

This week builds a bounded instrumentation profiler: code that records explicit begin/end events and combines the resulting durations. Bring Week 13’s clock domains, checked deltas and measurement limits, plus C arrays, structs and return-status checks. The supplied support clock is a pinned completed prerequisite so the new work concentrates on event accounting.

Allow 2–4 hours for beginner preparation in addition to the unpiloted ten-hour core plan. You will explain inclusive and exclusive totals, trace recursive calls without overwriting starts, and quantify how instrumentation changes the workload. Shared-instance thread safety and automatic C scope cleanup are outside the supplied implementation; their missing mechanisms are explained in the exercises rather than silently assumed.

## Vocabulary

| Term | Meaning here |
| --- | --- |
| Instrumentation | Added code that records events or measurements |
| Scope | One entered region that must eventually be exited |
| Invocation | One occurrence of entering and exiting a region |
| Nested | A child scope entirely inside its parent’s active interval |
| Recursive | A function or region entered again through its own activity |
| Inclusive time | Duration of an invocation including its children |
| Exclusive/self time | Inclusive duration minus immediate-child durations |
| Frame | One active invocation’s ID, start and accumulated child time |
| Stack | Ordered active frames, with the newest removed first |
| Bucket | Accumulated totals for one ID |
| Hit | One successfully completed invocation |
| Covered time | Sum of exclusive time over recorded completed scopes |
| Perturbation | A change to execution caused by observing it |
| Baseline | The comparison run without the added profiler activity |
| Granularity | How finely regions are divided for measurement |

## Concepts

### Start with an interval tree

Imagine an outer operation running from 0 to 100. A child runs from 10 to 40, so its inclusive duration is 30. The outer operation’s inclusive duration is 100 and its exclusive duration is 70. Adding both inclusive durations gives 130 because the child’s thirty units are counted in both. Adding their exclusive durations gives 100.

A meeting analogy helps: a one-hour meeting contains a twenty-minute presentation. The presentation is included in the meeting’s hour; listing both durations does not create eighty minutes of elapsed time. The analogy’s limit is that a program needs exact endpoint ordering, bounded arithmetic and explicit nesting rules. Our events must be properly nested in one clock domain, and unrelated concurrent activities need another model.

Subtraction uses immediate children. If a child contains a grandchild, the parent already removes the child’s entire inclusive duration. Subtracting the grandchild again would remove its time twice. Build the tree before aggregating region labels; a diagram of invocations explains what a single total per label hides.

### Recursion needs one start per invocation

Suppose region1 runs from 10 to 40 and enters region1 again from 20 to 30. Saving one start per ID would overwrite 10 with 20. On return, the outer invocation’s original start would be lost. Instead, each begin pushes a frame with its own start, even when the ID matches a frame already active.

The inner invocation contributes inclusive 10 and self 10. The outer region1 invocation contributes inclusive 30 and self 20. Their shared bucket therefore has inclusive 40, self30 and two hits. This assignment deliberately sums inclusive time across every invocation. Another profiler could define recursive aggregation differently, so always state the definition when comparing reports.

A stack works like a pile of labeled trays: remove the newest tray before reaching one below it. Its limit is that our stack has an explicit capacity of32 and IDs are bounded to16 choices. Attempting a 33rd begin reports capacity failure; it does not overwrite a frame. The fixed bounds make allocation and failure behavior inspectable for this lesson.

### Commit an event as one coherent change

End needs to update a bucket, remove the current frame, charge its inclusive duration to the parent and advance the last successful timestamp. If one later addition overflows, publishing only the earlier changes would corrupt the accounting. A local copy lets the function check everything before committing the Profile.

A failed begin or end preserves the complete instance. A mismatched end cannot advance last even if its timestamp is later. A corrected event is compared with the last successful event. That contract applies to profiler state; it does not undo work the program already performed between events.

Unsigned integers still have finite ranges. Repeated hits may overflow even when each interval is tiny. Overlapping inclusive totals can overflow even when covered time fits. Rejecting an unrepresentable report preserves evidence that something exceeded the representation; silently saturating would change the mathematical quantity while making the output look successful.

### Closed scopes make reports interpretable

The API publishes a report only after every frame is closed. An active region has no finished inclusive duration and might still acquire children. Reporting it as though it had completed would require another explicit policy. Here P_ACTIVE tells the caller to balance the events first, leaving the report sentinel unchanged.

Covered time is the sum of exclusive time. For a serialized nested tree it equals the total duration of its root. For several separate roots it sums those durations and omits gaps between them. Thus covered time is useful for the recorded work; it is not automatically the elapsed time of the whole process. Inclusive sums overlap and percentages derived from them may exceed 100 percent.

The report lists every bucket in ID order, along with used-ID count and total hits. Stable order makes comparisons and review easier. Labels are deliberately outside the core API: the caller assigns meanings to IDs and must preserve that mapping when comparing captures or designing a later per-thread merge.

### The observer runs on the same machine

Instrumentation adds clock reads, calls, state copies and arithmetic. Those operations use instructions and memory and may change scheduling opportunities. A child interval starts after its begin timestamp and finishes at its end timestamp; some hook work lies inside that interval and some is charged to a parent’s exclusive region. Neither automatically isolates pure workload cost.

Compare a baseline and an instrumented batch doing identical folds and producing the same checksum. Alternate order between pairs to reduce one obvious ordering bias. Preserve raw elapsed values and compute (instrumented-baseline)/baseline. A zero baseline cannot support division; the driver prints NA. A negative value is retained because noise or changed state may make one measured sample shorter.

An empty-hook experiment helps assess scale. It cannot supply an exact subtraction that recovers every original interval. Scope depth, placement and surrounding code affect cost. Fine regions provide detailed attribution and many hooks; coarse regions provide less detail with fewer hooks. Choose a granularity appropriate to the measured workload and record that choice.

### Ownership and exit paths remain part of correctness

One Profile instance has a mutable stack and totals without synchronization. Its calls must be serialized. Separate threads can own separate instances, but their reports require an explicit merge policy, common units and checked sums. Parallel covered durations can overlap in wall time, so their sum may exceed a whole-program elapsed interval.

C does not automatically close a profiler scope on return. Each successful begin needs an end on every relevant exit path; a failed begin must not be matched with an invented end. Start with straightforward structured code and explicit result checks. Macros or automatic cleanup designs are later changes that need their own language and failure analysis.

## Walk-through

Use fixed durations before looking at variable real measurements. The snippet calculates the same tree as the playground: root0 contains region1, which recursively contains another region1 invocation. It demonstrates arithmetic with safe constants; the full API adds event order, capacity, overflow and output-preservation checks.

<!-- snippet:nested -->
```c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint64_t root=100, child=30, grandchild=10;
    printf("root self=%" PRIu64 "\n",root-child);
    printf("recursive id inclusive=%" PRIu64 " self=%" PRIu64 "\n",
           child+grandchild,(child-grandchild)+grandchild);
    printf("covered=%" PRIu64 " inclusive sum=%" PRIu64 "\n",
           (root-child)+(child-grandchild)+grandchild,root+child+grandchild);
    return 0;
}
```

<!-- output:nested -->
```text
root self=70
recursive id inclusive=40 self=30
covered=100 inclusive sum=140
```

Follow each invocation rather than only its ID. Root self is100-30=70. Region1 combines inclusive 30+10=40 and self 20+10=30. Covered is70+20+10=100, while inclusive sum is100+30+10=140. The two quantities agree with their definitions and need not agree with each other.

Run the playground after E01–E03 and compare all rows with the golden. Then inspect the real benchmark: each instrumented batch has one outer invocation and32 inner ones. Hits therefore equal33; the measured durations vary. Recursion is checked by deterministic event trees, so it never needs a lucky real-clock sequence to pass.

## Warm-ups

Try the three small typed functions before the main exercises. Keep a sentinel output for each rejected input. Predict the edge cases before running `make warmups`; compare separate answers only after your attempt.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

- Do inclusive totals necessarily sum to wall time? No: nested and recursive invocations overlap.
- Should a parent subtract its grandchild separately? No: its direct child’s inclusive duration already contains it.
- Can a failed end advance last? No: the entire state must remain unchanged.
- Is a negative measured overhead automatically invalid? No: retain it with the sampling context.

## Ready for the lesson

You are ready when you can reproduce the fixed walk-through, explain each failure’s output policy and identify the unit or accounting definition in a report. Complete the three warm-ups, then work through [Week 14](/weeks/week-14). Preserve predictions before executing and keep actual measurement rows alongside your conclusions. The [warm-up answers](/materials/week-14/instructor/warmups) remain separate spoilers.

## Read alongside

Use the [guided reading](/further-reading/week-14) one rung at a time: Scott for physical coordination, Beej for C representation, Dive Into Systems for a systems bridge, then UIUC, CS:APP and Hennessy/Patterson for error handling and measured claims. Return to the public API when a textbook uses a different clock or profiling definition.

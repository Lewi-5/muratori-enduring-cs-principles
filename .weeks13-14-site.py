exec(open('.weeks13-14-materials.py',encoding='utf-8').read().split('for n,d in data.items():')[0])
snippets={13:('interval',r'''
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
''','end=2000000300 elapsed=200 ns'),14:('nested',r'''
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
''','root self=70\nrecursive id inclusive=40 self=30\ncovered=100 inclusive sum=140')}
begin13=r'''
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

Waiting for a real clock to produce a particular value makes an unreliable correctness test. Instead, supply a callback returning known timestamps. With start100 and end110, a ten-unit interval is a deterministic expectation. Another callback can deliberately fail on a chosen read. These injected tests establish the API’s arithmetic and error behavior; they do not measure clock quality.

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

Start with fixed values whose meaning is known. The snippet below converts two seconds plus300 nanoseconds, then subtracts an earlier timestamp in the same domain. The constants fit; the full E01 function must additionally validate arbitrary supported inputs and overflow.
'''
begin14=r'''
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

Imagine an outer operation running from0 to100. A child runs from10 to40, so its inclusive duration is30. The outer operation’s inclusive duration is100 and its exclusive duration is70. Adding both inclusive durations gives130 because the child’s thirty units are counted in both. Adding their exclusive durations gives100.

A meeting analogy helps: a one-hour meeting contains a twenty-minute presentation. The presentation is included in the meeting’s hour; listing both durations does not create eighty minutes of elapsed time. The analogy’s limit is that a program needs exact endpoint ordering, bounded arithmetic and explicit nesting rules. Our events must be properly nested in one clock domain, and unrelated concurrent activities need another model.

Subtraction uses immediate children. If a child contains a grandchild, the parent already removes the child’s entire inclusive duration. Subtracting the grandchild again would remove its time twice. Build the tree before aggregating region labels; a diagram of invocations explains what a single total per label hides.

### Recursion needs one start per invocation

Suppose region1 runs from10 to40 and enters region1 again from20 to30. Saving one start per ID would overwrite10 with20. On return, the outer invocation’s original start would be lost. Instead, each begin pushes a frame with its own start, even when the ID matches a frame already active.

The inner invocation contributes inclusive10 and self10. The outer region1 invocation contributes inclusive30 and self20. Their shared bucket therefore has inclusive40, self30 and two hits. This assignment deliberately sums inclusive time across every invocation. Another profiler could define recursive aggregation differently, so always state the definition when comparing reports.

A stack works like a pile of labeled trays: remove the newest tray before reaching one below it. Its limit is that our stack has an explicit capacity of32 and IDs are bounded to16 choices. Attempting a33rd begin reports capacity failure; it does not overwrite a frame. The fixed bounds make allocation and failure behavior inspectable for this lesson.

### Commit an event as one coherent change

End needs to update a bucket, remove the current frame, charge its inclusive duration to the parent and advance the last successful timestamp. If one later addition overflows, publishing only the earlier changes would corrupt the accounting. A local copy lets the function check everything before committing the Profile.

A failed begin or end preserves the complete instance. A mismatched end cannot advance last even if its timestamp is later. A corrected event is compared with the last successful event. That contract applies to profiler state; it does not undo work the program already performed between events.

Unsigned integers still have finite ranges. Repeated hits may overflow even when each interval is tiny. Overlapping inclusive totals can overflow even when covered time fits. Rejecting an unrepresentable report preserves evidence that something exceeded the representation; silently saturating would change the mathematical quantity while making the output look successful.

### Closed scopes make reports interpretable

The API publishes a report only after every frame is closed. An active region has no finished inclusive duration and might still acquire children. Reporting it as though it had completed would require another explicit policy. Here P_ACTIVE tells the caller to balance the events first, leaving the report sentinel unchanged.

Covered time is the sum of exclusive time. For a serialized nested tree it equals the total duration of its root. For several separate roots it sums those durations and omits gaps between them. Thus covered time is useful for the recorded work; it is not automatically the elapsed time of the whole process. Inclusive sums overlap and percentages derived from them may exceed100 percent.

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
'''
for n,body in [(13,begin13),(14,begin14)]:
    slug=f'week-{n:02}';name,code,output=snippets[n];code=code.strip();write(f'docs/examples/{slug}/{name}.c',code)
    body+=f'\n<!-- snippet:{name} -->\n```c\n{code}\n```\n\n<!-- output:{name} -->\n```text\n{output}\n```\n'
    body+=('''
Read the output in three steps. First check that the seconds-to-nanoseconds conversion gives2000000300. Then check that the earlier timestamp2000000100 belongs to the same domain. Finally subtract to get200 nanoseconds. The output is arithmetic evidence, not a real200-nanosecond observation.

Now run the playground after E01–E03. Its four durations are10,40,30,20, so sorted order is10,20,30,40. The lower median is20. The four work callbacks return checksum42. A late failure test verifies that no partial sample array publishes even though callbacks already ran.
''' if n==13 else '''
Follow each invocation rather than only its ID. Root self is100-30=70. Region1 combines inclusive30+10=40 and self20+10=30. Covered is70+20+10=100, while inclusive sum is100+30+10=140. The two quantities agree with their definitions and need not agree with each other.

Run the playground after E01–E03 and compare all rows with the golden. Then inspect the real benchmark: each instrumented batch has one outer invocation and32 inner ones. Hits therefore equal33; the measured durations vary. Recursion is checked by deterministic event trees, so it never needs a lucky real-clock sequence to pass.
''')
    body+='''
## Warm-ups

Try the three small typed functions before the main exercises. Keep a sentinel output for each rejected input. Predict the edge cases before running `make warmups`; compare separate answers only after your attempt.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

'''+('''- Can a zero elapsed duration be valid? Yes: equal readings are allowed; the test must preserve that observation.
- Does a failed measurement undo its task? No: only library output publication is transactional.
- Are timestamp-counter ticks always core cycles? No: state the clock and calibration assumptions.
- Does a short minimum prove a universal runtime? No: it describes one sampled host/workload interval.
''' if n==13 else '''- Do inclusive totals necessarily sum to wall time? No: nested and recursive invocations overlap.
- Should a parent subtract its grandchild separately? No: its direct child’s inclusive duration already contains it.
- Can a failed end advance last? No: the entire state must remain unchanged.
- Is a negative measured overhead automatically invalid? No: retain it with the sampling context.
''')+f'''
## Ready for the lesson

You are ready when you can reproduce the fixed walk-through, explain each failure’s output policy and identify the unit or accounting definition in a report. Complete the three warm-ups, then work through [Week {n}](/weeks/{slug}). Preserve predictions before executing and keep actual measurement rows alongside your conclusions. The [warm-up answers](/materials/{slug}/instructor/warmups) remain separate spoilers.

## Read alongside

Use the [guided reading](/further-reading/{slug}) one rung at a time: Scott for physical coordination, Beej for C representation, Dive Into Systems for a systems bridge, then UIUC, CS:APP and Hennessy/Patterson for error handling and measured claims. Return to the public API when a textbook uses a different clock or profiling definition.
'''
    write(f'docs/content/beginners/{slug}.md',f'# Week {n} beginner section · {data[n]["concept"]}\n\n[Lesson](/weeks/{slug}) · [Further reading](/further-reading/{slug})\n\n'+body)
    page=f'''---
prev:
  text: 'Week {n-1}'
  link: '/weeks/week-{n-1:02}'
next: {'false' if n==14 else "\n  text: 'Week 14 · Nested and recursive profiling'\n  link: '/weeks/week-14'"}
---

# Week {n} · {data[n]['title']}

{'A passing state trace establishes correctness under its contract. To compare real elapsed work, choose a clock, keep raw samples and record the workload.' if n==13 else 'A whole-batch duration invites attribution to smaller regions. Nested and recursive events require explicit invocation accounting, and their hooks change execution.'} Begin with the [beginner section](/beginners/{slug}) and use the [guided reading](/further-reading/{slug}) for the seven-text comparison.

## Model before measurement

{'The harness accepts an injected reader and work callback. Validate normalized timespec fields, checked deltas and complete output publication independently of real clock behavior. A failed end read cannot undo completed work. Collect bounded raw samples and declare the lower-median summary policy.' if n==13 else 'The caller supplies ordered timestamps from one domain. Each begin creates its own stack frame; each end contributes one inclusive duration and its self duration. Same-ID recursion retains separate starts, then combines every invocation into the ID bucket. Failed events preserve complete state.'}

## What the report means

{'Linux CLOCK_MONOTONIC measures elapsed time while awake; a zero interval is allowed. The optional CPUID-guarded fenced RDTSCP experiment reports ticks separately. Empirical calibration is not core frequency; AUX and capability flags are diagnostics with stated limits.' if n==13 else 'Covered time sums self over recorded roots and omits gaps. Inclusive totals overlap and can exceed covered time. Completed reports are overflow checked and require an empty active stack. The fixed example covers100 units while inclusive totals sum to140.'}

## Read and watch

<!-- readings -->

## Build and inspect

```sh
cd {slug}
make
make test
make warmups
make inspect
python3 tools/measure.py gcc optimized learner
```

Use the [package guide](/materials/{slug}/README) for the full protocol, output fields and independent instructor verification. The workload folds512 IDs32 times, checks4202496 and prints outside the timed region. {'Keep nine raw work/empty intervals and optional counter samples.' if n==13 else 'Keep nine baseline/instrumented pairs with alternating order,33 instrumented hits and possible negative differences.'} Actual compiler artifacts and raw logs belong in the notebook; the [reference report](/materials/{slug}/instructor/report) is a separate exemplar.

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

Keep prediction, observed evidence, inference and limitation distinct. Neither instruction count nor a single duration supports a universal speed claim. {'Week 14 adds nested instrumentation using this checked clock.' if n==13 else 'Week 15 will extend measurement to throughput and repetition; the current profiler keeps its bounded serialized contract.'}

<!-- report -->
'''
    write(f'docs/content/weeks/{slug}.md',page)

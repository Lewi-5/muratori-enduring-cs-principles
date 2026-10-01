# Week 14 further reading · Inclusive time, exclusive time and measurement overhead

[Lesson](/weeks/week-14) · [Beginner section](/beginners/week-14)

## How to read this ladder

Start with the concrete problem, then choose one text at a time. The section/page table below is generated from the verified registry: printed labels and PDF page positions are different coordinates. Local copyrighted PDFs are not published by the site. Online references remain linked to their authors. You do not need to read every section in every book during the required viewing budget; deeper rungs are optional support for a question you cannot yet explain.

The CE public pages verify titles, runtime and topic. Paid episodes remain subscription resources; this package supplies original exercises and does not claim to reproduce their implementation. The Handmade Hero portions are selected from the official indexed chapters. Their Windows code provides comparison context; the local Linux API and explicit course policy determine the assignment.

### 1 · Scott: follow one occurrence

Start with *Step by Step* and *Speed*. Trace the ordered activity of one operation before grouping several under a label. For profiling, the same name can occur more than once, so counting names alone loses the start and end of each occurrence. Use the fixed tree in the beginner walk-through to keep those occurrences visible.

Scott supplies physical intuition rather than a recursive profiler specification. His simple machine does not define inclusive or exclusive aggregation, capacity errors or the local event transaction. State that boundary explicitly; the tree you draw is a model for this assignment and the public header defines its exact arithmetic.

### 2 · Beej C: give each active occurrence storage

Read Scope alongside bounded arrays and unsigned arithmetic. C scope tells you where names are usable and automatic storage lives; a profiler scope is a recorded interval requiring a matched end. Those two ideas interact but are not interchangeable. An early return can leave a recorded scope active even though its local C variables have gone out of scope.

The frame array gives each active invocation its own start. Same-ID recursion pushes another frame instead of overwriting one start in a bucket. Bounds checks reject depth 33 before writing; ordered subtraction and preflight sums prevent wrapping. If you get lost in the implementation, trace the three-frame example on paper before studying loops or macros.

### 3 · Beej library: copy only valid objects

The memcpy reference helps with local state snapshots and report publication. Its size and overlap obligations remain important when an operation promises unchanged output after failure. Read it as an object-access contract, not a permission to copy through arbitrary invalid pointers or alias the output over immutable input.

The supplied profiler uses struct assignment for complete local candidates and expects accessible disjoint storage. Exact state preservation can be checked against a byte snapshot of the same initialized object. This comparison checks a failed operation; it does not turn padding bytes into portable semantic data for unrelated independently created objects.

### 4 · Dive Into Systems: compare tool metrics

Read Timing for endpoint method and Cache Analysis and Cachegrind for a different style of analysis. A tool may count modeled instructions or cache events instead of real elapsed duration. Write the metric beside every output before trying to combine its numbers with the local event report.

The bridge gets harder when one region includes another. Inclusive time counts the child again at the parent, while self time removes direct-child intervals. The local profiler counts every recursive invocation; another tool may choose a different recursion convention. Compare definitions first. A disagreement between differently defined totals is not sufficient evidence of an implementation defect.

### 5 · UIUC: errors and thread ownership

Handling Errors supports the transaction for begin, end and report. Consider a valid nested interval whose combined inclusive report exceeds uint64 range. Each bucket can fit while the sum cannot. P_OVERFLOW leaves the old report untouched instead of quietly truncating or saturating it.

Race Conditions explains the other major limit. One Profile mutates a shared stack and totals without synchronization. Separate instances give threads separate ownership, but a completed-report merge still needs common units, stable labels and checked arithmetic. The core exercise uses serialized events. The Handmade Hero concurrency discussion is useful motivation for this ownership rule; it does not supply missing locks in the C API.

### 6 · CS:APP: profiling is a measurement choice

Read Program Profiling and Using a Profiler to connect attribution with decisions about expensive regions. First ask whether the region deserves further investigation; then examine finer placement. Instrumenting every tiny operation may generate more bookkeeping than useful work, while one large scope may hide the stage you want to distinguish.

The actual benchmark compares equal checksummed folds with and without 33 completed scopes. Alternating order reduces one obvious bias while leaving scheduling and host state variable. A negative relative difference stays in the data. More runs can clarify a distribution, but neither one slow sample nor a convenient minimum establishes a universal per-hook cost.

### 7 · Hennessy and Patterson: qualify overhead claims

Use Measuring, Reporting, and Summarizing Performance to name the baseline and measured workload. Then use Fallacies and Pitfalls to examine a proposed fixed correction. Empty-hook cost is an observation under a particular placement and build; subtracting it from every recursive interval assumes its cost transfers unchanged across depth, cache state and surrounding code.

The deeper quantitative material is optional. Begin with the simple fraction (instrumented-baseline)/baseline and explain its numerator and denominator. Converting before unsigned subtraction allows a negative observation. A zero baseline cannot support that ratio. F03 connects representational failure with an honest definition of the quantity being reported.

### Return to the event protocol

The local header defines 16 IDs, 32 frames, global order across successful events, all-invocation recursive inclusive totals and closed-report publication. The companions provide useful ideas around that design rather than its exact policy. Covered time omits gaps outside recorded roots. Per-thread sums may overlap in wall time, and instrumentation changes the execution it observes. State these limits when using a report to justify a next experiment.

## Source-by-source cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->

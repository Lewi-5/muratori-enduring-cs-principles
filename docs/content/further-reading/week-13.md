# Week 13 further reading · Wall time versus timestamp counters

[Lesson](/weeks/week-13) · [Beginner section](/beginners/week-13)

## How to read this ladder

Start with the concrete problem, then choose one text at a time. The section/page table below is generated from the verified registry: printed labels and PDF page positions are different coordinates. Local copyrighted PDFs are not published by the site. Online references remain linked to their authors. You do not need to read every section in every book during the required viewing budget; deeper rungs are optional support for a question you cannot yet explain.

The CE public pages verify titles, runtime and topic. Paid episodes remain subscription resources; this package supplies original exercises and does not claim to reproduce their implementation. The Handmade Hero portions are selected from the official indexed chapters. Their Windows code provides comparison context; the local Linux API and explicit course policy determine the assignment.

### 1 · Scott: what is ticking?

You hear “clock” used for both a processor’s coordination signal and a software elapsed-time reading. Start with *The Clock* and *Speed* to understand coordinated work before interpreting a timestamp. Follow one operation through the simple machine, then ask which physical beat is being discussed. This rung requires no C and is the best place to recover intuition if counters feel like unexplained large integers.

The limit matters: Scott’s teaching machine does not specify CLOCK_MONOTONIC or today’s invariant TSC. A physical clock story cannot establish the units, adjustment policy or cross-core behavior of an operating-system interface. Write that gap before moving to the C representation. F01 checks whether you can retain the useful intuition while naming the missing contract.

### 2 · Beej C: represent a reading and call a reader

Use §38.5 for the seconds/nanoseconds representation, §14.1 for unsigned ranges and §23.7 when callbacks become confusing. Begin with one local timespec conversion. Then trace how ClockSource passes both a function pointer and its caller-owned context. A callback is ordinary code invoked through a stored function address; the context gives it access to a position or work counter without hidden globals.

The difficult step is mixing representation with guarantees. Beej’s timespec_get discussion uses ISO C calendar time, not the required POSIX monotonic timer. Reuse its explanation of fields and return checks while keeping the providers distinct. For overflow, derive the maximum allowable seconds before multiplying; a cast alone cannot restore a value that already overflowed.

### 3 · Beej library: compare return contracts

Read the timespec_get and clock entries as reference pages, not as alternate implementations of E01. Identify the return value indicating success, the output object and the advertised unit. clock measures processor time; timespec_get with TIME_UTC concerns calendar-based time. Neither should silently replace monotonic elapsed endpoints.

Write a small comparison table containing metric, domain and failure check before coding. If the reference notation is dense, return to the programming guide’s example and then read just the relevant entry again. F02 asks for this distinction because a plausible number in the wrong domain can make a measurement report misleading without causing a C compiler error.

### 4 · Dive Into Systems: turn readings into an experiment

The Timing appendix bridges C calls and measured execution. Read it after you can compute one checked delta. Ask what belongs inside the interval: allocation, initialization, the actual fold, output, or all of them? Our benchmark states its choice and keeps initialization and printing outside the interval.

Its examples help you think about method; they do not supply a universal duration for this host. Keep the real raw samples and the checksum. A warm-up is a stated protocol choice, batching increases work per endpoint, and remaining variability belongs in the report. If you are tempted to erase a long sample, explain the filtering rule before seeing its convenient effect on the conclusion.

### 5 · UIUC: make failures observable

Use Handling Errors to examine begin-read, work and end-read failures separately. Follow a late failure after work has already changed its context. The public TimeSample stays unchanged, while the task effect survives. This is a concrete ownership boundary rather than a claim that every operation in a measurement can be undone.

The sanitizer section supports memory and arithmetic checks within executed domains. Sanitizers change generated code and cost; their timing is unsuitable for the performance comparison. Record a successful sanitizer gate as correctness evidence and collect performance observations from the stated debug/optimized builds. Do not infer all-input correctness from one clean execution.

### 6 · CS:APP: state the performance quantity

Read §5.2 before comparing numbers. Identify the workload, repeated operation and unit used for a performance statement. The sum of 512 IDs is a defined result, while the duration is an observed quantity. Compiler transformations can change the work actually emitted, so connect the object listing to the checksum-dependent call boundary.

This text’s processor-performance discussion is deeper than the timer API exercise. Keep a question beside it: what additional information would be required to turn elapsed nanoseconds into core cycles? The empirical TSC calibration alone does not provide that information. A short assembly listing is another observation, not the missing cycle measurement.

### 7 · Hennessy and Patterson: report what transfers

Use §1.8 to specify the comparison and summarize samples, then §1.11 to challenge tempting generalizations. A lower median, minimum and maximum answer different questions. The package states lower median for even counts; another tool’s average or interpolated median may disagree without an arithmetic bug.

At this rung the equations can be denser. Start by substituting the benchmark’s workload and unit into one statement, then identify which assumptions must stay fixed to compare a second machine. WSL, counter support, load and clock implementation belong in the context. F03 asks you to connect a calibrated ratio to a qualified claim rather than treating a plausible value as a processor specification.

### Return to the primary contract

For exact behavior, consult the Linux manual’s clock IDs and return values and Intel’s RDTSCP/LFENCE/CPUID entries. The calibration uses nested but different windows; AUX diagnostics and advertised capability are retained. No companion establishes store visibility, global counter synchronization or VM fidelity for the tested environment. E04’s answer must name those gaps, and E05’s report must preserve the evidence that remains useful despite them.

## Source-by-source cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->

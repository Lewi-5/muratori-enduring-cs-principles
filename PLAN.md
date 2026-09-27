# Build a 52-week C course on enduring computer science principles

## Summary

This is the authoritative syllabus and implementation specification for a full course built around [the transcript](rawTranscript.txt), [solPlan.md](solPlan.md), [analysis.md](analysis.md), and the two lesson indexes in this repository. The course uses C programs to connect source code to memory, machine instructions, operating-system behavior, and CPU performance. It culminates in a geospatial data engine that grows through seven section projects.

Preserve the sources' shared thesis: **C is useful here because an instructor can reach a lower mechanism from a small C program with relatively few conceptual steps.** Treat claims about exact generated instructions and the Java anecdote's speaker cautiously; the transcript does not establish either with certainty.

Use the official [Handmade Hero episode guide](https://guide.handmadehero.org/) and [Computer, Enhance! table of contents](https://www.computerenhance.com/p/table-of-contents) to resolve each assigned lesson to its direct page. Computer, Enhance! is a required subscription resource, but all course assignments, explanations, and solutions must be original. The local “Day 1001–1003” entries correspond to [Handmade Ray Days 01–03](https://guide.handmadehero.org/ray/); “Day 1006” is [The Thirty-Million Line Problem](https://guide.handmadehero.org/misc/30mlocp/), and “Days 1007–1008” are HandmadeCon compression talks. Normalize those links rather than inventing `/code/day1001/` URLs.

## Course and artifact contract

- **Audience and pace:** Experienced C programmers; 8–10 hours per week. Week 1 contains 15 short C exercises as a review and diagnostic. It is accessible to someone encountering C syntax, but the subsequent pace assumes prior programming and C experience.
- **Environment:** x86-64 Linux, GCC and Clang, C11, POSIX threads and memory APIs. Windows participants use WSL. All substantial authored software is C. Short handwritten assembly exercises are permitted in the instruction and ABI units; students chiefly *read* compiler output. SIMD uses C intrinsics with runtime feature checks and a scalar fallback.
- **Weekly package:** Each of 52 weeks gets objectives, prerequisite links, direct reading links, a 60–120-minute source viewing plan, an original C playground, one graded assignment, 4–6 practice problems, two stretch exercises, a rubric, full working C solutions, a complete written answer key, deterministic correctness tests, and a short “source → mechanism → observation” explanation. Long Handmade Hero episodes should point to relevant indexed segments rather than require the whole episode.
- **Source labels below:** `CE` means an exact entry in the official Computer, Enhance! table of contents; `HH` means a numbered Handmade Hero day; `Chat` means Handmade Chat; `Ray` means Handmade Ray. Repeated references are intentional. Each final weekly page must link directly to the named entry and to a relevant primary technical reference, such as the [C11 draft index](https://open-std.org/jtc1/sc22/wg14/www/standards), [x86 manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html), [System V x86-64 ABI](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf), or applicable [Linux manual page](https://man7.org/linux/man-pages/).
- **Project thread:** Build `geolab`, a command-line geospatial data engine. Begin with deterministic CSV points (`id,lat_deg,lon_deg`) and Haversine distance; later add a binary format, memory-mapped input, spatial indexes, compressed data, scalar and SIMD paths, and parallel execution. The principal commands are `generate --count N --seed S --out FILE`, `query --input FILE --lat X --lon Y --radius-km R --threads N --backend scalar|simd --index none|grid|kd`, and `bench --input FILE --variant NAME --repeat N`. Query results are ordered by distance, then ID. Invalid coordinates and malformed input produce explicit errors.
- **Seven checkpoints:** Weeks 5, 12, 20, 26, 35, 42, and 48 produce independently reviewable section projects. Weeks 49–52 integrate and defend the final engine. A project passes on correctness and explanation; no universal speedup threshold is imposed.

### Complete solutions policy

Every learner-facing request must have an instructor-facing answer: code, explanation, prediction, diagram, calculation, interpretation, practice problem, stretch exercise, reading question, section-project decision, and capstone defense prompt. Number prompts and answer-key entries consistently so an agent can verify that none is unanswered. Working reference C code and tests are necessary **in addition to** written solutions.

Written solutions must teach the reasoning, not merely give the result. For conceptual prompts such as “explain range versus representation,” provide a substantive worked answer with definitions, a concrete C example, the relevant portability boundary, and a common mistaken interpretation. For code, include an annotated solution, why it is correct, edge cases, and at least one plausible faulty approach. For measurements, give a sample report structure, the equations or analysis method, what conclusions the evidence permits, and how to interpret a different valid result on another machine; do not invent one required timing or assembly listing. For open-ended design and integration work, provide a complete exemplar design and report plus a rubric that accepts other correct designs. Keep solutions separate from the learner materials so the learner can attempt every task before seeing the answer.

### Explicit vectorization learning path

**Vectorization is a core outcome, not merely another name for SIMD.** SIMD is the hardware ability to operate on multiple lanes; vectorization is the work of turning a scalar computation into operations that use those lanes. The course must teach both **compiler autovectorization** and **explicit vectorization with C intrinsics**, including cases where neither is profitable or legal. Students compare the same kernel in three forms: scalar with vectorization disabled, compiler-vectorized, and explicit SIMD. They inspect compiler diagnostics and assembly, test lane tails and masks, verify numerical behavior, and measure on the reference CPU.

The sequence begins with a scalar baseline in week 5, introduces layout and loop structure in weeks 23 and 27–30, makes vectorization the primary assignment in weeks 31–32, applies it to mathematical code in weeks 33–35, and integrates it in week 51. Week 35 must assess whether students can explain *why* a loop did or did not vectorize, rather than just call an intrinsic. This directly addresses Muratori's point that invisible autovectorization alone does not ensure understanding; an autovectorized loop becomes educational when students predict and inspect what the compiler did.

## Week-by-week syllabus

### Weeks 1–5: C, representation, and the first scientific experiment

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **1** | CE Prologue “Welcome” and “Waste”; HH Chat 011 (undefined behavior), Chat 013 (translation units). Establish the difference between C semantics and one compiled result. | Complete **15 micro-exercises**: integers, `sizeof`, loops, functions, arrays, pointer traversal, structs, padding, byte inspection, bit operations, allocation/free, file reading, error returns, separate compilation, and a tiny benchmark. Explain two observations that are implementation-dependent. |
| **2** | CE Prologue “Instructions Per Clock”; HH 014, 064. Objects, bytes, alignment, automatic/static/allocated storage, pointers, linking. | Write an object-layout inspector and draw its memory before running it. Extra: compare two struct field orders and inspect object-file symbols. |
| **3** | CE Interlude “The Haversine Distance Problem”; HH 047, 048, 090–091. Coordinate bases, geometry, floating-point ranges, numerical edge cases. | Write a small geospatial math library with distance and segment-intersection tests. Extra: test poles, antimeridian, identical points, and nearly antipodal points. |
| **4** | CE Interlude “Clean Code, Horrible Performance” and Part 2's input-generator/processor entries; HH 146. Data generation, parsing, reference implementations. | Implement deterministic CSV generation and a scalar Haversine processor. Extra: compare array-of-structs with separate coordinate arrays without making a speed claim yet. |
| **5** | CE Prologue “SIMD,” “Caching,” and “Python Revisited”; HH 010, 112–113. Measurement as an experiment. | **Project 1:** Deliver a validated scalar `geolab` baseline, input fixtures, a repeatable timing protocol, and a report that separates correctness, prediction, observation, and uncertainty. Extra: estimate bytes processed per point. |

### Weeks 6–12: Instructions, a small simulator, and reading assembly

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **6** | CE Part 1 “Instruction Decoding on the 8086,” “Decoding Multiple Instructions and Suffixes,” “Opcode Patterns.” Instruction encoding and registers. | Start a C decoder for a specified 8086 subset. Extra: hand-decode five byte sequences and compare. |
| **7** | CE Part 1 “8086 Decoder Code Review” and “Using the Reference Decoder as a Shared Library”; HH Chat 013. Translation units and decoder architecture. | Add ModR/M and displacement decoding; expose a documented C decoder API. Extra: round-trip canonical printed forms where possible. |
| **8** | CE Part 1 “Simulating Non-memory MOVs,” “Simulating ADD, SUB, and CMP.” State transitions and flags. | Add register-state simulation and arithmetic; test signed and unsigned flag cases. Extra: differential tests against a trusted decoder's output. |
| **9** | CE Part 1 “Simulating Conditional Jumps,” “Simulating Memory.” Control flow and address calculation. | Simulate branches and a bounded memory array. Extra: show a loop that terminates for one flag interpretation but not another. |
| **10** | CE Part 1 “Simulating Real Programs,” “Other Common Instructions,” “The Stack”; HH Chat 013. Stack discipline, calls, returns, and lifetimes. | Add push/pop and a tiny call/return example. Draw stack-pointer changes and distinguish the architectural stack from C storage duration. |
| **11** | CE Part 1 “Estimating Cycles” and “From 8086 to x64”; HH Chat 020. ABI, generated x64 assembly, return prediction. | Compare debug and optimized `geolab` functions against the System V ABI. Write at most one **10–20-line assembly probe**; all simulator code remains C. Extra: identify an optimized-away local. |
| **12** | CE Part 1 “8086 Simulation Code Review”; revisit HH Chat 011. The gap between an ISA model and a modern microarchitecture. | **Project 2:** Complete the specified C 8086 decoder/simulator subset with golden byte-stream tests, state traces, and a short comparison to x64 disassembly. |

### Weeks 13–20: Profiling, allocation, and virtual memory

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **13** | CE Part 2 “Introduction to RDTSC” and “How does QueryPerformanceCounter measure time?”; HH 010, 113. Wall time versus timestamp counters. | Build a Linux C timing harness using a monotonic clock; add an x86 counter experiment with its limitations documented. |
| **14** | CE Part 2 instrumentation, nested/recursive profiling, profiling overhead, and timer comparison; HH 177–178. Measurement changes the measured program. | Implement nested event timing in C and quantify its overhead. Extra: compare inclusive and exclusive time. |
| **15** | HH 231–234; CE Part 3 “Repetition Testing.” Complexity versus measured cost. | Implement insertion, merge, and radix sorting for integer keys, test correctness, and predict crossover behavior. Extra: memory-cost comparison. |
| **16** | CE Part 1 “The Stack”; HH 014, 157. Storage duration, stack frames, heap allocator contracts. | Trace local, static, and `malloc` objects through calls; write a lifetime diagram and repair supplied invalid-lifetime examples with diagnostics. |
| **17** | HH 305, 342. Arena and temporary allocation. | Implement a bounded bump arena with marks and resets. Extra: measure the effect of allocation pattern in a point-query workload. |
| **18** | HH 160–161, 216. Free lists, fragmentation, on-demand deallocation. | Implement a teaching free-list allocator over a fixed buffer; test split, coalesce, exhaustion, alignment, and reuse. |
| **19** | CE Part 3 “Page Faults,” “Probing OS Page Fault Behavior,” “Four-Level Paging,” “Analyzing Page Fault Anomalies”; HH 343–346. Virtual addresses, mapping, protection, first touch. | Use C `mmap`/`mprotect` experiments and OS fault counts. Extra: compare reserved, committed, and touched pages without treating virtual addresses as physical addresses. |
| **20** | CE Part 3 “Powerful Page Mapping Techniques,” “Faster Reads with Large Page Allocations”; HH 539, 542. Allocator observability. | **Project 3:** Deliver arena/free-list allocators, an allocation trace, page-behavior experiments, correctness tests, and a report distinguishing language lifetime, allocator behavior, and OS mapping. |

### Weeks 21–27: Data movement and the CPU front end

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **21** | CE Part 3 “Measuring Data Throughput,” “Repetition Testing,” “Monitoring OS Performance Counters”; HH 112–113. Bandwidth and repeatability. | Measure sequential copy/read/write throughput over changing sizes. Extra: compare wall time with available counters and explain disagreement. |
| **22** | CE Part 3 cache size, bandwidth, non-power-of-two tests, and cache sets; HH Chat 017. Cache lines, sets, working sets. | Run stride and working-set sweeps with a C harness; produce and interpret plots without assuming one fixed cache threshold. |
| **23** | CE Part 3 “Inspecting Loop Assembly”; HH 055, 057, 064, 079, 663, 666. Locality, indirection, packed storage. | Represent points as nodes, array-of-structs, and struct-of-arrays; compare identical queries and inspect generated loops. |
| **24** | CE Part 3 “Unaligned Load Penalties,” “Non-Temporal Stores,” “Prefetching,” “Prefetching Wrap-up”; HH Chat 017. Alignment and memory traffic. | Test aligned/misaligned streams and optional prefetch/store variants. Extra: explain a case where the “optimized” variant loses. |
| **25** | CE Part 3 memory-mapped files, “2x Faster File Reads,” “Overlapping File Reads with Computation,” and mapped-file testing; HH 353 as a later compression preview. | Add a checked binary point format and compare buffered reading with `mmap`. Extra: overlap chunk reading and processing without losing deterministic results. |
| **26** | CE Part 3 “Intuiting Latency and Throughput,” “Analyzing Dependency Chains,” and loop assembly; HH 177. | **Project 4:** Deliver a memory-bound point loader/query path, benchmark harness, measured throughput bounds, and an explanation of each major data movement. |
| **27** | CE Part 3 “CPU Front End Basics,” “Branch Prediction,” “Code Alignment”; HH Chat 020. Decode, branches, loop behavior. | Compare predictable and unpredictable predicates in an otherwise identical C loop; inspect branch and branchless forms. Discuss loop caches as architecture-specific, not a C guarantee. |

### Weeks 28–35: Micro-operations, SIMD, and mathematical computation

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **28** | CE Part 3 “The RAT and the Register File,” “Execution Ports and the Scheduler”; HH 112 and Chat 020. Renaming and throughput limits. | Construct independent versus dependent integer kernels; predict and measure throughput. Extra: map a short disassembly to candidate execution resources. |
| **29** | CE Part 3 “Latency and Throughput, Again”; Part 5 “Reading CPU Diagrams” and “How to Use uops.info.” | Analyze one `geolab` hot loop using assembly, a CPU diagram, and measured timings. Extra: distinguish architectural instructions from micro-operations. |
| **30** | CE Part 5 “Our Very Own Haversine,” “Removing Waste,” “Simplified Haversine Candidate,” optimization-prevention and dead-code-elimination entries; HH 146. | Remove redundant scalar work while retaining exact tests. Demonstrate an invalid benchmark eliminated by the compiler, then repair the harness. |
| **31** | CE Part 3 “Increasing Read Bandwidth with SIMD Instructions”; Part 5 “Three Steps from Scalar to SIMD”; HH 115–116, 119. **Vectorization:** scalar loops, compiler autovectorization, explicit SIMD, lane width, and tails. | Implement one integer filter/reduction in three forms: scalar with vectorization disabled, compiler-vectorized, and SSE2 intrinsics with a scalar remainder. Inspect vectorization diagnostics and assembly; explain when the compiler succeeds or declines. |
| **32** | CE Part 5 “Branchless Absolute Value,” “SIMD Predicates,” “SIMD Masking,” “SIMD Mask Registers”; HH Ray 03. **Vectorization of control flow:** predicates, masks, compaction, and divergence. | Implement predicate masks and compaction on supported hardware, with a scalar fallback. Test odd-length tails and branch-heavy inputs. Explain the transcript's shader/SIMT comparison conceptually using a C lane-mask model; no shader code is required. |
| **33** | CE Part 4 reference Haversine, non-inlined functions, input ranges, SSE introduction, function approximation, range reduction; HH 440. | Specify a bounded-domain approximation for one math function and test its error against `libm`. Extra: find worst cases near range boundaries. |
| **34** | CE Part 4 higher-power polynomials, Horner's rule, FMA, coefficient arrays, arcsine and full-range extension; HH 440. | Implement and compare polynomial evaluation orders; produce an accuracy/performance table and document fallback outside the validated domain. |
| **35** | CE Part 5 dependency-chain stalls, in-order and block interleaving; revisit HH 115–119 and Ray 03. | **Project 5:** Deliver scalar, compiler-vectorized, and explicit-SIMD distance/filter paths with feature detection, numerical error tests, compiler reports, assembly evidence, and a defensible performance report. Explain each vectorization success or blocker. No speedup is required for a passing result. |

### Weeks 36–42: Threads, atomics, and synchronization

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **36** | CE Prologue “Multithreading”; HH 122 and Ray 01. Processes, OS threads, scheduling, joins. | Partition independent point queries across POSIX threads; compare thread counts and chunk sizes. |
| **37** | HH 350–351; revisit CE caching and multithreading. Ownership of output, reduction, false sharing. | Compare per-thread result buffers with adjacent shared counters; explain scaling and contention. |
| **38** | HH 123–124. C11 atomics, data races, visibility, acquire/release. | Build a correct publish/consume example with atomics; compare thread-local aggregation and a contended atomic counter. Unsafe examples remain diagnostic fixtures, never accepted implementations. |
| **39** | HH 166, 325. Mutexes, condition variables, semaphores, ticket-lock tradeoffs. | Build a bounded producer/consumer buffer first with a mutex and condition variables. Extra: a teaching ticket lock with explicit limits and stress tests. |
| **40** | HH 125–126. FIFO work queues and completion. | Add a small fixed-worker queue to `geolab`; specify shutdown and ownership behavior. Extra: compare queue overhead against direct chunk partitioning. |
| **41** | HH 178 and CE Part 2 nested profiling. Concurrent measurement. | Make profiling thread-aware without placing one contended global counter on every event. Extra: inspect skew introduced by instrumentation. |
| **42** | HH 350–351 and Ray 01; CE Prologue “Multithreading” revisited. | **Project 6:** Deliver a correct parallel query engine, worker queue, race-focused stress tests, scaling plots, and an explanation of atomics, locking, false sharing, and overhead. |

### Weeks 43–48: Algorithms and representations for the final engine

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **43** | HH 045, 055, 057, 309–310, 449; CE Part 3 cache/data-throughput entries revisited. Spatial hashing and grid partitioning. | Build a grid index and compare full scan versus bounded candidate search; include correctness checks at cell boundaries. |
| **44** | HH 298–299, 302–308, 311, 315, 521–522; CE Part 5 dependency-chain entries revisited. Sort keys, partial orders, graph traversal, cycle detection. | Build a stable result-ordering and dependency-graph exercise in C. Extra: exhibit an ordering relation that cannot be reduced to one scalar key. |
| **45** | HH 595–597, 615, 633; CE Part 3 cache entries revisited. Tree traversal versus grid traversal. | Add a k-d tree index and compare candidate count, memory layout, build cost, and query cost with the grid. |
| **46** | HH 353–354, 454–455 and HandmadeCon “Compression”/“Compression Followup”; CE Part 3 file-read entries revisited. Coding, format boundaries, and streaming. | Implement RLE and a small LZ-style teaching codec for point data; parse a bounded binary header. Extra: explain Huffman tables using a separate tiny fixture. |
| **47** | HH 434, 439, 510 and Ray 02. Pseudorandom generation, entropy tests, parser state. | Replace the dataset generator's PRNG with a specified reproducible generator; build a checked streaming CSV parser and malformed-input tests. |
| **48** | HH 286, 474, 489, 575 and “The Thirty-Million Line Problem”; revisit CE Prologue “Waste.” Interfaces, state restoration, and complexity control. | **Project 7:** Integrate indexes, compressed input, parser, and deterministic tests. Add a checkpoint/restore or undo operation for index construction; document which abstractions reduce complexity and which conceal costs. |

### Weeks 49–52: Integrated capstone and transfer

| Week | Reading and mechanism | C assignment; practice extension |
| --- | --- | --- |
| **49** | Revisit transcript, `solPlan.md`, `analysis.md`, CE Prologue, HH 112. Re-state predictions before optimization. | Freeze the capstone's CLI, input formats, correctness oracle, benchmark datasets, and performance questions. Submit an architecture diagram from C objects down to files, pages, caches, and threads. |
| **50** | Revisit CE Part 3 and HH 160–161, 309–310, 595–597. | Integrate allocator, binary/mapped input, grid and k-d tree paths. Profile end-to-end workloads and repair the largest demonstrated bottleneck. |
| **51** | Revisit CE Parts 4–5, HH 115–126 and Ray 03. | Integrate SIMD and threaded execution with feature-gated fallbacks. Produce numerical-error, concurrency-stress, and cross-compiler results. |
| **52** | Revisit the transcript's “extend down” discussion, CE “Python Revisited,” and relevant HH Chat lessons. | Deliver `geolab`, full test suite, reproducible benchmark report, and a defense of five causal predictions. Explain conceptually how a managed runtime or coroutine API would express the work and which lower mechanisms the C course made visible; authored comparison code remains C-only. |

## Verification and acceptance

- **Every week exists and is usable:** 52 numbered learner packages and 52 separate full solution packages; every package includes the weekly fields above, direct resource links, runnable C, tests, practice, and stretch work. An automated prompt-to-answer inventory must find an answer-key entry for every numbered learner-facing request, including optional work.
- **Every section project builds on prior work:** Checkpoints 1–7 have versioned requirements, tests, complete reference implementations, and model written reports/defenses. The final CLI handles empty, malformed, boundary-coordinate, large-input, unsupported-SIMD, and varying-thread-count cases.
- **Technical accuracy:** Mark whether a claim comes from C11, POSIX/Linux, the x86 ISA, the ABI, the compiler, or a measured machine. Do not assert that a C local necessarily becomes a stack push, that all objects are “stack or heap,” or that a C data race has predictable behavior.
- **Measurement quality:** Record hardware, OS, compiler, flags, dataset, warm-up, repetitions, and variation. Require correctness before benchmarking. Treat performance counters and privileged tooling as optional observations with a non-privileged fallback.
- **Build checks:** Compile reference solutions with GCC and Clang using strict warnings; run correctness fixtures and supported sanitizers. SIMD builds retain a baseline path and never execute unsupported instructions. Threaded tests check deterministic output and termination.
- **Source and rights checks:** Verify every HH and CE direct link. Link paid CE entries without reproducing their transcripts, videos, or homework. Use the official TOC's current Part 5 entries as the fixed syllabus snapshot; later CE additions do not silently change the 52-week plan.

**Implementation order:** Establish the shared C build/test harness and data fixtures; author weeks in order, completing and testing each checkpoint before proceeding.

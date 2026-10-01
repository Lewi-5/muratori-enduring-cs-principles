# Checkpoint 2 acceptance and submission manifest

Deliver one independently buildable C package in week-12. Preserve the exact project.h contracts or document a compatible source implementation. Do not broaden the ISA or silently change predecessor policies. The API is a source contract for this course, not a promised binary ABI for arbitrary headers/toolchains.

## Required evidence

| Artifact | Acceptance |
| --- | --- |
| E01–E04 C | Prepared immutable code, complete subset execution, atomic run and trace; default learner sources own these functions |
| E05/R01–R05 | Predictions, actual outputs, compiler manifests, explanations and limits |
| Three fixtures | main call/loop/memory trace; wrapping little-endian word; original PUSH SP trace, each with independent expected values |
| Errors | Truncation/unsupported suffix, bad target/return, stack exhaustion, budget, capacity, invalid initial IP; all required outputs remain unchanged |
| C validity | No host signed overflow, dangling code image, out-of-bounds wrapped load or pointer punning |
| Toolchains | GCC/Clang debug, optimized and address/undefined sanitizer configurations; meaningful starter failures |
| Modern comparison | Two actual source/listing subjects, ABI mapping, debug/optimized difference, relocation interpretation and timing limits |
| Model defense | Explicit distinction between ISA effects, course policies, C semantics, ABI, compiler choices and microarchitecture |

## Submit a manifest

List compiler versions and target, exact commands/flags, source revision or hashes, fixture names, logs and actual workload. Include final state and tentative error counts, not only screenshots or “tests pass.” All arrays and the stack-window initial state must be reproducible. Explain how expected values were obtained separately from the implementation. A comparison sharing pinned helper code is regression evidence; it is not an independent physical-CPU oracle.

The supplied instructor/report.md is a complete exemplar of the report structure, calculations and an actual x64 comparison. It is not a fictional learner pilot. Other correct code layouts, test cases and compiler listings earn full credit when they meet the public contracts and explain their evidence. There is no speedup requirement and no mandatory modern instruction count or stack frame.

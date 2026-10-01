# Week 11 rubric

One graded submission includes E01–E05 and R01–R05; warm-ups/reading questions are ungraded preparation. Six practice prompts and optional stretches have full answers. Other correct implementations and compiler listings receive full credit when contracts and explanation hold. No speed threshold applies.

| Criterion | Points | Evidence |
| --- | --- | --- |
| Restricted scalar planner | 20 | Independent pools, source-order spills, entry offsets, alignment, unchanged error output |
| C behavior | 20 | Geolab validation/order, unsigned fold, callback exactly once and preserved pre-call values |
| ABI interpretation | 25 | Argument/result locations, preserved registers, stack before/after prologue, pointer output |
| Actual artifact comparison | 20 | Both compilers, O0/O2, manifests, relocations, optimized-local explanation |
| Limits and report | 15 | ISA/ABI/compiler/prediction separated, complete notebook, actual commands/workload |

A fabricated exact assembly listing, unsupported ABI-generalization or inferred cycle count requires correction. Fewer instructions alone is not proof of faster execution. The optional probe must use defined full-width unsigned behavior, restore RSP and avoid modifying preserved registers. Omitting the optional handwritten probe does not prevent a complete C-only core submission.

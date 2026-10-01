# Notebook exemplar

### R01

For already sorted input insertion compares n−1 times; reversed distinct input compares n(n−1)/2 times. Merge uses approximately n log2(n) work and scratch, while four-byte radix uses four linear scatter passes plus 256-bucket setup each pass. These curves predict eventual behavior under this fixed domain, not one mandatory crossover at a stated n. Preserve the prediction even if observed timings disagree.

### R02

Exemplar evidence: independently generate expected records via qsort on key then original-position tag, compare every key/tag, and separately exercise errors without mutation. Exhaust the 3-valued inputs through length seven, then run odd/even lengths and four shapes up to 257 plus full-width extremes and the capacity boundary. Record actual six-mode results; an all-zero output demonstrates why ordering-only validation fails.

### R03

Report structure: date/host; compiler/version/target and exact make mode; dataset seed and sizes; raw CSV path; timer and resolution; repetitions; one untimed warm-up; copy outside timer; sorting and counters inside; checking/checksum/output outside. The tiny 9,1,5,3 values are a arithmetic fixture, not measured nanoseconds from a sorting workload. Actual sample rows are dated observations.

### R04

Compute each summary over all accepted trials. Minimum shows the most favorable observed trial under this protocol; median helps describe its middle, and mean/max expose slow trials. Scheduler/cache/library state may vary, but the experiment does not identify one cause. Counts are instrumented inside the sort and affect generated code. Report that scope; a separate counter-free experiment would answer a different cost question. No reliable crossover is a valid result.

### R05

On the tested LP64 platform Item contains two uint32_t fields and sizeof(Item) is eight, but use sizeof in portable budgets. Merge/radix need n Items of extra record scratch; radix additionally has two 256-entry size_t tables, while insertion uses one local Item. Original/working copies are benchmark overhead, not sort-internal scratch. Record actual learner times without fabricating a pilot; Week 16 asks who owns and releases these buffers.

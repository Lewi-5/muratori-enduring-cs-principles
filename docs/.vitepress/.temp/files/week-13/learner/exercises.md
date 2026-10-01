# Exercises

Read the public header before coding. All pointer arguments designate accessible storage of the documented size; immutable inputs and disjoint outputs are caller obligations. Error contracts cover valid accessible objects, not arbitrary invalid addresses.

### E01.C

Implement timing_ns, timing_elapsed and timing_monotonic. Follow the complete range, ownership and preservation rules in include/timing.h. Check malformed timespec fields, exactly UINT64_MAX nanoseconds, one more nanosecond, reversed endpoints and equal endpoints. CLOCK_MONOTONIC failure becomes T_CLOCK.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/timing.h.

### E01.Q

Why can consecutive monotonic readings be equal? Distinguish clock resolution, accuracy and read overhead. Does clock_getres establish all three?

### E02.C

Implement timing_measure with an injected ClockSource and Work. Validate all function/output pointers before invoking callbacks. Record start, call work exactly once, record end and publish checksum/delta/AUX. Test failure at each stage and preserved sample output.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/timing.h.

### E02.Q

A late end-reader error occurs after work mutates its context. Which effects survive? Explain why preserving TimeSample does not undo work.

### E03.C

Implement timing_collect and timing_summary for 1..64 samples. Collection publishes the whole array after success. Summaries preserve input, use a lower median, count zero durations and AUX changes, and never narrow a uint64 difference into a comparator result.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/timing.h.

### E03.Q

For raw durations [UINT64_MAX,0,9,2], predict minimum, lower median and maximum. Why keep zero values and long samples?

### E04.C

Implement timing_rate with positive tick and nanosecond intervals. Inspect the supplied CPUID-guarded counter reader. Calculate an empirical ticks/second ratio with floating conversion before multiplication. Run the forced no-counter target.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/timing.h.

### E04.Q

What do the invariant capability bit and equal AUX values establish? What remains unproven by the calibration?

### E05.C

Run playground and bench after completing E01–E04. Capture debug and optimized GCC/Clang builds with tools/measure.py; preserve raw CSV, manifest, checksum, workload size and clock units. Inspect actual objects using make inspect. Write a qualified comparison.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/timing.h.

### E05.Q

Why warm up, batch 32 folds, print after timing and inspect the optimized kernel? Name two remaining sources of variation.

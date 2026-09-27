# Practice and optional stretch

The six practice problems are ungraded preparation for the notebook. The stretch tasks are optional and additional to the core time estimate. Preserve the IDs in your answers. Reason about undefined or invalid operations as text; do not execute them.

### P01

Classify each statement as a portable C11 guarantee, implementation-defined or unspecified behavior, or undefined behavior, and justify each with the clause that supports it: (a) the sequence produced after `srand(1)` is the same on every C implementation; (b) `state * a + c`, computed on a `uint64_t` `state` that overflows, is undefined; (c) `-x` for an `int32_t x` equal to `INT32_MIN` is defined; (d) `printf("%.6f", d)` always writes `.` as the decimal separator; (e) `isdigit(c)` is defined when `c` is a `char` holding a negative value.

### P02

Compute exactly the modulo bias of `r % 3` when `r` is uniform over the 2^32 values `0…2^32 − 1`, and of `r % 3000000000`: which residues occur how many times, the ratio between the most and least likely residues, the threshold used by rejection sampling, and the fraction of raw draws rejected.

### P03

By hand, format `-1`, `999999`, `-90000000` (limit 90000000), `123456789` (limit 180000000) and the record `(7, -5, 10)`. State the buffer size each needs, and which inputs are rejected and why.

### P04

Classify these twelve lines against the canonical grammar, stating for each whether it is accepted and, if not, the first failing status in the specified order: (1) `0,0.000000,0.000000`; (2) `007,1.000000,1.000000`; (3) `12,-0.000000,5.000000`; (4) `12,-0.000001,5.000000`; (5) `12,90.000001,5.000000`; (6) `12,45.5,5.000000`; (7) `12,45.500000,-180.000000`; (8) `12,45.500000,-180.000001`; (9) `12,45.500000,5.000000,`; (10) `12;45.500000;5.000000`; (11) `18446744073709551616,1.000000,1.000000`; (12) `12,100.000000,200.000000`.

### P05

For the loader with the row cap, compute the array size at the cap using the size of `GeoPoint` on the reference platform (from your week-2 inspector; label it as a gated platform observation), the capacity sequence produced by doubling from 1,024 and clamping, and the worst-case memory held at one moment if `realloc` must move the block. Explain the failure path that leaks and its repair.

### P06

Give the standard worst-case bounds for naive, pairwise (blocks of 8) and compensated summation of `n` positive doubles in terms of the unit roundoff `u = 2^-53`, evaluate them for `n = 1,000,000`, and explain why the measured errors are far smaller than the bounds and what the bounds are for.

### S01

Optional: implement `process_points_aos` over `GeoPoint` and `process_points_soa` over separate `lat` and `lon` arrays. Prove by test that the two return bitwise-identical results (they must perform the same operations in the same order), and report the storage per point in each layout (from the week-2 inspector, gated), the number of allocations, and which fields a query needs. **Make no timing, speed or cache claim.** Explain what would have to be measured to compare the layouts fairly, and defer that measurement to weeks 5 and 23.

### S02

Optional: a reproducibility audit. Build the processor and the E07 sums with GCC and Clang at `-O0` and `-O2`, compare the printed results bit for bit, and explain any difference. Optionally, on FMA-capable hardware, rebuild with `-ffp-contract=fast -march=x86-64-v3` (gated; this violates the week's flag rules only inside this labelled experiment) and describe what changes and why: contraction rounds once instead of twice, and some libm variants are chosen at run time. Different valid measurements are accepted, and "no difference observed on this machine" is a valid, cautiously worded outcome.

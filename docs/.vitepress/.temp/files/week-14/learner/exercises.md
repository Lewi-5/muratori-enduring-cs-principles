# Exercises

Read the public header before coding. All pointer arguments designate accessible storage of the documented size; immutable inputs and disjoint outputs are caller obligations. Error contracts cover valid accessible objects, not arbitrary invalid addresses.

### E01.C

Implement profile_begin and profile_end. Zero-initialize each Profile; enforce IDs 0..15, depth<=32, matching top ID and ordered timestamps across all successful events. End charges its inclusive duration to its immediate parent. Preserve the complete state on every failure.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/profile.h.

### E01.Q

A mismatched end has a later timestamp. May it update last? What happens when a subsequent correct end uses an earlier time than the rejected one?

### E02.C

Implement profile_accumulate. Enforce exclusive<=inclusive and checked additions for both totals and hit count. Use synthetic Bucket boundaries to test overflow without corrupting active Profile invariants.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/profile.h.

### E02.Q

Why must all three checks happen before publishing any field? Can a zero-duration invocation increment hits?

### E03.C

Implement profile_report only when depth=0. Include all 16 buckets in ID order; sum exclusive as covered, inclusive separately, hits and used IDs with overflow checks. Same-ID recursion counts every invocation.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/profile.h.

### E03.Q

Derive the playground’s root and recursive totals. Why does inclusive_sum=140 coexist with covered=100?

### E04.C

Implement profile_difference with baseline>0 using floating conversion before subtraction. Run paired baseline/instrumented batches and retain negative observations. Compare granularity with `bench outer` (one hit) and default `bench` (33 hits).

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/profile.h.

### E04.Q

What does a negative difference mean? Why is empty-hook cost not an exact subtraction from every nested interval?

### E05.C

Run all contract, golden and warm-up gates; capture four debug/optimized builds and actual object listings. Submit event protocol, recursion accounting and raw paired measurement manifests. Explain scope cleanup and thread ownership.

Submit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/profile.h.

### E05.Q

Why is the supplied profiler single-threaded per instance? What must a C caller do before an early return?

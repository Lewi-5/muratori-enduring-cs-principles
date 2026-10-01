# Graded assignment

### E01.C

Repair a helper that would return its automatic local by implementing local_value into caller-provided storage. Reject INT_MAX and NULL without modifying output.

### E01.Q

Draw lifetimes of the helper’s local and the caller’s result. Explain why unchanged bytes cannot make a returned-local pointer valid, and why a C local need not occupy a stack slot.

### E02.C

Implement static_next with a process-static uint64_t counter. A valid call increments then stores; NULL must not advance the counter.

### E02.Q

Explain storage duration versus scope. Predict first two calls and process restart; describe reentrancy/thread limitations and why static storage is a poor replacement for every returned object.

### E03.C

Implement owned_copy using the supplied allocator interface. Require an empty destination, check byte-product overflow, deep-copy ints and commit only after allocation succeeds.

### E03.Q

Diagram caller source, owner metadata and separately allocated ints. State who releases, what can be borrowed, and why copying owner metadata does not clone ownership.

### E04.C

Implement owned_resize and owned_release. Resize by allocate/copy/zero-tail/free/commit; equal count does nothing, zero explicitly frees. Preserve the original allocation/data on failure.

### E04.Q

Trace a failed grow, successful grow and release. Identify when old borrows become invalid and explain why allocator provenance cannot be inferred from a pointer’s numeric address.

### E05.C

Run make diagnose for the isolated returned-local, use-after-free and double-free fixtures. Preserve actual diagnostics, map each bug to its reference repair, run correctness checks and complete R01–R05.

### E05.Q

Distinguish compiler warnings, expected sanitizer failures and the clean repaired program. Explain diagnostic limits, ownership leaks, pointer indeterminacy after lifetime end and why testing cannot prove every possible lifetime use safe.

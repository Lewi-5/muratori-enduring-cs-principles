# Practice and stretch

### P01

A pointer to an allocated object is stored in an automatic local. What ends when the function returns, and what remains allocated?

### P02

An Owned struct is assigned to another Owned struct, then both are released. Explain the fault and propose an explicit transfer protocol.

### P03

Why can assigning realloc’s return directly into the only owning pointer leak memory on failure? Explain our allocate-copy-commit repair.

### P04

The owner’s data pointer equals NULL but count equals four. Is that an empty valid owner? Explain what metadata validation can and cannot establish.

### P05

After successful resize, an old alias has the same numeric address as the new buffer. May the program keep using the old alias?

### P06

A static counter works in sequential tests. Explain why that says nothing about concurrent safety or independent caller state.

### S01

Design an explicit Owned move operation with complete preconditions, success/error behavior, tests and ownership diagram. Keep allocator provenance requirements explicit.

### S02

Design a scoped borrow interface that detects stale handles after resize/release without dereferencing freed storage. Give a complete exemplar and limits.

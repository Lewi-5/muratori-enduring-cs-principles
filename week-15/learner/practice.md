# Practice and stretch

### P01

For five reverse-ordered distinct keys, calculate insertion comparisons and record writes under this contract. Contrast five equal keys.

### P02

Explain why checking only that keys are nondecreasing can accept a sort that overwrites every record with zero.

### P03

A merge chooses the right item on equal keys. Give the smallest tagged counterexample and repair the tie decision.

### P04

An LSD radix pass fills each bucket in reverse input order. Give a two-byte counterexample showing lost earlier-digit ordering.

### P05

Explain the difference between a uint32_t numeric byte extracted by a shift and a byte obtained from the object representation. What changes for signed keys?

### P06

Two runs sort random then already-sorted data because the same buffer is reused. Explain how this biases the insertion comparison and repair the protocol.

### S01

Design a controlled comparison of memory cost: caller-supplied scratch versus allocating scratch per operation. Give a complete experiment protocol and memory budget; correctness and no universal speed threshold are required.

### S02

Design a stable hybrid using insertion sort on small runs before merging. Provide a complete threshold-selection protocol and invariant; justify how another machine may choose a different threshold.

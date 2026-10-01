# Reading Answers — spoilers

### F01

The bits 10000000 encode unsigned 128 and signed -128 depending on interpretation; the register bank stores the pattern, not a C signedness tag. CF reports an unsigned carry or subtraction borrow. OF reports an out-of-range mathematical result under signed interpretation. The C host must not invoke signed overflow to model either result. Beej separates representation and type; CS:APP derives the signed range and wrap behavior. The ISA specifies which flags these instructions actually set.

### F02

The shared idea is arithmetic leaving small state bits that later control a decision. CMP here computes subtraction flags and discards the result. ZF alone reports equality; unsigned and signed ordering need CF or SF/OF respectively. Scott builds a different teaching CPU, so its clear-flags instruction and register organization are conceptual preparation, not an 8086 opcode or reset-state specification. CS:APP’s modern condition-code discussion is closer, but Intel remains the authority for our selected instructions and flag effects.

### F03

An ISA describes architectural outcomes: destination patterns, flags and next instruction position. Different implementations can realize those outcomes with different pipelines, internal operations, dependencies and timings. Our simulator has no caches, scheduling, branch predictor or timing model. The architecture text places operations in a design context; Dive Into Systems introduces machine instructions through compiler examples. Neither turns our step count into a cycle count, and observed host runtime is the cost of the C simulator, not elapsed guest hardware cycles.

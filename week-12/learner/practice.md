# Practice and optional stretch

### P01

A CodeImage borrows a local byte array that goes out of scope before project_run. Explain why a still-correct boundary map cannot make the run valid; repair ownership without inventing a universal heap requirement.

### P02

CMP byte 80 against 01 yields 7F. Derive signed/unsigned branch results, then explain why the C implementation cannot use overflowing signed host arithmetic as its guest model.

### P03

Draw main-fixture SP and data bytes after CALL then PUSH AX. Predict return behavior if the saved AX is not popped before RET.

### P04

A trace needs two records but has capacity one. Then the same code encounters a bad taken target. Predict status, count, state and output array for each case and explain precedence.

### P05

Two stores write the same word at FFFF. Predict the numerically ordered first delta and empty second delta. Explain why a trace cannot prove the absence of a store instruction.

### P06

A debug x64 wrapper uses CALL and an optimized wrapper uses an external JMP relocation. Explain the continuation and ABI obligations without claiming the compiler broke the source call.

### S01

Specify a write-event trace that records same-value stores and byte order. Provide a complete written design for instrumentation, capacities, transactions and equivalence with architectural delta traces; no C implementation is required.

### S02

Design a legal experiment comparing prepared versus repeated boundary validation. State correctness gates, timed regions, repeated runs, compiler/CPU metadata, variation and possible conclusions. Do not impose a speedup threshold or estimate x64 cycles from guest instruction count.

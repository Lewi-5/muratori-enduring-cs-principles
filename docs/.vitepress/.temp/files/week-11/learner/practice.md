# Practice and stretch

### P01

A fixed signature is (uint64_t,double,void*,double). Map each argument and the independent pools. State how a double result versus an int result returns.

### P02

Seven scalar integers require one stack slot. Starting with aligned caller RSP, calculate reservation, padding location and seventh argument's callee-entry offset. Track the effect of a later PUSH RBX on that offset.

### P03

An object disassembly prints a CALL operand near the next instruction and a relocation naming sin. Explain why this is not evidence that the function recursively calls itself.

### P04

An optimized leaf uses the red zone without subtracting RSP. Does that violate alignment? Can an ordinary nonleaf use those bytes to retain a value across another call? Explain.

### P05

The source declares doubled but the optimized artifact has no stack slot for it. Explain its C lifetime, observable result and absence of a required physical location.

### P06

Two listings have the same instruction count but different dependency chains and calls. What evidence is missing to compare their time? Explain why neither architectural RET nor instruction count exposes return-predictor accuracy.

### S01

Design a controlled inlining comparison using existing wrapper/support functions. State one compiler change, fixed correctness inputs, assembly evidence and limits. Supply a complete exemplar protocol; no timing improvement is required.

### S02

Analyze why a QueryHit passed by value lies outside our planner's supported types. Use the ABI's aggregate classification rules to give an exemplar boundary mapping for (QueryHit a, QueryHit b), contrasting that with query_hit_compare's pointer arguments. Do not extend the planner by guessing one GP register per struct.

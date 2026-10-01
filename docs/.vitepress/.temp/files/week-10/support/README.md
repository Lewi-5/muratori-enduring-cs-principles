# Completed prerequisites and supplied drivers

`decoder/` is a byte-for-byte snapshot of Week 8's pinned revision-7 decoder (originally completed Week 7 code). `alu/registers.c`, `alu/alu.c` and `alu/sim.h` are byte-for-byte Week 8 reference prerequisites. Only their register and arithmetic functions are linked; obsolete Week 8 sim_step/sim_run declarations in that snapshot header are not this week's API. Use [machine.h](../include/machine.h) for Week 10.

These are supplied completed prerequisites, not Week 10 solutions. `driver.c` and `playground.c` are shared harnesses. All new stack, extension decoding, execution and sequencing work comes from the selected package's four modules. The source pins let this package be built without another agent's unfinished Week 9 files.

# Evidence notebook

### R01

Record predictions of counts and crossover by size/input shape before execution. Explain the expected mechanism rather than inventing a universal winning algorithm.

### R02

Record oracle, stability/permutation evidence, boundary/error cases and compiler/sanitizer results. Include one counterexample to an inadequate ordering-only check.

### R03

Attach actual benchmark CSV, compiler/version/target/flags, timer, reset/warm-up policy and timed scope. Separate deterministic example samples from measured observations.

### R04

Compare min/median/mean/max by algorithm and shape. Explain variability, counter instrumentation and limitations; state whether crossover was observed rather than forcing one.

### R05

Compute extra memory from sizeof(Item), scratch and bucket metadata. Record actual workload and a handoff to Week 16 ownership/lifetime reasoning.

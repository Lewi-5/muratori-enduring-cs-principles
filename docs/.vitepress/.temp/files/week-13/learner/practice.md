# Practice and stretch

Predict before running; these are additional explanations and experiments, not changes to the core API.

### P01

Predict the two seconds fields 18,446,744,073 and 18,446,744,074 with nanos zero. Explain the accepted boundary.

### P02

Hand-sort [10,40,30,20] and compare the playground output. Explain lower versus arithmetic median.

### P03

Inject T_CLOCK on the sixth read of a four-sample collection. Predict callback counts and output.

### P04

Inspect CLOCK_REALTIME, CLOCK_MONOTONIC and process CPU time in the Linux manual. Choose a clock for an elapsed batch that may be preempted.

### P05

Compare work and empty raw intervals. Explain why subtracting their minima is not a proof of exact work cost.

### P06

Find RDTSCP and LFENCE in one optimized object listing. Record source and compiler manifest.

### S01

Design a longer calibration window without busy-waiting on counter ticks. State units, bounds and failure behavior before coding.

### S02

Compare elapsed wall duration with process CPU duration on a workload that sometimes sleeps. Predict and then observe.

# Practice and stretch

Predict before running; these are additional explanations and experiments, not changes to the core API.

### P01

Draw the playground tree and label each invocation separately before combining IDs.

### P02

Predict same-ID recursion at zero duration, then run a test.

### P03

Fill all 32 stack slots, attempt a 33rd begin and compare every byte of valid state.

### P04

Create two nested different IDs from 0 toUINT64_MAX and request a report.

### P05

Compare parent exclusive time with inner workload time in a real run. Explain what each includes.

### P06

Interleave operations on two independent Profile instances. State what this proves about concurrency.

### S01

Design merging completed per-thread reports with overflow checks and labels. Explain why merged covered time may exceed elapsed wall time.

### S02

Extend the supplied outer/nested comparison with an optional intermediate granularity of eight groups of four folds. Record raw paired data.

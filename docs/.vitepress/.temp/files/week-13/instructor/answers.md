# Reference answers (spoilers)

The complete C implementations are in instructor/src; reproduce and explain their results before comparing.

### E01.C

Validate fields first; check seconds <= (UINT64_MAX-nanos)/1000000000 before multiplying. Publish only a local candidate. Reject end<begin before unsigned subtraction. The Linux reader checks its return code, converts a local timespec and commits aux=0.

Code/evidence: [complete clock implementation](src/clock.c).

### E01.Q

Equal readings are allowed when no representable tick separates the reads. Resolution describes representable granularity; accuracy concerns agreement with a reference; overhead is time spent reading. clock_getres reports resolution and does not establish accuracy or overhead.

### E02.C

Use local stamps, checksum and sample. Propagate reader errors; a false work result returns T_WORK without an end read. Checked delta rejects reversal. Only then publish. Context changes and clock-reader effects survive failures; the public sample remains unchanged.

Code/evidence: [complete sample implementation](src/sample.c).

### E02.Q

The work and reader callbacks may have side effects. The library controls only its own output publication. A caller needing reversible work must provide a separate transaction or use an immutable workload; retrying may repeat effects.

### E03.C

Collect into a bounded local array; copy only after all measurements succeed. Sort local uint64 values using comparisons. Select index (n-1)/2. Expected min=0, median=2, max=UINT64_MAX. Callback effects from completed attempts remain visible.

Code/evidence: [complete summary implementation](src/summary.c).

### E03.Q

Zero is an observation, not an automatic error. Long samples can reflect scheduling or other disturbances and should remain inspectable. Filtering requires a stated rule and raw evidence. Summary values do not turn a small sample into a population guarantee.

### E04.C

Convert to double before the multiplication by 1e9. Reject zero intervals and preserve hz on failure. Capability absence returns T_UNSUPPORTED before RDTSCP; monotonic timing continues. LFENCE/RDTSCP/LFENCE and separate compilation are explicit experiment assumptions.

Code/evidence: [complete rate implementation](src/rate.c).

### E04.Q

The bit advertises a counter-rate property, not core frequency or complete VM fidelity. Different AUX values flag a concern; equality cannot prove no migration. The nested windows differ, contain endpoint overhead, and cannot establish globally synchronized counters or elapsed core cycles.

### E05.C

Use the deterministic golden for correctness, then separate real measurement captures. The fold sums IDs 1..512 to 131328; 32 calls produce 4202496. Nine work and empty intervals retain all values; optional counter intervals and calibration are labeled separately. The manifest records hashes and build context.

Code/evidence: [measurement driver](../support/bench.c) and [capture tool](../tools/measure.py).

### E05.Q

Warm-up removes one obvious first-use difference; batching increases useful work per endpoint; output after timing avoids timing terminal I/O. Separate translation units and no LTO keep checksum-dependent calls reviewable. Scheduling, virtualization, cache state and changing machine load still vary; no fixed speedup is required.

### P01

The first is 18,446,744,073,000,000,000 ns and fits; the second exceeds UINT64_MAX. At the first second, nanos 709551615 is the exact maximum.

### P02

Sorted [10,20,30,40] gives lower median 20. An arithmetic middle average 25 is a different statistic and would require its own overflow/rounding rules.

### P03

Three work calls occur; the sixth read is the third end. No samples publish, although the three work effects remain.

### P04

Use CLOCK_MONOTONIC for elapsed duration including scheduling delays while awake. Realtime may jump; process CPU time counts process execution and answers a different question. Linux monotonic excludes suspend.

### P05

Separate intervals see different disturbances and compiler paths. Empty timing diagnoses endpoint scale; subtracting independent minima is an estimate with assumptions, not exact correction.

### P06

The counter object contains fenced endpoint instructions on supported x86 builds; the separate CPUID probe guards availability. A listing shows emitted instructions, not execution ordering on every vendor or guest system.

### S01

Use a monotonic target duration, bounded batches and elapsed checks; enforce a maximum attempt budget. Keep both endpoint windows, AUX and raw timestamps. Longer windows reduce relative endpoint scale but do not prove cross-core synchronization.

### S02

Wall duration includes the awake sleep interval; process CPU time largely omits it. Keep separate units and domains. Sleep scheduling can overshoot; never require exact equality or universal ratios.

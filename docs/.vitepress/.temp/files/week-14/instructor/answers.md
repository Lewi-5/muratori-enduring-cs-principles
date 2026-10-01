# Reference answers (spoilers)

The complete C implementations are in instructor/src; reproduce and explain their results before comparing.

### E01.C

Begin checks arguments, capacity and chronology before pushing. End validates top and order, computes elapsed and self, accumulates on a local Profile copy, charges parent and commits only after all overflow checks. A failed event never advances last.

Code/evidence: [complete events implementation](src/events.c).

### E01.Q

The mismatch commits nothing, including last. A correct end may use an earlier time than the rejected event if it is at least the last successful timestamp. This supports correction of malformed event input; it does not undo program work.

### E02.C

Preflight inclusive+duration, exclusive+self and hits+1 using max-minus-current checks. Publish a local bucket only on success. Equal endpoint times contribute zero time and one hit.

Code/evidence: [complete totals implementation](src/totals.c).

### E02.Q

Updating inclusive before a later hit overflow would leave inconsistent totals. A zero-duration invocation remains an observed event; elapsed precision may be insufficient to distinguish it from zero work.

### E03.C

Root0 spans0..100, with child1 spanning10..40: inclusive 100,self 70. Child1 recursively spans20..30: its two invocations contribute inclusive 30+10=40,self 20+10=30,hits 2. Covered70+30=100; inclusive_sum 140 overlaps.

Code/evidence: [complete report implementation](src/report.c).

### E03.Q

Inclusive counts descendant time again at each ancestor and each recursive invocation. Covered sums self time; with disjoint serialized roots it excludes gaps outside roots. It is not overall process wall time, and inclusive percentages need not sum to 100.

### E04.C

Return (double(instrumented)-double(baseline))/double(baseline). The supplied paired benchmark alternates execution order; each pair performs32 folds and verifies 4202496. Instrumented runs report33 hits; raw times and fractions remain visible.

Code/evidence: [complete overhead implementation](src/overhead.c).

### E04.Q

A negative sample may reflect noise, state, placement or real changes; it is not automatically invalid. Instrumentation changes instructions, memory and scheduling opportunities. Cost depends on depth and placement, so a fixed empty-hook subtraction cannot recover exact uninstrumented time.

### E05.C

Each instance owns mutable stack and totals without locks. Serialize all events to that instance or assign each thread its own Profile and merge completed reports under an explicitly checked policy. C has no automatic destructor here; balance successful begins on each path before publishing.

Code/evidence: [measurement driver](../support/bench.c) and [capture tool](../tools/measure.py).

### E05.Q

Sharing unsynchronized stack mutation would race and mix nesting. Explicit early-return cleanup closes scopes; handling a failed begin must avoid ending a scope that never started. The API does not promise automatic cleanup or shared-instance thread safety.

### P01

Root[0,100], outer1[10,40], inner1[20,30]. Self times70,20,10; ID1 combines the last two.

### P02

Each matched invocation increments hits; inclusive and self remain0. Reusing an ID does not reuse one start timestamp because starts live in stack frames.

### P03

The33rd event returns P_CAPACITY without changing depth, frames, totals or last. End the existing frames in reverse order to recover.

### P04

Each inclusive bucket fits, while their inclusive_sum overflows. The end events succeed; report returns P_OVERFLOW with output preserved. Covered is UINT64_MAX.

### P05

Child intervals include their own endpoint region. Parent self includes gaps, clock reads and profiler bookkeeping outside child boundaries. Neither quantity isolates pure kernel instruction cost.

### P06

Independent storage prevents one instance from corrupting the other in serialized tests. This supports ownership reasoning; it does not test shared-instance races or prove a concurrent execution schedule safe.

### S01

Require depth0 per instance, shared units and a frozen ID mapping; preflight every bucket and aggregate before publishing. Parallel thread intervals overlap in wall time, so summed thread coverage can exceed elapsed wall duration.

### S02

The supplied outer variant has one hit; the nested variant has 33. For an eight-group extension use one outer plus eight inner scopes (nine hits), keeping identical folds/checksums and alternating order, and report manifests. More hooks may increase perturbation; observed differences remain specific to this host and workload.

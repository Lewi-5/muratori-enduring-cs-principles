from pathlib import Path
import json
root=Path(__file__).resolve().parent
def write(path,text):
    p=root/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text.strip()+'\n',encoding='utf-8',newline='\n')
data={
13:{'title':'Clocks and repeatable timing','api':'timing.h','modules':['clock','sample','summary','rate'],'concept':'Wall time versus timestamp counters',
'ex':[
('Normalize a clock reading','Implement timing_ns, timing_elapsed and timing_monotonic. Follow the complete range, ownership and preservation rules in include/timing.h. Check malformed timespec fields, exactly UINT64_MAX nanoseconds, one more nanosecond, reversed endpoints and equal endpoints. CLOCK_MONOTONIC failure becomes T_CLOCK.','Why can consecutive monotonic readings be equal? Distinguish clock resolution, accuracy and read overhead. Does clock_getres establish all three?','Validate fields first; check seconds <= (UINT64_MAX-nanos)/1000000000 before multiplying. Publish only a local candidate. Reject end<begin before unsigned subtraction. The Linux reader checks its return code, converts a local timespec and commits aux=0.','Equal readings are allowed when no representable tick separates the reads. Resolution describes representable granularity; accuracy concerns agreement with a reference; overhead is time spent reading. clock_getres reports resolution and does not establish accuracy or overhead.'),
('Measure one checked unit of work','Implement timing_measure with an injected ClockSource and Work. Validate all function/output pointers before invoking callbacks. Record start, call work exactly once, record end and publish checksum/delta/AUX. Test failure at each stage and preserved sample output.','A late end-reader error occurs after work mutates its context. Which effects survive? Explain why preserving TimeSample does not undo work.','Use local stamps, checksum and sample. Propagate reader errors; a false work result returns T_WORK without an end read. Checked delta rejects reversal. Only then publish. Context changes and clock-reader effects survive failures; the public sample remains unchanged.','The work and reader callbacks may have side effects. The library controls only its own output publication. A caller needing reversible work must provide a separate transaction or use an immutable workload; retrying may repeat effects.'),
('Keep and summarize raw samples','Implement timing_collect and timing_summary for 1..64 samples. Collection publishes the whole array after success. Summaries preserve input, use a lower median, count zero durations and AUX changes, and never narrow a uint64 difference into a comparator result.','For raw durations [UINT64_MAX,0,9,2], predict minimum, lower median and maximum. Why keep zero values and long samples?','Collect into a bounded local array; copy only after all measurements succeed. Sort local uint64 values using comparisons. Select index (n-1)/2. Expected min=0, median=2, max=UINT64_MAX. Callback effects from completed attempts remain visible.','Zero is an observation, not an automatic error. Long samples can reflect scheduling or other disturbances and should remain inspectable. Filtering requires a stated rule and raw evidence. Summary values do not turn a small sample into a population guarantee.'),
('Compare units without inventing cycles','Implement timing_rate with positive tick and nanosecond intervals. Inspect the supplied CPUID-guarded counter reader. Calculate an empirical ticks/second ratio with floating conversion before multiplication. Run the forced no-counter target.','What do the invariant capability bit and equal AUX values establish? What remains unproven by the calibration?','Convert to double before the multiplication by 1e9. Reject zero intervals and preserve hz on failure. Capability absence returns T_UNSUPPORTED before RDTSCP; monotonic timing continues. LFENCE/RDTSCP/LFENCE and separate compilation are explicit experiment assumptions.','The bit advertises a counter-rate property, not core frequency or complete VM fidelity. Different AUX values flag a concern; equality cannot prove no migration. The nested windows differ, contain endpoint overhead, and cannot establish globally synchronized counters or elapsed core cycles.'),
('Deliver a repeatable measurement','Run playground and bench after completing E01–E04. Capture debug and optimized GCC/Clang builds with tools/measure.py; preserve raw CSV, manifest, checksum, workload size and clock units. Inspect actual objects using make inspect. Write a qualified comparison.','Why warm up, batch 32 folds, print after timing and inspect the optimized kernel? Name two remaining sources of variation.','Use the deterministic golden for correctness, then separate real measurement captures. The fold sums IDs 1..512 to 131328; 32 calls produce 4202496. Nine work and empty intervals retain all values; optional counter intervals and calibration are labeled separately. The manifest records hashes and build context.','Warm-up removes one obvious first-use difference; batching increases useful work per endpoint; output after timing avoids timing terminal I/O. Separate translation units and no LTO keep checksum-dependent calls reviewable. Scheduling, virtualization, cache state and changing machine load still vary; no fixed speedup is required.')],
'practice':[
('Predict the two seconds fields 18,446,744,073 and 18,446,744,074 with nanos zero. Explain the accepted boundary.','The first is 18,446,744,073,000,000,000 ns and fits; the second exceeds UINT64_MAX. At the first second, nanos 709551615 is the exact maximum.'),
('Hand-sort [10,40,30,20] and compare the playground output. Explain lower versus arithmetic median.','Sorted [10,20,30,40] gives lower median20. An arithmetic middle average25 is a different statistic and would require its own overflow/rounding rules.'),
('Inject T_CLOCK on the sixth read of a four-sample collection. Predict callback counts and output.','Three work calls occur; the sixth read is the third end. No samples publish, although the three work effects remain.'),
('Inspect CLOCK_REALTIME, CLOCK_MONOTONIC and process CPU time in the Linux manual. Choose a clock for an elapsed batch that may be preempted.','Use CLOCK_MONOTONIC for elapsed duration including scheduling delays while awake. Realtime may jump; process CPU time counts process execution and answers a different question. Linux monotonic excludes suspend.'),
('Compare work and empty raw intervals. Explain why subtracting their minima is not a proof of exact work cost.','Separate intervals see different disturbances and compiler paths. Empty timing diagnoses endpoint scale; subtracting independent minima is an estimate with assumptions, not exact correction.'),
('Find RDTSCP and LFENCE in one optimized object listing. Record source and compiler manifest.','The counter object contains fenced endpoint instructions on supported x86 builds; the separate CPUID probe guards availability. A listing shows emitted instructions, not execution ordering on every vendor or guest system.')],
'stretch':[
('Design a longer calibration window without busy-waiting on counter ticks. State units, bounds and failure behavior before coding.','Use a monotonic target duration, bounded batches and elapsed checks; enforce a maximum attempt budget. Keep both endpoint windows, AUX and raw timestamps. Longer windows reduce relative endpoint scale but do not prove cross-core synchronization.'),
('Compare elapsed wall duration with process CPU duration on a workload that sometimes sleeps. Predict and then observe.','Wall duration includes the awake sleep interval; process CPU time largely omits it. Keep separate units and domains. Sleep scheduling can overshoot; never require exact equality or universal ratios.')],
'warm':[
('w01: convert unsigned seconds plus nanos to nanoseconds; reject nanos>=1e9, overflow and NULL without changing output.','Check seconds against (UINT64_MAX-nanos)/1e9, then publish seconds*1e9+nanos. 1s+2ns yields1000000002.'),
('w02: compute an ordered delta, allowing equality and preserving output on reversal or NULL.','Reject end<begin before subtraction. 9→9 gives0; 9→8 fails and leaves the sentinel.'),
('w03: compute ceil(total/batch) for batch>0 without adding batch-1 to total.','Use total/batch plus one when total%batch is nonzero. UINT64_MAX with batch2 yields UINT64_MAX/2+1.')],
'reading':[
('Explain why Scott’s hardware clock is useful background but cannot specify CLOCK_MONOTONIC.','Scott introduces coordination of hardware operations. The OS exposes an elapsed-time abstraction with its own units, adjustments and failure rules; the Linux manual defines this assignment’s clock.'),
('Compare Beej’s clock() and timespec_get() with the required Linux elapsed timer.','clock() reports processor time in clock_t units; timespec_get(TIME_UTC) supplies calendar-based time. Neither is the specified monotonic elapsed provider. Their representation/conversion lessons still help.'),
('Connect CS:APP program performance and Hennessy/Patterson measurement to counter calibration.','Performance comparisons require a specified workload and metric. An empirical ticks/sec conversion ties one counter to a measured interval; it does not establish core cycles, stability across systems or performance for another workload.')]
},
14:{'title':'Nested and recursive profiling','api':'profile.h','modules':['events','totals','report','overhead'],'concept':'Inclusive time, exclusive time and measurement overhead',
'ex':[
('Track balanced nested events','Implement profile_begin and profile_end. Zero-initialize each Profile; enforce IDs0..15, depth<=32, matching top ID and ordered timestamps across all successful events. End charges its inclusive duration to its immediate parent. Preserve the complete state on every failure.','A mismatched end has a later timestamp. May it update last? What happens when a subsequent correct end uses an earlier time than the rejected one?','Begin checks arguments, capacity and chronology before pushing. End validates top and order, computes elapsed and self, accumulates on a local Profile copy, charges parent and commits only after all overflow checks. A failed event never advances last.','The mismatch commits nothing, including last. A correct end may use an earlier time than the rejected event if it is at least the last successful timestamp. This supports correction of malformed event input; it does not undo program work.'),
('Accumulate without partial totals','Implement profile_accumulate. Enforce exclusive<=inclusive and checked additions for both totals and hit count. Use synthetic Bucket boundaries to test overflow without corrupting active Profile invariants.','Why must all three checks happen before publishing any field? Can a zero-duration invocation increment hits?','Preflight inclusive+duration, exclusive+self and hits+1 using max-minus-current checks. Publish a local bucket only on success. Equal endpoint times contribute zero time and one hit.','Updating inclusive before a later hit overflow would leave inconsistent totals. A zero-duration invocation remains an observed event; elapsed precision may be insufficient to distinguish it from zero work.'),
('Report recursion honestly','Implement profile_report only when depth=0. Include all16 buckets in ID order; sum exclusive as covered, inclusive separately, hits and used IDs with overflow checks. Same-ID recursion counts every invocation.','Derive the playground’s root and recursive totals. Why does inclusive_sum=140 coexist with covered=100?','Root0 spans0..100, with child1 spanning10..40: inclusive100,self70. Child1 recursively spans20..30: its two invocations contribute inclusive30+10=40,self20+10=30,hits2. Covered70+30=100; inclusive_sum140 overlaps.','Inclusive counts descendant time again at each ancestor and each recursive invocation. Covered sums self time; with disjoint serialized roots it excludes gaps outside roots. It is not overall process wall time, and inclusive percentages need not sum to100.'),
('Quantify perturbation','Implement profile_difference with baseline>0 using floating conversion before subtraction. Run paired baseline/instrumented batches and retain negative observations. Compare granularity: one outer scope versus32 inner scopes.','What does a negative difference mean? Why is empty-hook cost not an exact subtraction from every nested interval?','Return (double(instrumented)-double(baseline))/double(baseline). The supplied paired benchmark alternates execution order; each pair performs32 folds and verifies4202496. Instrumented runs report33 hits; raw times and fractions remain visible.','A negative sample may reflect noise, state, placement or real changes; it is not automatically invalid. Instrumentation changes instructions, memory and scheduling opportunities. Cost depends on depth and placement, so a fixed empty-hook subtraction cannot recover exact uninstrumented time.'),
('Deliver a bounded profiler and report','Run all contract, golden and warm-up gates; capture four debug/optimized builds and actual object listings. Submit event protocol, recursion accounting and raw paired measurement manifests. Explain scope cleanup and thread ownership.','Why is the supplied profiler single-threaded per instance? What must a C caller do before an early return?','Each instance owns mutable stack and totals without locks. Serialize all events to that instance or assign each thread its own Profile and merge completed reports under an explicitly checked policy. C has no automatic destructor here; balance successful begins on each path before publishing.','Sharing unsynchronized stack mutation would race and mix nesting. Explicit early-return cleanup closes scopes; handling a failed begin must avoid ending a scope that never started. The API does not promise automatic cleanup or shared-instance thread safety.')],
'practice':[
('Draw the playground tree and label each invocation separately before combining IDs.','Root[0,100], outer1[10,40], inner1[20,30]. Self times70,20,10; ID1 combines the last two.'),
('Predict same-ID recursion at zero duration, then run a test.','Each matched invocation increments hits; inclusive and self remain0. Reusing an ID does not reuse one start timestamp because starts live in stack frames.'),
('Fill all32 stack slots, attempt a33rd begin and compare every byte of valid state.','The33rd event returns P_CAPACITY without changing depth, frames, totals or last. End the existing frames in reverse order to recover.'),
('Create two nested different IDs from0 toUINT64_MAX and request a report.','Each inclusive bucket fits, while their inclusive_sum overflows. The end events succeed; report returns P_OVERFLOW with output preserved. Covered is UINT64_MAX.'),
('Compare parent exclusive time with inner workload time in a real run. Explain what each includes.','Child intervals include their own endpoint region. Parent self includes gaps, clock reads and profiler bookkeeping outside child boundaries. Neither quantity isolates pure kernel instruction cost.'),
('Interleave operations on two independent Profile instances. State what this proves about concurrency.','Independent storage prevents one instance from corrupting the other in serialized tests. This supports ownership reasoning; it does not test shared-instance races or prove a concurrent execution schedule safe.')],
'stretch':[
('Design merging completed per-thread reports with overflow checks and labels. Explain why merged covered time may exceed elapsed wall time.','Require depth0 per instance, shared units and a frozen ID mapping; preflight every bucket and aggregate before publishing. Parallel thread intervals overlap in wall time, so summed thread coverage can exceed elapsed wall duration.'),
('Add an optional outer-only benchmark variant and compare it with32 inner scopes. Record raw paired data.','Keep identical folds/checksums and alternating order, change only scope placement, report hook counts and manifests. More hooks may increase perturbation; observed differences remain specific to this host and workload.')],
'warm':[
('w01: subtract immediate-child time from inclusive time; reject child>inclusive or NULL, preserving self.','Check child<=inclusive before unsigned subtraction. Inclusive100,child30 yields70.'),
('w02: increment a uint64 hit count with checked overflow and preserved output on failure.','Reject UINT64_MAX; otherwise publish old+1. Zero-duration events still use this increment.'),
('w03: compute double(part)/double(whole) for whole>0; allow part>whole and preserve ratio on failure.','Convert before dividing. Part200,whole100 yields2 because inclusive regions can overlap; do not clamp to1.')],
'reading':[
('How do C recursion and profiler stack frames solve different problems?','C call frames support arguments, locals and return control. Profiler frames record ID, start and direct-child elapsed for measurement. Same-ID recursion needs distinct profiler frames even if output later groups by ID.'),
('Connect CS:APP profiling and the CE overhead lessons to scope granularity.','Profiling locates expensive regions but adds work and can change code behavior. Coarse scopes reduce hook count and lose attribution detail; fine scopes add attribution and perturbation. State which tradeoff the measured workload supports.'),
('Explain why UIUC error handling and HP measurement matter to the inclusive-sum overflow example.','The API must report inability to represent a valid overlapping total without publishing a partial report. Measurement definitions must clarify that overlapping inclusive time is not a disjoint wall-time partition; saturation would silently change the quantity.')]
}}
for n,d in data.items():
    base=f'week-{n:02}';title=d['title'];api=d['api']
    intro=f'''# Week {n} · {title}

Complete the typed learner scaffolds before opening the instructor package. Every question is original course work. The exact [API contract](include/{api}) defines units, ownership, failures and bounds. [Exercises](learner/exercises.md), [practice](learner/practice.md), [notebook](learner/observations.md), [warm-ups](learner/warmups.md) and [rubric](rubric.md) define the submission.

## Prerequisites and outcomes

Bring Weeks 1–5 C arrays, checked unsigned arithmetic, compilation and experiment design, plus Week 11 object inspection and Week 12 whole-system evidence. {'Week 13 timing is required; support/clock.c pins its completed monotonic reader so profiling can be implemented independently.' if n==14 else 'The Week 12 simulator remains a correctness checkpoint; this week measures a real C workload rather than guest instruction counts.'}

You will {'convert checked clock readings, retain raw intervals and qualify counter calibration' if n==13 else 'attribute nested and recursive invocations, preserve state on failures and measure instrumentation perturbation'}. Correctness uses injected timestamps; real runs retain variable measurements without numeric pass thresholds.

## Work plan (unpiloted)

| Work | Minutes |
| --- | ---: |
| Assigned viewing and notes | 120 |
| E01–E04 implementation | 200 |
| Tests, warm-ups and practice | 120 |
| E05 measurement and notebook | 100 |
| Review against rubric | 60 |
| Core total | 600 |

Allow an additional 2–4 hours for beginner preparation if needed. These are planning estimates, not validated learner completion times. CE is a subscription resource; linked public pages establish title/runtime and topic, not access to paid episode contents.

## Build, test, inspect and measure

```sh
cd {base}
make
make test
make warmups
make inspect
make CC=clang MODE=optimized inspect
python3 tools/measure.py gcc optimized learner
# Separate reference package, after your attempt:
make verify
```

The default package is learner. Its unfinished typed stubs compile with strict warnings and intentionally fail correctness. Use PACKAGE=instructor for the complete reference. Linux/WSL GCC and Clang are supported; POSIX CLOCK_MONOTONIC is outside ISO C. Debug=-O0, optimized=-O2, sanitize=-O1 with ASan/UBSan. All use C11 and no LTO. Sanitizer times are correctness evidence and are unsuitable for performance comparisons.

`make verify` runs six reference compiler/mode combinations, four actual object inspections, learner scaffold checks, prompt inventory and exact beginner snippets. {'It also compiles/runs TIMING_NO_TSC with both compilers to check capability absence.' if n==13 else 'The profiler requires serialized use of each caller-owned instance; independent threads need independent storage.'}

## Programs and output

`playground` uses fixed timestamps; fixtures/playground.txt is an exact golden. `bench` initializes512 points with IDs1..512, warms the workload, executes32 folds per batch, checks4202496 and prints after measurement. {'Nine samples per clock plus empty monotonic intervals are retained; counter rows appear only when supported. Calibration labels ns, ticks and empirical ticks/sec separately.' if n==13 else 'Nine paired baseline/instrumented batches alternate order. Each instrumented batch has33 completed scopes; CSV fields are pair,index,baseline_ns,instrumented_ns,relative_difference,checksum,covered_ns,hits. NA means a zero baseline.'}

Check exit status, including write failures. No particular duration, counter frequency, slowdown or speedup is required. Capture raw data plus host/build context through tools/measure.py. Inspect manifests and disassembly under build/inspect; observations belong in [your notebook](learner/observations.md).

## Measurement limits

{'Linux monotonic elapsed time includes preemption while awake and excludes suspend; repeated values are allowed. Counter ticks are not core cycles. The optional x86-64 fenced RDTSCP path uses Intel ordering assumptions, advertised user-mode access, CPUID capability and AUX diagnostics. Equal AUX cannot prove no migration. Store visibility, VM fidelity and cross-core synchronization are outside this experiment’s guarantees.' if n==13 else 'Inclusive totals count every invocation, including recursive overlap; self time subtracts only direct children. Covered time sums self across recorded roots and omits unrecorded gaps. Instrumentation changes instructions and memory traffic, so empty-hook subtraction is not an exact restoration of uninstrumented execution.'}

The reference [report](instructor/report.md), [answers](instructor/answers.md), [coverage](instructor/coverage.md) and [validation](instructor/validation.md) are separate spoilers. Primary references: [Linux clock manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html) and [Intel manuals, RDTSCP/LFENCE/CPUID entries](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html). Windows QPC material is a comparison, not the Linux contract.
'''
    write(f'{base}/README.md',intro)
    write(f'{base}/PLAN.md',f'# Week {n} implementation plan\n\n{d["concept"]}. Implement the bounded original APIs in E01–E04, then E05 integrates deterministic evidence and actual timing. Read README for the600-minute unpiloted core allocation and use the website’s explicit viewing portions. Preserve raw observations, claims and limits separately. The predecessor contract is pinned in support; build artifacts are regenerated locally, not hand-authored expected assembly.\n\nAcceptance: six compiler/mode reference gates, four inspect manifests, intentional learner failures, exact snippets,29 matched prompts, raw timing captures and complete separate answers. No performance threshold or universal host-clock assertion is an acceptance condition.')
    prompts='# Exercises\n\nRead the public header before coding. All pointer arguments designate accessible storage of the documented size; immutable inputs and disjoint outputs are caller obligations. Error contracts cover valid accessible objects, not arbitrary invalid addresses.\n'
    answers='# Reference answers (spoilers)\n\nThe complete C implementations are in instructor/src; reproduce and explain their results before comparing.\n'
    for i,(label,contract,question,answer,reason) in enumerate(d['ex'],1):
        prompts+=f'\n### E{i:02}.C\n\n{contract}\n\nSubmit the implementation or E05 evidence, tests and recorded failures. Preserve outputs on failure as required by include/{api}.\n\n### E{i:02}.Q\n\n{question}\n'
        sources=f'[complete {d["modules"][i-1]} implementation](src/{d["modules"][i-1]}.c)' if i<5 else '[measurement driver](../support/bench.c) and [capture tool](../tools/measure.py)'
        answers+=f'\n### E{i:02}.C\n\n{answer}\n\nCode/evidence: {sources}.\n\n### E{i:02}.Q\n\n{reason}\n'
    practice='# Practice and stretch\n\nPredict before running; these are additional explanations and experiments, not changes to the core API.\n'
    for prefix,key in [('P','practice'),('S','stretch')]:
        for i,(q,a) in enumerate(d[key],1):practice+=f'\n### {prefix}{i:02}\n\n{q}\n';answers+=f'\n### {prefix}{i:02}\n\n{a}\n'
    write(f'{base}/learner/exercises.md',prompts);write(f'{base}/learner/practice.md',practice);write(f'{base}/instructor/answers.md',answers)
    obs=[('Record the clock/event model, units, bounds and ownership before running. Include one concrete expected result.','The header defines the bounds and output transaction; the deterministic playground supplies a hand-derivable prediction. Real durations remain unknown until observed.'),('Record one complete failure attempt and compare the required unchanged outputs and surviving effects.','Week13 late clock failure preserves samples but retains completed work. Week14 rejected end preserves the stack, totals and last timestamp. Record the actual gate and sentinels, not just an error label.'),('Capture actual GCC/Clang debug and optimized manifests and identify a relevant emitted instruction or relocation.','Preserve source hashes and exact flags. Week13 counter listing shows fenced RDTSCP; Week14 event listing shows state-copy/accumulation paths. A listing proves emission under that build; no latency follows from line count.'),('Keep raw real measurements, checksum, sample order, host details and summary definition. State one limitation of comparison.','Use tools/measure.py for four captures. Lower median is declared for13; paired relative differences for14 include negative samples. WSL/virtualization and load constrain transfer to other systems.'),('Write a claim supported by this week, a tempting unsupported claim, and the next experiment needed.','Supported: the fixed event/timing contracts pass the checked domains and raw host runs have the recorded values. Unsupported: counterticks equalcorecycles or instrumentation has a universal fixed cost. Next: repeat on specified hardware with a workload and sampling protocol designed for the new claim.')]
    for side in ['learner','instructor']:
        text='# Measurement notebook'+(' exemplar' if side=='instructor' else '')+'\n\nKeep prediction, observation, inference and limitation distinct.\n'
        for i,(q,a) in enumerate(obs,1):text+=f'\n### R{i:02}\n\n{q if side=="learner" else a}\n'
        write(f'{base}/{side}/observations.md',text)
    for key,filename,prefix in [('warm','warmups','W'),('reading','reading-questions','F')]:
        for side in ['learner','instructor']:
            text=f'# {"Warm-ups" if key=="warm" else "Reading questions"}'+(' answers (spoilers)' if side=='instructor' else '')+'\n'
            for i,(q,a) in enumerate(d[key],1):
                text+=f'\n### {prefix}{i:02}\n\n{q if side=="learner" else a}\n'
                if key=='warm':text+=f'\nCode: [w{i:02}.c](src/w{i:02}.c). Check with `make warmups`'+(' using PACKAGE=instructor' if side=='instructor' else '')+'.\n'
            target='reading-answers' if side=='instructor' and key=='reading' else filename
            write(f'{base}/{side}/{target}.md',text)
    write(f'{base}/rubric.md',f'''# Week {n} rubric

| Evidence | Points | Full-credit condition |
| --- | ---: | --- |
| E01 | 15 | Valid ranges, ordered events/endpoints, complete failure preservation |
| E02 | 15 | Checked state publication, callback/hit semantics and boundary cases |
| E03 | 15 | Correct aggregation and overlap/median interpretation; raw inputs retained |
| E04 | 15 | Defined numeric conversion, unsupported/zero cases and qualified units |
| E05 | 15 | Reproducible captures, checksum and actual compiler artifacts |
| Written E questions | 10 | Specific mechanism and correct limitations |
| Practice/notebook | 10 | Predictions and recorded observations for P/R; S optional |
| W/F | 5 | Warm-up gates and source-based reading explanations |

100 points total. Invalid C, silently corrupted outputs, invented timing results or a counter/core-cycle equivalence prevents full credit in the affected item. Variable timing alone never causes failure. Reading access and elapsed learner time are not graded. Submit sources, exact commands/manifests, raw data and completed notebook; exclude generated binaries from review commits.
''')
    write(f'{base}/instructor/coverage.md',f'# Week {n} coverage\n\nAll29 learner IDs have separate answers:10 E contract/reasoning entries,6 P,2 optional S,5 R,3 W and3 F. E01–E04 have complete typed C references; E05 includes a runnable bench/capture tool and report. Warm-ups have independent bounded exhaustive/boundary tests. tests/inventory.py checks ID equality, tests/contracts.c covers deterministic state/error cases, fixtures/playground.txt checks exact output, tests/check.py checks real output structure and checksums without time thresholds. Six compiler/mode gates and forced unsupported-counter gates where relevant distinguish correctness from performance. See validation.md for executed evidence and limits.')
    write(f'{base}/instructor/validation.md',f'# Week {n} validation\n\nExecution record will be filled after the full verification gates. No learner pilot or interactive browser review has been performed.')
    write(f'{base}/instructor/report.md',f'# Week {n} reference report\n\nThe deterministic golden follows the arithmetic in E03. Actual timing captures and assembly observations are recorded below after verification; expected durations are never invented. See README for clock units, workload and limitations.')
    write(f'{base}/tools/measure.py',r'''
"""Capture one reproducible host measurement; never assert a timing threshold."""
from pathlib import Path
import hashlib,json,platform,subprocess,sys
root=Path(__file__).resolve().parents[1]
cc,mode,package=sys.argv[1:] if len(sys.argv)==4 else ('gcc','optimized','learner')
assert cc in ('gcc','clang') and mode in ('debug','optimized') and package in ('learner','instructor')
subprocess.run(['make',f'CC={cc}',f'MODE={mode}',f'PACKAGE={package}','all'],cwd=root,check=True)
exe=root/'build'/package/cc/mode/'bench'
result=subprocess.run([str(exe)],check=True,capture_output=True,text=True)
folder=root/'build/measurements'/package/cc/mode;folder.mkdir(parents=True,exist_ok=True)
(folder/'raw.csv').write_text(result.stdout,encoding='utf-8')
cpu=Path('/proc/cpuinfo').read_text().splitlines()
manifest={'compiler':subprocess.check_output([cc,'--version'],text=True).splitlines()[0],
 'platform':platform.platform(),'machine':platform.machine(), 'cpu':next((x for x in cpu if x.startswith('model name')),'unknown'),
 'package':package,'mode':mode,'command':[str(exe)],'samples':9,'points':512,'folds_per_batch':32,'checksum':4202496,
 'flags':'C11 strict warnings; POSIX 200809; fno-lto; ffp-contract=off; '+('-O0 -g' if mode=='debug' else '-O2 -g'),
 'sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(root.rglob('*')) if p.is_file() and 'build' not in p.relative_to(root).parts and p.suffix in ('.c','.h')},
 'binary_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'raw_sha256':hashlib.sha256(result.stdout.encode()).hexdigest()}
(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print('Captured',folder.relative_to(root))
''')

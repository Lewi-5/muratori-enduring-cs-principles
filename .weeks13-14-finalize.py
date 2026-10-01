from pathlib import Path
import json,re,shutil
root=Path(__file__).resolve().parent
def write(path,text):
    p=root/path;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text.strip()+'\n',encoding='utf-8',newline='\n')
mechanisms={
'ce:introduction-to-rdtsc':'Distinguish timestamp-counter ticks, counter history and empirical calibration from core execution cycles.',
'ce:how-does-queryperformancecounter':'Compare an OS timing interface with its observed underlying source; do not transfer Windows QPC implementation details to Linux.',
'hh:010':'Use seconds/milliseconds dimensional analysis and compare RDTSC with an OS elapsed timer.',
'hh:113':'Place debug counters around work and retain capability, platform and endpoint assumptions.',
'ce:instrumentation-based-profiling':'Place explicit begin/end events to attribute time to recorded regions.',
'ce:profiling-nested-blocks':'Derive parent inclusive time and self time by removing direct-child inclusive durations.',
'ce:profiling-recursive-blocks':'Keep a separate start for every recursive invocation before grouping by ID.',
'ce:a-first-look-at-profiling-overhead':'Measure the extra work introduced by hooks on an unchanged checksummed workload.',
'ce:comparing-the-overhead-of-rdtsc':'Compare timer read costs with stated units and platform assumptions; empty intervals are diagnostic estimates.',
'hh:177':'Connect deferred debug bookkeeping and write bandwidth with where measurement work is charged.',
'hh:178':'Identify enclosing-region accounting and thread ownership issues in profiler reports.'}
registry=json.loads((root/'tools/docs/readings.json').read_text(encoding='utf-8'));catalogue=json.loads((root/'tools/docs/catalogue.json').read_text(encoding='utf-8'))
for n in [13,14]:
    for row in registry['weeks'][str(n)]['crossref']:row['mechanism']=mechanisms[row['muratori']]
    entry=next(c for c in catalogue if c['n']==n)
    for row,reading in zip(registry['weeks'][str(n)]['crossref'],entry['readings']):reading['purpose']=row['mechanism']
write('tools/docs/readings.json',json.dumps(registry,indent=1,ensure_ascii=False));write('tools/docs/catalogue.json',json.dumps(catalogue,indent=2,ensure_ascii=False))
# Improve spacing in prose without modifying shown code, links or identifiers.
replacements={'initializes512':'initializes 512','IDs1..512':'IDs 1..512','executes32':'executes 32','checks4202496':'checks 4202496','has33':'has 33','these16':'these 16','this16':'this 16','defines16':'defines 16','IDs,32':'IDs, 32','at zero':'at zero','all32':'all 32','a33rd':'a 33rd','depth33':'depth 33','depth32':'depth 32','all16':'all 16','for32':'for 32','with32':'with 32','without33':'without 33','with33':'with 33','producing4202496':'producing 4202496','verifies4202496':'verifies 4202496','times32':'times 32','folds512':'folds 512','IDs32':'IDs 32','checks420':'checks 420','median20':'median 20','average25':'average 25','duration30':'duration 30','inclusive100':'inclusive 100','self70':'self 70','inclusive30':'inclusive 30','self20':'self 20','inner10':'inner 10','outer30':'outer 30','hits2':'hits 2','hits1':'hits 1','inclusive40':'inclusive 40','covered100':'covered 100','inclusive_sum140':'inclusive_sum 140','plus300':'plus 300','gives200':'gives 200','timestamp200':'timestamp 200','get200':'get 200','real200':'real 200','are10':'are 10','is20':'is 20','checksum42':'checksum 42','from0':'from 0','to100':'to 100','from10':'from 10','to40':'to 40','from20':'from 20','to30':'to 30','duration is30':'duration is 30','duration is100':'duration is 100','duration is70':'duration is 70','gives130':'gives 130','gives100':'gives 100','overwrite10':'overwrite 10','with20':'with 20','start100':'start 100','end110':'end 110','shows0':'shows 0','with100':'with 100','contains16':'contains 16','IDs0..15':'IDs 0..15','all29':'all 29','All29':'All 29','600-minute':'600-minute','the600':'the 600','entries,6':'entries, 6','S,5':'S, 5','R,3':'R, 3','W and3':'W and 3','scope32':'scope 32','depth=0':'depth=0','sum to100':'sum to 100','exceed100':'exceed 100','sum of512':'sum of 512','inclusive10':'inclusive 10','self10':'self 10','same16':'same 16','part200':'part 200','whole100':'whole 100'}
targets=[p for n in [13,14] for folder in [root/f'week-{n:02}',root/'docs/content/beginners',root/'docs/content/further-reading',root/'docs/content/weeks'] for p in (folder.rglob('*.md') if folder.name==f'week-{n:02}' else [folder/f'week-{n:02}.md']) if p.is_file()]
for p in targets:
    text=p.read_text(encoding='utf-8');parts=re.split(r'(```[\s\S]*?```)',text)
    for i in range(0,len(parts),2):
        for old,new in replacements.items():parts[i]=parts[i].replace(old,new)
    write(p.relative_to(root),''.join(parts))
for n in [13,14]:
    base=f'week-{n:02}';package=root/base
    readme=(package/'README.md').read_text(encoding='utf-8')
    if n==13:
        readme=readme.replace('Nine samples per clock plus empty monotonic intervals','Nine work and empty samples per available clock')
    else:
        readme=readme.replace('Each instrumented batch has 33 completed scopes;','The default nested batch has 33 completed scopes. Run `build/learner/gcc/debug/bench outer` for one outer scope over the same work, or capture it with `python3 tools/measure.py gcc optimized learner outer`;')
        ex=package/'learner/exercises.md';write(ex.relative_to(root),ex.read_text(encoding='utf-8').replace('Compare granularity: one outer scope versus32 inner scopes.','Compare granularity with `bench outer` (one hit) and default `bench` (33 hits).'))
        practice=package/'learner/practice.md';write(practice.relative_to(root),practice.read_text(encoding='utf-8').replace('Add an optional outer-only benchmark variant and compare it with32 inner scopes. Record raw paired data.','Extend the supplied outer/nested comparison with an optional intermediate granularity of eight groups of four folds. Record raw paired data.'))
        answers=package/'instructor/answers.md';write(answers.relative_to(root),answers.read_text(encoding='utf-8').replace('Keep identical folds/checksums and alternating order, change only scope placement, report hook counts and manifests.','The supplied outer variant has one hit; the nested variant has 33. For an eight-group extension use one outer plus eight inner scopes (nine hits), keeping identical folds/checksums and alternating order, and report manifests.'))
    write(f'{base}/README.md',readme)
    report=f'# Week {n} reference report\n\n## Prediction and deterministic observation\n\n'
    report+=('The injected intervals are10,40,30,20, giving min10/lower median20/max40 and four work calls with checksum42. A sixth-read collection failure leaves the complete output unchanged after three tasks have already run. Normalized18,446,744,073 seconds plus709,551,615 ns is exactly UINT64_MAX; one more ns fails.\n\n' if n==13 else 'The fixed tree has root0 [0,100], outer1 [10,40], inner1 [20,30]. Root self70 plus recursive-ID self30 covers100; inclusive100+40=140 counts overlap. Region1 has two hits. Both different-ID UINT64_MAX nested intervals can fit their buckets while the combined inclusive report fails with output unchanged.\n\n')
    report+='The exact playground output is checked against fixtures/playground.txt. The deterministic C tests include10,000 independently calculated conversion cases or three-invocation interval trees, capacity/boundary/error cases and complete failure snapshots. These tests cover the stated domains and are not a proof for every possible program.\n\n## Actual host measurements\n\n'
    table=['| Compiler/mode | Work or baseline median ns | Empty or nested median | Limit/outer observation |','| --- | ---: | ---: | --- |']
    for cc in ['gcc','clang']:
        for mode in ['debug','optimized']:
            folder=package/'build/measurements/instructor'/cc/mode
            manifest=json.loads((folder/'manifest.json').read_text(encoding='utf-8'))
            dest=package/'instructor/evidence'/f'{cc}-{mode}';dest.mkdir(parents=True,exist_ok=True)
            for filename in ['raw.csv','manifest.json']:shutil.copyfile(folder/filename,dest/filename)
            lines=(folder/'raw.csv').read_text().splitlines()
            if n==13:
                summaries={v[1]:v for line in lines if line.startswith('summary,') for v in [line.split(',')]}
                value=summaries['ns'][3];empty=summaries['empty-ns'][3];tick=summaries.get('ticks');et=summaries.get('empty-ticks')
                extra=f'work {tick[3]} ticks; empty {et[3]} ticks' if tick and et else 'counter unavailable'
            else:
                rows=[line.split(',') for line in lines];value=sorted(int(v[2]) for v in rows)[4];empty=sorted(int(v[3]) for v in rows)[4]
                outer=folder/'outer';dest_outer=dest/'outer';dest_outer.mkdir(exist_ok=True)
                for filename in ['raw.csv','manifest.json']:shutil.copyfile(outer/filename,dest_outer/filename)
                ov=[line.split(',') for line in (outer/'raw.csv').read_text().splitlines()]
                extra=f'outer median {sorted(int(v[3]) for v in ov)[4]} ns; separately paired baseline {sorted(int(v[2]) for v in ov)[4]} ns'
            table.append(f'| {cc}/{mode} | {value} | {empty} | {extra} |')
            report+=f'- [{cc}/{mode} raw CSV](evidence/{cc}-{mode}/raw.csv) and [manifest](evidence/{cc}-{mode}/manifest.json)'+(f'; [outer-only CSV](evidence/{cc}-{mode}/outer/raw.csv)' if n==14 else '')+'.\n'
    report+='\n'+ '\n'.join(table)+'\n\n'
    report+=f'Host: `{manifest["platform"]}`; `{manifest["cpu"]}`. GCC/Clang versions and complete source/binary/raw hashes are in each manifest. Workload:512 points,32 folds, checksum4202496. Samples are nine per group, with all raw values retained; comparisons use lower ranked median. These are observations from this host, not goldens or pass thresholds.\n\n'
    report+=('The read-resolution query reported1 ns on the captured host. It does not establish1 ns read cost or accuracy. Work and empty intervals use different code paths. Optional calibration retains ns/tick windows and an empirical ratio; AUX differences are diagnostics, equal AUX is not proof of no migration, and the result is not core execution frequency. The counter reader follows the stated Intel ordering assumptions; synchronization and virtualization remain limits.\n\n' if n==13 else 'Default batches report33 hits and outer batches one hit, with the same result. The profiler copies a complete bounded state on events to guarantee coherent failure behavior; those copies are part of this implementation’s measured perturbation. Nine separately paired observations do not establish a constant per-hook cost. Compare raw paired differences rather than subtracting independent group medians as if they were matched experiments. Covered time omits gaps outside scopes; inclusive totals overlap. Negative observations are valid data.\n\n')
    report+='## Actual emitted code\n\n'
    report+=('The GCC11.4 optimized kernel adds one64-bit ID per iteration and advances the pointer by0x18. Clang14’s optimized kernel emits a four-element unrolled body with loads at offsets0,0x18,0x30,0x48 plus a remainder path. Both debug kernels preserve a more literal loop. The GCC optimized counter object contains LFENCE at0xad, RDTSCP at0xb0 and LFENCE at0xc4 in this capture; both compilers emit the fenced sequence. CPUID remains in the separate capability probe, outside timed intervals.\n\nClang14’s cpuid.h has native AT&T inline assembly incompatible with -masm=intel for source assembly output. The inspection tool keeps native assembly for that one file, explicitly records its syntax, and still emits Intel object disassembly. This is a toolchain observation, not a counter semantic difference.\n\n' if n==13 else 'The GCC11.4 optimized profile_begin reserves0x4a8 stack bytes in the captured object and emits repeated MOVS for state copy/publication. Clang14’s version reserves0x498 and uses its own copy lowering. GCC’s profile_end retains an R_X86_64_PLT32 relocation naming profile_accumulate. Debug artifacts expose local candidate/frame/duration operations more literally. All four manifests record source hashes, compiler, target and exact inspection flags; the copies remain real execution work even though the profiler arithmetic is correct.\n\n')
    report+='Regenerate with `make PACKAGE=instructor CC=gcc MODE=optimized inspect` and the other compiler/mode choices. The relevant artifacts are in `build/instructor/COMPILER/MODE/inspection`. Offsets and instruction choices are observations of these actual objects, not required translations or cycle counts.\n\n## Claim and next experiment\n\n'
    report+=('Supported: the checked harness passes the specified deterministic domains and retains actual raw host measurements with correct checksums. Unsupported: the reported counter ratio equals a core’s current frequency or predicts every workload. A next experiment would choose a longer calibration window, record endpoint assumptions and repeat on a specified nonvirtualized target.\n' if n==13 else 'Supported: the event arithmetic handles nested/recursive invocations under its bounded serialized contract; the captured granularity variants expose actual observer work. Unsupported: instrumentation always costs the same fraction or can be exactly corrected by one subtraction. A next experiment would change placement/depth while preserving work and capture repeated paired observations under stated host conditions.\n')
    write(f'{base}/instructor/report.md',report)
    validation=f'''# Week {n} validation — 2026-10-01

Executed in x86-64 WSL Linux with GCC11.4.0, Clang14.0.0 and Python3.10.12.

- `make verify` passed GCC and Clang debug (-O0), optimized (-O2) and ASan/UBSan (-O1): six complete reference configurations.
- Each ran deterministic contracts,10,000 calculated cases, warm-up boundary/bounded exhaustive gates,29 prompt/answer inventory, exact playground and real measurement structure/checksum checks. `/dev/full` output failure is reported.
- Four actual source assembly/object-disassembly manifests were generated. Inspection results are observations, not instruction-count performance claims.
- Both learner packages compile warning clean and intentionally fail contract, warm-up and playground correctness checks.
- The standalone beginner snippet matched exact source and output with GCC/Clang at O0/O2.
- Four debug/optimized timing captures preserve raw CSV and source/build/host manifests in instructor/evidence. {'Both clocks include empty intervals when the counter is supported. Forced TIMING_NO_TSC GCC/Clang builds passed without executing RDTSCP.' if n==13 else 'Four additional outer-only captures compare one hit with33 nested hits on unchanged work. Negative differences are retained; zero-baseline ratios report NA.'}

Corrections during validation: {'Clang14’s native CPUID inline assembly required native syntax for the counter source listing; object disassembly remains Intel syntax.' if n==13 else 'The pinned timing header excludes Week13 warm-up declarations to avoid conflicting independent Week14 warm-up names.'}

Course citation, snippet and documentation checks are recorded in docs/VALIDATION.md. No learner pilot, universal duration/frequency/slowdown, cross-core synchronization, shared-instance thread safety or interactive browser review is claimed. Compiler/runtime checks cover executed domains and do not prove all-input correctness.
'''
    write(f'{base}/instructor/validation.md',validation)
# Final readability pass for the newly written reports as well.
for n in [13,14]:
    for p in (root/f'week-{n:02}/instructor').glob('*.md'):
        t=p.read_text(encoding='utf-8')
        for old,new in {**replacements,'include10':'include 10','GCC11':'GCC 11','Clang14':'Clang 14','Python3':'Python 3','contracts,10':'contracts, 10','gates,29':'gates, 29','with33':'with 33','Workload:512':'Workload: 512','points,32':'points, 32','checksum420':'checksum 420','reported1':'reported 1','establish1':'establish 1','one64':'one 64','by0x':'by 0x','at0x':'at 0x','offsets0':'offsets 0','reserves0x':'reserves 0x','four128':'four 128','Week13':'Week 13','Week14':'Week 14','are10':'are 10','min10':'min 10','max40':'max 40','median20':'median 20','Normalized18':'Normalized 18','plus709':'plus 709','self70':'self 70','self30':'self 30','covers100':'covers 100'}.items():t=t.replace(old,new)
        write(p.relative_to(root),t)
files=set(json.loads((root/'tools/docs/files.json').read_text(encoding='utf-8')))
for n in [13,14]:files.update(p.relative_to(root).as_posix() for p in (root/f'week-{n:02}').rglob('*') if p.is_file() and 'build' not in p.relative_to(root).parts and '__pycache__' not in p.parts)
write('tools/docs/files.json',json.dumps(sorted(files),indent=2))

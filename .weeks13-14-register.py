exec(open('.weeks13-14-materials.py',encoding='utf-8').read().split('for n,d in data.items():')[0])
registry=json.loads((root/'tools/docs/readings.json').read_text(encoding='utf-8'))
catalogue=json.loads((root/'tools/docs/catalogue.json').read_text(encoding='utf-8'))
ce=[('ce:introduction-to-rdtsc','introduction-to-rdtsc','Full,48:05'),('ce:how-does-queryperformancecounter','how-does-queryperformancecounter','Full,31:43'),('ce:instrumentation-based-profiling','instrumentation-based-profiling','Full,18:01'),('ce:profiling-nested-blocks','profiling-nested-blocks','Full,26:12'),('ce:profiling-recursive-blocks','profiling-recursive-blocks','Full,30:44'),('ce:a-first-look-at-profiling-overhead','a-first-look-at-profiling-overhead','Full,18:37'),('ce:comparing-the-overhead-of-rdtsc','comparing-the-overhead-of-rdtsc-and','Full,13:00')]
portions={mid:portion.replace(',',', ') for mid,slug,portion in ce}
for mid,slug,portion in ce:registry['muratori'][mid]['url']='https://www.computerenhance.com/p/'+slug
portions.update({'hh:010':'3:49–7:40 and 26:32–31:13 (8:32)','hh:113':'8:45–13:52 (5:07)','hh:177':'19:14–23:46 (4:32)','hh:178':'31:59–35:00 (3:01)'})
refs13=[('bhdik:the-clock','Separate physical coordination from an OS elapsed-time contract.'),('bhdik:speed','Ask what a speed statement measures.'),('bgc:38.5','Read timespec representation while distinguishing TIME_UTC from monotonic elapsed time.'),('bgc:23.7','Pass an injected clock/work function with caller-owned context.'),('bgc:14.1','Check unsigned range before converting and subtracting.'),('bgclr:29.7','Compare C calendar-time return conventions, not a monotonic guarantee.'),('bgclr:29.2','Contrast processor time with elapsed wall time.'),('dis:17.10','Choose a clock and record a reproducible timing context.'),('cs341:3.5.1','Propagate read/work failures with explicit outputs.'),('cs341:2.4.3','Use sanitizers as checked-domain evidence, not speed data.'),('csapp:5.2','Define the workload and performance metric.'),('hp:1.8','Keep summary definitions and comparison context.'),('hp:1.11','Qualify conclusions from a noisy or mismatched metric.')]
refs14=[('bhdik:step-by-step','Trace one invocation before grouping recursive IDs.'),('bhdik:speed','Distinguish work performed from an attributed duration.'),('bgc:13','Connect lexical scope with explicit profiler lifetime, including early returns.'),('bgc:6.4','Bound the active-frame array.'),('bgc:14.1','Preflight unsigned accumulation and subtraction.'),('bgclr:26.1','Understand disjoint snapshot copying and object access.'),('dis:11.5','Compare instrumentation with cache-analysis tools and their metrics.'),('dis:17.10','Use checked elapsed endpoints for each event.'),('cs341:3.5.1','Keep state/report coherent on errors.'),('cs341:6.5','Explain why unsynchronized shared instance mutation races.'),('csapp:5.14.1','Use profiling to locate regions and qualify overhead.'),('csapp:5.14.2','Read profiler evidence with the tool’s attribution definitions.'),('hp:1.8','Specify paired workloads and raw measurements.'),('hp:1.11','Avoid treating an observed slowdown as a universal constant.')]
for n,refs in [(13,refs13),(14,refs14)]:
    d=data[n];slug=f'week-{n:02}';week=registry['weeks'][str(n)];week['status']='complete';week['mechanism']=d['concept']
    for row in week['crossref']:
        row['portion']=portions[row['muratori']];row['mechanism']=d['concept']+'; compare the source example with the local contract.'
        row['sections']=[{'id':sid,'why':why} for sid,why in refs]
        row['gap']=('These companions provide representation, timing and comparison concepts, but do not specify Linux CLOCK_MONOTONIC, exact CPUID bits, Intel RDTSCP/LFENCE ordering, AUX interpretation, VM synchronization, the bounded callback transaction or the lower-median policy. Read the linked primary manuals and local header. Windows QPC implementations are source-specific comparisons.' if n==13 else 'These companions discuss C state, profiling and measurement, but do not define this16-ID/32-frame event protocol, all-invocation recursive inclusive aggregation, complete failure transaction, closed-report requirement or paired33-hit benchmark. The local header defines those policies. Windows debug-system examples are context, not a shared-instance concurrency guarantee.').replace('this16','this 16').replace('paired33','paired 33')
    week['extra']=[]
    readings=[{'resource':f'[{registry["muratori"][row["muratori"]]["title"]}]({registry["muratori"][row["muratori"]]["url"]})','portion':row['portion'],'purpose':row['mechanism']} for row in week['crossref']]
    readings.extend([{'resource':'[Linux clock_gettime manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html)','portion':'Clock IDs, return values and notes; reference during E01/E05','purpose':'Define the required Linux elapsed clock; resolution is not overhead.'},{'resource':'[Intel architecture manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)','portion':'RDTSCP, LFENCE and CPUID instruction entries; reference','purpose':'Qualify optional counter support and ordering assumptions.'}])
    ex={}
    for i,(label,contract,q,a,reason) in enumerate(d['ex'],1):
        ex[f'E{i:02}']={'title':label,'why':q,'prerequisites':'C checked arithmetic, arrays and status handling; '+('Week 13 clocks' if n==14 else 'Week 12 evidence'),'predict':q,'steps':contract,'hint':a.split('.')[0]+'.','evidence':'Compare deterministic expected outputs, failure preservation, actual compiler artifacts and qualified raw timing observations.','sources':[f'{slug}/learner/src/{d["modules"][i-1]}.c'] if i<5 else [f'{slug}/support/bench.c',f'{slug}/tools/measure.py']}
    entry={'n':n,'title':d['title'],'slug':slug,'promptFiles':[f'{slug}/learner/{f}.md' for f in ['exercises','practice','observations','warmups','reading-questions']], 'answerFiles':[f'{slug}/instructor/{f}.md' for f in ['answers','observations','warmups','reading-answers']], 'readings':readings,'companion':[{'title':registry['sections'][sid]['title'],'url':registry['sections'][sid]['url']} for sid in (['bgc:38.5','bgc:23.7'] if n==13 else ['bgc:13','bgc:6.4'])],'exercises':ex,'guidance':{f'{p}{i:02}':'Preserve your prediction, record actual evidence and state the clock/accounting limits.' for p,count in [('P',6),('S',2),('R',5)] for i in range(1,count+1)}}
    catalogue=[c for c in catalogue if c['n']!=n]+[entry]
    reading='''## How to read this ladder

Start with the concrete problem, then choose one text at a time. The section/page table below is generated from the verified registry: printed labels and PDF page positions are different coordinates. Local copyrighted PDFs are not published by the site. Online references remain linked to their authors. You do not need to read every section in every book during the required viewing budget; deeper rungs are optional support for a question you cannot yet explain.

The CE public pages verify titles, runtime and topic. Paid episodes remain subscription resources; this package supplies original exercises and does not claim to reproduce their implementation. The Handmade Hero portions are selected from the official indexed chapters. Their Windows code provides comparison context; the local Linux API and explicit course policy determine the assignment.

'''
    if n==13:
        reading+='''### 1 · Scott: what is ticking?

You hear “clock” used for both a processor’s coordination signal and a software elapsed-time reading. Start with *The Clock* and *Speed* to understand coordinated work before interpreting a timestamp. Follow one operation through the simple machine, then ask which physical beat is being discussed. This rung requires no C and is the best place to recover intuition if counters feel like unexplained large integers.

The limit matters: Scott’s teaching machine does not specify CLOCK_MONOTONIC or today’s invariant TSC. A physical clock story cannot establish the units, adjustment policy or cross-core behavior of an operating-system interface. Write that gap before moving to the C representation. F01 checks whether you can retain the useful intuition while naming the missing contract.

### 2 · Beej C: represent a reading and call a reader

Use §38.5 for the seconds/nanoseconds representation, §14.1 for unsigned ranges and §23.7 when callbacks become confusing. Begin with one local timespec conversion. Then trace how ClockSource passes both a function pointer and its caller-owned context. A callback is ordinary code invoked through a stored function address; the context gives it access to a position or work counter without hidden globals.

The difficult step is mixing representation with guarantees. Beej’s timespec_get discussion uses ISO C calendar time, not the required POSIX monotonic timer. Reuse its explanation of fields and return checks while keeping the providers distinct. For overflow, derive the maximum allowable seconds before multiplying; a cast alone cannot restore a value that already overflowed.

### 3 · Beej library: compare return contracts

Read the timespec_get and clock entries as reference pages, not as alternate implementations of E01. Identify the return value indicating success, the output object and the advertised unit. clock measures processor time; timespec_get with TIME_UTC concerns calendar-based time. Neither should silently replace monotonic elapsed endpoints.

Write a small comparison table containing metric, domain and failure check before coding. If the reference notation is dense, return to the programming guide’s example and then read just the relevant entry again. F02 asks for this distinction because a plausible number in the wrong domain can make a measurement report misleading without causing a C compiler error.

### 4 · Dive Into Systems: turn readings into an experiment

The Timing appendix bridges C calls and measured execution. Read it after you can compute one checked delta. Ask what belongs inside the interval: allocation, initialization, the actual fold, output, or all of them? Our benchmark states its choice and keeps initialization and printing outside the interval.

Its examples help you think about method; they do not supply a universal duration for this host. Keep the real raw samples and the checksum. A warm-up is a stated protocol choice, batching increases work per endpoint, and remaining variability belongs in the report. If you are tempted to erase a long sample, explain the filtering rule before seeing its convenient effect on the conclusion.

### 5 · UIUC: make failures observable

Use Handling Errors to examine begin-read, work and end-read failures separately. Follow a late failure after work has already changed its context. The public TimeSample stays unchanged, while the task effect survives. This is a concrete ownership boundary rather than a claim that every operation in a measurement can be undone.

The sanitizer section supports memory and arithmetic checks within executed domains. Sanitizers change generated code and cost; their timing is unsuitable for the performance comparison. Record a successful sanitizer gate as correctness evidence and collect performance observations from the stated debug/optimized builds. Do not infer all-input correctness from one clean execution.

### 6 · CS:APP: state the performance quantity

Read §5.2 before comparing numbers. Identify the workload, repeated operation and unit used for a performance statement. The sum of512 IDs is a defined result, while the duration is an observed quantity. Compiler transformations can change the work actually emitted, so connect the object listing to the checksum-dependent call boundary.

This text’s processor-performance discussion is deeper than the timer API exercise. Keep a question beside it: what additional information would be required to turn elapsed nanoseconds into core cycles? The empirical TSC calibration alone does not provide that information. A short assembly listing is another observation, not the missing cycle measurement.

### 7 · Hennessy and Patterson: report what transfers

Use §1.8 to specify the comparison and summarize samples, then §1.11 to challenge tempting generalizations. A lower median, minimum and maximum answer different questions. The package states lower median for even counts; another tool’s average or interpolated median may disagree without an arithmetic bug.

At this rung the equations can be denser. Start by substituting the benchmark’s workload and unit into one statement, then identify which assumptions must stay fixed to compare a second machine. WSL, counter support, load and clock implementation belong in the context. F03 asks you to connect a calibrated ratio to a qualified claim rather than treating a plausible value as a processor specification.

### Return to the primary contract

For exact behavior, consult the Linux manual’s clock IDs and return values and Intel’s RDTSCP/LFENCE/CPUID entries. The calibration uses nested but different windows; AUX diagnostics and advertised capability are retained. No companion establishes store visibility, global counter synchronization or VM fidelity for the tested environment. E04’s answer must name those gaps, and E05’s report must preserve the evidence that remains useful despite them.

'''
    else:
        reading+='''### 1 · Scott: follow one occurrence

Start with *Step by Step* and *Speed*. Trace the ordered activity of one operation before grouping several under a label. For profiling, the same name can occur more than once, so counting names alone loses the start and end of each occurrence. Use the fixed tree in the beginner walk-through to keep those occurrences visible.

Scott supplies physical intuition rather than a recursive profiler specification. His simple machine does not define inclusive or exclusive aggregation, capacity errors or the local event transaction. State that boundary explicitly; the tree you draw is a model for this assignment and the public header defines its exact arithmetic.

### 2 · Beej C: give each active occurrence storage

Read Scope alongside bounded arrays and unsigned arithmetic. C scope tells you where names are usable and automatic storage lives; a profiler scope is a recorded interval requiring a matched end. Those two ideas interact but are not interchangeable. An early return can leave a recorded scope active even though its local C variables have gone out of scope.

The frame array gives each active invocation its own start. Same-ID recursion pushes another frame instead of overwriting one start in a bucket. Bounds checks reject depth33 before writing; ordered subtraction and preflight sums prevent wrapping. If you get lost in the implementation, trace the three-frame example on paper before studying loops or macros.

### 3 · Beej library: copy only valid objects

The memcpy reference helps with local state snapshots and report publication. Its size and overlap obligations remain important when an operation promises unchanged output after failure. Read it as an object-access contract, not a permission to copy through arbitrary invalid pointers or alias the output over immutable input.

The supplied profiler uses struct assignment for complete local candidates and expects accessible disjoint storage. Exact state preservation can be checked against a byte snapshot of the same initialized object. This comparison checks a failed operation; it does not turn padding bytes into portable semantic data for unrelated independently created objects.

### 4 · Dive Into Systems: compare tool metrics

Read Timing for endpoint method and Cache Analysis and Cachegrind for a different style of analysis. A tool may count modeled instructions or cache events instead of real elapsed duration. Write the metric beside every output before trying to combine its numbers with the local event report.

The bridge gets harder when one region includes another. Inclusive time counts the child again at the parent, while self time removes direct-child intervals. The local profiler counts every recursive invocation; another tool may choose a different recursion convention. Compare definitions first. A disagreement between differently defined totals is not sufficient evidence of an implementation defect.

### 5 · UIUC: errors and thread ownership

Handling Errors supports the transaction for begin, end and report. Consider a valid nested interval whose combined inclusive report exceeds uint64 range. Each bucket can fit while the sum cannot. P_OVERFLOW leaves the old report untouched instead of quietly truncating or saturating it.

Race Conditions explains the other major limit. One Profile mutates a shared stack and totals without synchronization. Separate instances give threads separate ownership, but a completed-report merge still needs common units, stable labels and checked arithmetic. The core exercise uses serialized events. The Handmade Hero concurrency discussion is useful motivation for this ownership rule; it does not supply missing locks in the C API.

### 6 · CS:APP: profiling is a measurement choice

Read Program Profiling and Using a Profiler to connect attribution with decisions about expensive regions. First ask whether the region deserves further investigation; then examine finer placement. Instrumenting every tiny operation may generate more bookkeeping than useful work, while one large scope may hide the stage you want to distinguish.

The actual benchmark compares equal checksummed folds with and without33 completed scopes. Alternating order reduces one obvious bias while leaving scheduling and host state variable. A negative relative difference stays in the data. More runs can clarify a distribution, but neither one slow sample nor a convenient minimum establishes a universal per-hook cost.

### 7 · Hennessy and Patterson: qualify overhead claims

Use Measuring, Reporting, and Summarizing Performance to name the baseline and measured workload. Then use Fallacies and Pitfalls to examine a proposed fixed correction. Empty-hook cost is an observation under a particular placement and build; subtracting it from every recursive interval assumes its cost transfers unchanged across depth, cache state and surrounding code.

The deeper quantitative material is optional. Begin with the simple fraction (instrumented-baseline)/baseline and explain its numerator and denominator. Converting before unsigned subtraction allows a negative observation. A zero baseline cannot support that ratio. F03 connects representational failure with an honest definition of the quantity being reported.

### Return to the event protocol

The local header defines16 IDs,32 frames, global order across successful events, all-invocation recursive inclusive totals and closed-report publication. The companions provide useful ideas around that design rather than its exact policy. Covered time omits gaps outside recorded roots. Per-thread sums may overlap in wall time, and instrumentation changes the execution it observes. State these limits when using a report to justify a next experiment.

'''
    reading+='## Source-by-source cross-reference\n\n<!-- crossref -->\n\n## Reading questions\n\n<!-- reading-questions -->\n'
    write(f'docs/content/further-reading/{slug}.md',f'# Week {n} further reading · {d["concept"]}\n\n[Lesson](/weeks/{slug}) · [Beginner section](/beginners/{slug})\n\n'+reading)
write('tools/docs/catalogue.json',json.dumps(sorted(catalogue,key=lambda c:c['n']),indent=2,ensure_ascii=False))
write('tools/docs/readings.json',json.dumps(registry,indent=1,ensure_ascii=False))
files=set(json.loads((root/'tools/docs/files.json').read_text(encoding='utf-8')))
for n in [13,14]:
    for folder in [root/f'week-{n:02}',root/f'docs/examples/week-{n:02}']:
        files.update(p.relative_to(root).as_posix() for p in folder.rglob('*') if p.is_file() and 'build' not in p.relative_to(folder).parts and '__pycache__' not in p.parts)
write('tools/docs/files.json',json.dumps(sorted(files),indent=2))
# Preserve existing later packages and make only the missing handoff changes.
for n in [13,14]:
    slug=f'week-{n:02}'
    for path,link,label in [('README.md',f'{slug}/README.md',f'Week {n:02}: {data[n]["title"]}'),('docs/content/solutions/index.md',f'/solutions/{slug}',f'Week {n} · {data[n]["title"]}'),('docs/content/beginners/index.md',f'/beginners/{slug}',f'Week {n} · {data[n]["concept"]}')]:
        p=root/path;text=p.read_text(encoding='utf-8')
        if f']({link})' not in text:
            lines=text.splitlines();at=next(i for i,l in enumerate(lines) if '](' in l and ('week-12' if n==13 else 'week-13') in l)
            lines.insert(at+1,f'- [{label}]({link})');write(path,'\n'.join(lines))
for path in ['README.md','docs/content/guide/start.md']:
    p=root/path;text=p.read_text(encoding='utf-8').replace('Weeks 13, 14 and 17–52 remain planned.','Weeks 17–52 remain planned.').replace('Weeks 13, 14 and 17–52 are planned;','Weeks 17–52 are planned;');write(path,text)
p=root/'docs/content/weeks/week-12.md';write(p.relative_to(root),p.read_text(encoding='utf-8').replace('next: false',"next:\n  text: 'Week 13 · Clocks and repeatable timing'\n  link: '/weeks/week-13'",1))

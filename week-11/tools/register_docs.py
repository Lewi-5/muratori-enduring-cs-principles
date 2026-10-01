"""Merge Week 11 only; retain other agents' registry entries."""
from pathlib import Path
import json

root = Path(__file__).resolve().parents[2]
slug = 'week-11'
def read(name):
    return json.loads((root/'tools/docs'/name).read_text(encoding='utf-8'))
def write(name, value):
    (root/'tools/docs'/name).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

titles = ['Map scalar arguments', 'Inspect real geolab calls', 'Follow a loop and an optimized local', 'Keep values across a callback', 'Build an evidence-backed comparison']
steps = ['Implement abi_plan with independent GP/XMM pools, source-order spills, rounded reservation and atomic output.', 'Implement wrappers through completed geolab functions; inspect the actual functions as well as wrappers.', 'Implement fold_ids with defined unsigned wrap, then compare it with the supplied local_example at O0/O2.', 'Implement keep_across_call with one validated callback invocation and values live across that call.', 'Run all checks; preserve four actual compiler manifests and annotate geo_distance_km and query_hit_compare. Complete R01–R05.']
predict = ['Map seven integers, nine doubles and the real geolab signatures.', 'Predict the wrapper argument shuffle and how a relocation names the eventual call.', 'Predict doubled and its result before looking for a physical stack slot.', 'Predict which values must survive the indirect call.', 'Predict the difference between 8086 and x64 returns, then delimit any timing claim.']
why = ['An ABI is an agreement at a binary boundary, with separate argument classes.', 'Real compiled C connects the agreement to observable machine instructions.', 'C objects need not retain distinct physical storage after optimization.', 'Calling another function requires preserving values still needed afterwards.', 'Actual artifacts with recorded toolchains support narrower, reproducible claims.']
modules = ['learner/src/abi.c', 'learner/src/wrappers.c', 'learner/src/fold.c', 'learner/src/calls.c', 'support/playground.c']
exercises = {f'E{i+1:02}': dict(title=titles[i], why=why[i], prerequisites='Week 10 calls, C pointers, completed scalar geolab and separate compilation', predict=predict[i], steps=steps[i], hint=['Advance each pool independently; padding belongs above the spilled arguments.', 'Distinguish compiler text, relocated objects and linked addresses.', 'Read LEA as arithmetic when no memory operand is dereferenced.', 'Follow the saved seed and output pointer across the call.', 'An instruction listing is not a processor timing measurement.'][i], evidence='Record compiler, target, flags and source hashes; distinguish a stable ABI rule from this compiler observation.', sources=[f'{slug}/{modules[i]}']) for i in range(5)}
entry = dict(n=11, title='From C to x64: calls and the ABI', slug=slug,
    promptFiles=[f'{slug}/learner/{n}.md' for n in ['exercises','practice','observations','warmups','reading-questions']],
    answerFiles=[f'{slug}/instructor/{n}.md' for n in ['answers','observations','warmups','reading-answers']],
    readings=[
        dict(resource='[CE: Estimating Cycles](https://www.computerenhance.com/p/estimating-cycles)', portion='Full, 23:56', purpose='Separate a historical timing model from measured modern performance.'),
        dict(resource='[CE: From 8086 to x64](https://www.computerenhance.com/p/from-8086-to-x64)', portion='Full, 26:21', purpose='Carry architectural reasoning into actual x64 C output.'),
        dict(resource='[Handmade Chat 020](https://guide.handmadehero.org/chat/chat020/)', portion='27:24–39:14 and 58:29–1:08:27', purpose='Follow compiler inspection and instruction questions; its examples do not define System V.'),
        dict(resource='[AMD64 System V ABI draft 0.21](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf)', portion='§§3.2.1–3.2.3, stable scalar LP64 subset; historical draft', purpose='Specify GP/XMM locations, preservation and ordinary stack alignment.'),
        dict(resource='[Intel Optimization Reference Manual](https://cdrdv2-public.intel.com/821612/248966-Optimization-Reference-Manual-V1-050.pdf)', portion='§3.4.1, branch prediction and return-address stack', purpose='Distinguish architectural return behavior from processor prediction.')],
    companion=[dict(title='Dive Into Systems §7.5: Functions in Assembly', url='https://diveintosystems.org/book/C7-x86_64/functions.html'), dict(title='Beej §23.7: Pointers to Functions', url='https://beej.us/guide/bgc/html/split/pointers-iii-pointers-to-pointers-and-more.html#pointers-to-functions')], exercises=exercises, guidance={})
for i, hint in enumerate(['Track GP and XMM arguments independently.', 'Draw caller reservation and callee entry before adjusting RSP.', 'Use the relocation record to identify a not-yet-linked destination.', 'Track the red zone through the nested CALL.', 'Separate C lifetime from physical location.', 'Name the processor and measurement needed before claiming speed.'], 1):
    entry['guidance'][f'P{i:02}'] = hint
entry['guidance']['S01'] = 'Change one inlining condition and preserve correctness inputs, toolchain and actual artifacts.'
entry['guidance']['S02'] = 'Apply aggregate eightbyte classification; do not feed a struct into the scalar planner.'
for i in range(1,6):
    entry['guidance'][f'R{i:02}'] = 'Preserve predictions and actual evidence; separate ABI requirements, compiler choices and timing limits.'
catalogue = [w for w in read('catalogue.json') if w['n'] != 11] + [entry]
write('catalogue.json', sorted(catalogue, key=lambda w: w['n']))

readings = read('readings.json')
for name in ['estimating-cycles','from-8086-to-x64']:
    readings['muratori']['ce:'+name]['url'] = 'https://www.computerenhance.com/p/'+name
messages = {
    'bhdik:instructions': 'Start with instruction inputs, outputs and state changes before interpreting compiler output.',
    'bhdik:another-way-to-jump': 'Retain a continuation across a transfer; the teaching ISA is not x64.',
    'bgc:17.4': 'Connect source modules, separate compilation and the eventual linker boundary.',
    'bgc:23.7': 'Understand the callback type and one indirect C call before tracing its binary boundary.',
    'bgc:13': 'Separate source-level local scope from any physical stack location.',
    'bgclr:24.18': 'Read the qsort comparison callback contract used by the actual query code.',
    'dis:2.9.7': 'Generate and read assembly from C without treating one listing as universal.',
    'dis:7.5': 'Follow x64 argument registers, stack frames and register preservation.',
    'cs341:3.8.3': 'Keep C object lifetime separate from a stack-slot observation.',
    'csapp:3.7.3': 'Track arguments, return values and data flow through procedure boundaries.',
    'csapp:3.7.4': 'Follow local stack storage and why its physical shape depends on compilation.',
    'csapp:3.7.5': 'Track locals preserved across a call and compiler register choices.',
    'hp:K.3': 'Place historical 80x86 mechanisms alongside later architecture changes.',
    'hp:C.1': 'Distinguish instruction behavior from pipelined implementation and timing.',
    'hp:3.3': 'Separate return-prediction machinery from the architectural saved continuation.'}
def refs(ids):
    return [dict(id=i, why=messages[i]) for i in ids]
rows = [
    ('ce:estimating-cycles','Full, 23:56','State assumptions behind a cycle estimate; avoid transplanting them to current x64.', ['bhdik:instructions','dis:2.9.7','csapp:3.7.3','hp:K.3','hp:C.1']),
    ('ce:from-8086-to-x64','Full, 26:21','Map actual C calls to x64 scalar register and stack agreements.', ['bhdik:another-way-to-jump','bgc:17.4','bgc:23.7','bgclr:24.18','dis:7.5','csapp:3.7.3','csapp:3.7.4','csapp:3.7.5','hp:K.3']),
    ('chat:020','27:24–39:14 and 58:29–1:08:27','Inspect actual compiler output and distinguish instruction observations from microarchitectural claims.', ['bhdik:instructions','bgc:13','bgc:23.7','bgclr:24.18','dis:2.9.7','dis:7.5','cs341:3.8.3','csapp:3.7.5','hp:C.1','hp:3.3'])]
readings['weeks']['11'] = dict(status='complete', mechanism='The System V AMD64 scalar ABI and actual generated x64 assembly.', crossref=[dict(muratori=m, portion=p, mechanism=why, sections=refs(ids), gap='The companion accounts do not replace the named ABI or processor manual. Video examples may use another platform; our planner excludes aggregates, vectors, variadic calls and narrow-value rules. No listing measures cycles or return prediction.') for m,p,why,ids in rows], extra=refs(['bgc:13','cs341:3.8.3','hp:3.3']))
write('readings.json', readings)
files = read('files.json')
selected = [p.relative_to(root).as_posix() for p in (root/slug).rglob('*') if p.is_file() and 'build' not in p.relative_to(root/slug).parts and '__pycache__' not in p.parts and p.suffix in {'.md','.c','.h','.py','.S','.s','.txt','.json'}]
write('files.json', sorted(set(files) | set(selected) | {slug+'/Makefile','docs/examples/week-11/local_value.c'}))
print('Merged Week 11 catalogue, reading map and allowlist')

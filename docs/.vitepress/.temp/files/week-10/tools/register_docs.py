"""Merge only Week 10 entries into the shared documentation registries."""
from pathlib import Path
import json

root=Path(__file__).resolve().parents[2]
def read(name):
    return json.loads((root/'tools/docs'/name).read_text(encoding='utf-8'))
def write(name, value):
    (root/'tools/docs'/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

slug='week-10'
titles=['Checked stack words','Extend the instruction description','Atomic near control transfer',
        'A complete program transaction','Trace and lifetime evidence']
why=[
    'Explicit guest bytes keep stack order independent of host endian and alignment rules.',
    'Lengths and signed patterns determine both the saved continuation and the destination.',
    'An invalid return must not leak a tentative POP or memory mutation.',
    'The runner must preserve the entire caller state when later execution fails.',
    'A predicted trace connects instruction rules to observation; C lifetime remains a separate contract.'
]
predict=[
    'Draw SP and low/high bytes after pushing 1234 and ABCD, then popping both.',
    'Calculate the return and target of E8 02 00 at IP 0003 and E8 03 00 at IP 000C.',
    'Draw the deepest three words of the nested fixture and predict an omitted restore.',
    'Predict EB FE with budget three and a malformed unreachable suffix.',
    'Predict the fixture before replaying it; explain the invalid automatic-local return.'
]
steps=[
    'Implement machine_push and machine_pop in stack.c with window checks before writes and unchanged outputs on failure.',
    'Implement machine_decode in decode.c, reusing the pinned base decoder and accepting only the header-defined extensions.',
    'Implement machine_step in execute.c with immutable-code boundary checks, local Machine state, explicit stack/transfer ordering and instruction-specific flag effects.',
    'Implement machine_run in run.c with full predecode, positive step budget, end-boundary halt and whole-state commit.',
    'Use the supplied driver/playground, compare all golden fields, add backward-CALL and bad-return cases, and complete R01–R05.'
]
hints=[
    'The empty SP equals high; PUSH writes at SP minus two, never at high.',
    'A high-bit pattern becomes its unsigned value minus the width modulus.',
    'Build the next state locally; validate the popped return before assignment.',
    'Check for halt before rejecting a budget that has just been used exactly.',
    'A stale byte is stored data, not proof of a live C object.'
]
evidence=[
    'All word patterns check encoding, while bound tests check legal storage access.',
    'Correct displacement arithmetic does not prove a target is an instruction boundary.',
    'Balanced SP does not establish restored register ownership.',
    'Tentative successful steps are reported without becoming committed changes.',
    'A correct guest trace establishes state for this subset, not modern CPU timing.'
]
modules=['stack.c','decode.c','execute.c','run.c']
exercises={}
for i in range(5):
    exercises[f'E{i+1:02}']=dict(title=titles[i],why=why[i],
        prerequisites=['guest memory, unsigned byte operations and checked outputs',
                       'opcode fields, signed patterns and bounded byte reads',
                       'register aliases, arithmetic flags, effective addresses and stack helpers',
                       'instruction boundaries, immutable input and atomic transitions',
                       'hand traces, independent tests, C scope and lifetime'][i],
        predict=predict[i],steps=steps[i],hint=hints[i],evidence=evidence[i],
        sources=[f'{slug}/learner/src/{modules[i]}'] if i<4 else [f'{slug}/support/driver.c',f'{slug}/support/playground.c'])
video=[('Simulating Real Programs','simulating-real-programs','Full, 16:02','Trace a program assembled from separate state transitions.'),
       ('Other Common Instructions','other-common-instructions','Full, 19:43','Read instruction-specific write/flag rules; implement only the listed subset.'),
       ('The Stack','the-stack','Full, 26:58','Track SP, saved data and near continuations.')]
entry=dict(n=10,title='Stack discipline, calls and lifetimes',slug=slug,
    promptFiles=[f'{slug}/learner/{name}.md' for name in ['exercises','practice','observations','warmups','reading-questions']],
    answerFiles=[f'{slug}/instructor/{name}.md' for name in ['answers','observations','warmups','reading-answers']],
    readings=[dict(resource=f'[CE: {title}](https://www.computerenhance.com/p/{url})',portion=portion,purpose=purpose) for title,url,portion,purpose in video]+[
      dict(resource='[Handmade Chat 013](https://guide.handmadehero.org/chat/chat013/)',portion='3:50:01–3:55:37',purpose='Compare indexed RIP/RSP observations; Windows/x64 is not 8086 or System V authority.'),
      dict(resource='[Intel manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)',portion='Volume 2 PUSH/POP/CALL/RET and INC/DEC operations and flags',purpose='Primary instruction semantics, including original 8086 PUSH SP.'),
      dict(resource='[C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf)',portion='§§6.2.1, 6.2.4, 6.5.2.2',purpose='Separate scope, object lifetime/storage duration and C function calls from stack placement.')],
    companion=[dict(title='Beej §13: Scope',url='https://beej.us/guide/bgc/html/split/scope.html#scope'),dict(title='Dive Into Systems §7.5: Functions in Assembly',url='https://diveintosystems.org/book/C7-x86_64/functions.html')],
    exercises=exercises,guidance={})
guidance=[
 'Count bytes before words, then predict error and preserved state.',
 'Calculate result and each flag independently, keeping CF distinct from OF.',
 'Calculate the following IP first, then test membership in the actual boundary map.',
 'Draw the last saved word at the current SP before choosing the destination register.',
 'Name the language rule and distinguish it from observed contents.',
 'Track which array the operation reads and writes; equal numbers need not imply aliasing.',
 'Write the recurrence before running; compare stack exhaustion with budget precedence.',
 'Specify cache ownership and invalidation before claiming any saved work.'
]
for i in range(6): entry['guidance'][f'P{i+1:02}']=guidance[i]
for i in range(2): entry['guidance'][f'S{i+1:02}']=guidance[i+6]
for i in range(5): entry['guidance'][f'R{i+1:02}']='Preserve predictions, record actual evidence, and distinguish observation, inference and model limits.'
catalogue=read('catalogue.json')
catalogue=[item for item in catalogue if item['n']!=10]+[entry]
write('catalogue.json',sorted(catalogue,key=lambda w:w['n']))

readings=read('readings.json')
for title,url,_,_ in video: readings['muratori']['ce:'+url]['url']='https://www.computerenhance.com/p/'+url
def refs(ids):
    messages={
      'bhdik:the-load-and-store-instructions':'Follow numeric data addresses and stored words before frames.',
      'bhdik:another-way-to-jump':'Separate a code destination from a retained continuation; this is a different teaching ISA.',
      'bgc:13':'Distinguish identifier visibility from object lifetime.',
      'bgc:16.2':'Relate automatic and static duration to blocks without requiring a stack slot.',
      'bgc:17.4':'Connect separately compiled modules to the supplied decoder/ALU boundary.',
      'bgclr:26.1':'Use host buffer-copy contracts for transactions; guest word encoding is separate.',
      'dis:2.1':'Compare program-memory roles and language storage rules.',
      'dis:7.5':'Follow a caller, callee and return in x64; retain only the shared mechanism.',
      'cs341:3.8.3':'Explain and repair the invalid automatic-local return.',
      'csapp:3.7.1':'Draw live words and the stack pointer; do not import x64 word sizes.',
      'csapp:3.7.2':'Trace saved continuations through calls and returns.',
      'hp:A.6':'Place near transfer among wider ISA control-flow choices.'
    }
    return [dict(id=sid,why=messages[sid]) for sid in ids]
rows=[
 ('ce:simulating-real-programs','Full, 16:02','Compose decoded transitions into an auditable complete trace.',
  ['bhdik:another-way-to-jump','bgc:17.4','dis:7.5','csapp:3.7.2','hp:A.6']),
 ('ce:other-common-instructions','Full, 19:43','Read each instruction\'s flag and write set rather than inferring from arithmetic similarity.',
  ['bhdik:the-load-and-store-instructions','bgc:16.2','dis:7.5','csapp:3.7.1','hp:A.6']),
 ('ce:the-stack','Full, 26:58','Reserve/read word storage, save continuations and restore in reverse order.',
  ['bhdik:the-load-and-store-instructions','bgc:13','bgclr:26.1','dis:7.5','cs341:3.8.3','csapp:3.7.1','csapp:3.7.2','hp:A.6']),
 ('chat:013','3:50:01–3:55:37','Connect running code positions and stack locations to their distinct architectural registers.',
  ['bhdik:another-way-to-jump','bgc:17.4','dis:7.5','csapp:3.7.2','hp:A.6'])
]
readings['weeks']['10']=dict(status='complete',mechanism='Stack discipline, calls, returns and C object lifetimes.',
    crossref=[dict(muratori=mid,portion=portion,mechanism=mechanism,sections=refs(ids),
        gap='The companion accounts use different teaching ISAs or modern ABIs. None defines our original 8086 PUSH SP rule plus bounded window, separate immutable code, boundary validation and rollback policy. Consult Intel for the historical instruction and machine.h for course restrictions.') for mid,portion,mechanism,ids in rows],
    extra=refs(['bgc:16.2','dis:2.1','cs341:3.8.3','bgclr:26.1']))
write('readings.json',readings)

files=read('files.json')
selected=[]
for p in (root/slug).rglob('*'):
    relative=p.relative_to(root).as_posix()
    if p.is_file() and '/build/' not in relative and p.name!='build-validation.log' and p.suffix in {'.md','.c','.h','.py','.hex','.txt'}:
        selected.append(relative)
selected.append(slug+'/Makefile')
selected.append('docs/examples/week-10/stack_word.c')
write('files.json',sorted(set(files)|set(selected)))
print('Merged Week 10 catalogue, reading map and allowlist entries')

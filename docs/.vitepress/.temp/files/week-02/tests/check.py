"""Orchestrate C contracts; Python is not the inspector implementation."""
import argparse
import itertools
from pathlib import Path
import re
import shlex
import subprocess

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()

def run(command, success=True):
    r = subprocess.run([str(x) for x in command], capture_output=True, text=True, timeout=60)
    assert (r.returncode == 0) == success, (command, r.returncode, r.stdout, r.stderr)
    if not success:
        assert r.stderr.strip(), (command, 'missing diagnostic')
    return r.stdout

def ex(n, *args, success=True):
    return run([a.build / f'ex{n:02}', *args], success)

def fields(text):
    return dict(re.findall(r'(\w+)=([^\s]+)', text))

lines = ex(1).splitlines()
if lines != ['octet_formatter=skipped']:
    assert lines[0] == 'raw=00 7f 80 ff'
    assert sorted(lines[1].split('=')[1].split()) == ['01', '02', '03', '04']
    assert sorted(lines[2].split('=')[1].split()) == ['fe', 'ff', 'ff', 'ff']
types = {}
for line in ex(2).splitlines():
    f = fields(line); size, align = int(f['size']), int(f['align'])
    assert align > 0 and align & (align - 1) == 0 and size >= align and size % align == 0
    types[f['type']] = (size, align)
assert set(types) == {'char','short','int','long','llong','float','double','ldouble','ptr','max_align_t'}
assert all(v[1] <= types['max_align_t'][1] for v in types.values())
assert types['char'][0] == 1
layout_lines = ex(3).splitlines()
assert layout_lines[0] in ['reference_abi=checked', 'reference_abi=skipped']
assert len(layout_lines) == 13
if layout_lines[0].endswith('checked'):
    assert all(fields(line)['match'] == '1' for line in layout_lines if line.startswith('struct='))
for line in ex(4).splitlines():
    f = fields(line)
    assert len(f['map']) == int(f['size']) and set(f['map']) <= set('ABC.')
address_lines = ex(5).splitlines()
assert len(address_lines) == 16 and all(fields(line)['match'] == '1' for line in address_lines)
lines = ex(6).splitlines()
assert lines[0] == 'static=1,2,3 automatic=1,1,1 frames_distinct=1 alloc_independent=1'
assert lines[1] in ['auto_reuse=yes','auto_reuse=no']
assert ex(7).strip() in ['target_alignment=skipped','malloc_max_align=1 alloc64=1 static64=1 automatic64=1 carve=1 misaligned_rejected=1']
assert ex(8).strip() == 'chain=3 copy_chain=3 pointer_links_follow_copy=0 cycle_rejected=1'
assert ex(9).strip() == 'shared_before=7 shared_after=8 zero=0 limit=100 hidden_data=4 hidden_main=3 shared_same=1 hidden_distinct=1 local=1,2'

def check_cli(names):
    lines = ex(10, ','.join(names)).splitlines()
    summary = {k:int(v) for k,v in fields(lines[0]).items()}
    assert len(lines) == len(names)+2 and summary['members'] == len(names)
    mapping = fields(lines[-1])['map']
    assert len(mapping) == summary['size']
    assert summary['align'] == max(types[n][1] for n in names)
    assert summary['size'] % summary['align'] == 0
    end = total = 0
    for i, (name, line) in enumerate(zip(names, lines[1:-1])):
        f = {k:int(v) for k,v in fields(line).items()}
        assert line.split()[:2] == [chr(65+i),name]
        assert (f['size'],f['align']) == types[name]
        assert f['offset'] >= end and f['offset'] % f['align'] == 0
        assert mapping[f['offset']:f['offset']+f['size']] == chr(65+i)*f['size']
        assert mapping.count(chr(65+i)) == f['size']
        end = f['offset']+f['size']; total += f['size']
    assert summary['padding'] == summary['size']-total == mapping.count('.')
    return summary['size']

for names in [['char'],['char','double','int'],['double','int','char'],['ldouble','char','ptr'],
              ['char','short','int','long','llong','float','double','ldouble','ptr'],['char']*26]:
    check_cli(names)
for bad in ['', ',char', 'char,', 'char,,int', 'floaty', 'char int', ' char', 'char\n', ','.join(['char']*27)]:
    ex(10, bad, success=False)
ex(10, success=False); ex(10, 'char', 'int', success=False)

for n in range(1, 11):
    source = a.source / ('ex09_data.c' if n==9 else f'ex{n:02}.c')
    binary = a.build / f'contract{n:02}'
    run([a.cc,*shlex.split(a.flags),'-Isupport',f'-DSOURCE="{source.resolve()}"',f'-DEXERCISE={n}','tests/contracts.c','-o',binary])
    run([binary])
for n in [6,7]:
    binary = a.build / f'fault{n:02}'
    source = a.source / f'ex{n:02}.c'
    run([a.cc,*shlex.split(a.flags),'-Isupport',f'-DSOURCE="{source.resolve()}"',f'-DEXERCISE={n}','tests/faults.c','-o',binary])
    run([binary])
# Exercise the skip path without claiming this is a test on a second architecture.
for n, expected in [(3,'reference_abi=skipped'),(7,'target_alignment=skipped')]:
    binary = a.build / f'skip{n:02}'
    run([a.cc,*shlex.split(a.flags),'-Isupport','-DW02_PORTABLE_ONLY',a.source/f'ex{n:02}.c','-o',binary])
    assert run([binary]).splitlines()[0] == expected
binary = a.build / 'skip10'
run([a.cc,*shlex.split(a.flags),'-Isupport','-DW02_PORTABLE_ONLY',f'-DSOURCE="{(a.source/"ex10.c").resolve()}"','-DEXERCISE=10','tests/contracts.c','-o',binary])
assert 'reference ABI checks skipped' in run([binary])

if a.source.parts[0] == 'instructor':
    binary = a.build / 'permutations'
    run([a.cc,*shlex.split(a.flags),'-Isupport','instructor/extras/permutations.c','-o',binary])
    lines = run([binary]).splitlines()
    summary = {k:int(v) for k,v in fields(lines[0]).items()}
    # Independent arithmetic oracle for all 120 field-identity permutations.
    names = ['char','double','short','int','char']
    sizes = {}
    for order in itertools.permutations(range(5)):
        offset = 0
        for index in order:
            size, align = types[names[index]]
            offset = ((offset+align-1)//align)*align + size
        alignment = max(types[n][1] for n in names)
        sizes[''.join(chr(65+i) for i in order)] = ((offset+alignment-1)//alignment)*alignment
    assert summary == dict(permutations=120,min=min(sizes.values()),max=max(sizes.values()))
    orders = [fields(line)['minimum_order'] for line in lines[1:]]
    assert len(set(orders)) == len(orders)
    assert set(orders) == {order for order,size in sizes.items() if size==summary['min']}
print('PASS: 10 demos and C contract suites; CLI errors; allocation faults; ABI/skip paths; stretch permutation oracle')

"""Orchestrate the week-6 checks (make test). Python supplies the independent oracle (tests/oracle8086.py) and runs
the tests; the decoder under test is C. Run through make; never with python -O."""
import argparse
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
import oracle8086 as o  # noqa: E402
import make_listings  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()
flags = shlex.split(a.flags)
o.self_test()
root = Path(__file__).resolve().parents[1]
build = a.build.resolve()
src = a.source.resolve()
package = a.source.parts[0]
tmp, orc = build / 'tmp', build / 'oracle'
for d in (tmp, orc):
    d.mkdir(parents=True, exist_ok=True)
fixtures = root / 'fixtures'
failures = []


def check(condition, message):
    if not condition:
        failures.append(message)
        print('FAIL:', message, flush=True)
    return condition


def run(argv, stdout=subprocess.PIPE, timeout=600):
    return subprocess.run([str(x) for x in argv], stdout=stdout, stderr=subprocess.PIPE, text=True, timeout=timeout,
                          errors='replace')


OPNAMES = ['mov', 'add', 'sub', 'cmp']


def fields(text):
    """Canonical text -> (op, dst_wide, dst_reg, src_kind, src_wide, src_reg, imm). Parses the course's own format."""
    m = re.fullmatch(r'(mov|add|sub|cmp) (\w\w), (\w\w|-?\d+)', text)
    op = OPNAMES.index(m.group(1))
    dw, dr = (1, o.REG16.index(m.group(2))) if m.group(2) in o.REG16 else (0, o.REG8.index(m.group(2)))
    if m.group(3) in o.REG16 + o.REG8:
        sw, sr = (1, o.REG16.index(m.group(3))) if m.group(3) in o.REG16 else (0, o.REG8.index(m.group(3)))
        return op, dw, dr, 0, sw, sr, 0
    return op, dw, dr, 1, dw, 0, int(m.group(3))


# ---- oracle files ------------------------------------------------------------------------------------------------------
(orc / 'modrm.txt').write_text(''.join(f'{b} {b >> 6} {(b >> 3) & 7} {b & 7}\n' for b in range(256)))
lines = []
for enc, text in o.TABLE.items():
    lines.append(f'{enc.hex()} DEC_OK {len(enc)} {text}\n')
for b0 in range(256):
    status, length, text = o.expected(bytes([b0]))
    lines.append(f'{b0:02x} {status} {length}{" " + text if text else ""}\n')
    for b1 in range(256):
        for k in range(3):
            stream = bytes([b0, b1, *o.TRAILER[:k]])
            status, length, text = o.expected(stream)
            lines.append(f'{stream.hex()} {status} {length}{" " + text if text else ""}\n')
(orc / 'exhaustive.txt').write_text(''.join(lines))
(orc / 'fields.txt').write_text(''.join(' '.join(str(x) for x in fields(t)) + f' {t}\n' for t in sorted(set(o.TABLE.values()))))
built = make_listings.build()
listing_lines = []
for name, (data, text) in built.items():
    committed_bin = fixtures / 'listings' / f'{name}.bin'
    committed_txt = fixtures / 'listings' / f'{name}.txt'
    check(committed_bin.read_bytes() == data and committed_txt.read_bytes() == text.encode(),
          f'fixtures/listings/{name} differs from tools/make_listings.py')
    m = re.fullmatch(r'error (\w+) at offset (\d+)\n', text)
    listing_lines.append(f'{name} {m.group(1)} {m.group(2)}\n' if m else f'{name} DEC_OK {len(data)}\n')
(orc / 'listings.txt').write_text(''.join(listing_lines))

# ---- demo drivers ------------------------------------------------------------------------------------------------------
def ex(n):
    r = run([build / f'ex{n:02}'])
    check(r.returncode == 0, f'ex{n:02} exited {r.returncode}')
    return r.stdout


want = ''.join(f'byte=0x{b:02X} mod={b >> 6:02b} reg={(b >> 3) & 7:03b} rm={b & 7:03b}\n' for b in (0xD9, 0xCB, 0xC6, 0x00))
check(ex(1) == want, 'ex01 driver output')
want = ''.join(f'w={w}' + ''.join(f' {r}={(o.REG16 if w else o.REG8)[r]}' for r in range(8)) + '\n' for w in (0, 1))
check(ex(2) == want, 'ex02 driver output')
check(ex(3) == 'read16@0=0x1234\nread16@2=0xFFFE signed=-2\nread16@4 rejected=1\n'
              'sign_extend8(0xFE)=0xFFFE to_signed8(0xFE)=-2 to_signed16=-2\n', 'ex03 driver output')
want = []
for h in ('89d9', '8bcb', 'b10c', 'b9f4ff', '83c6fe', '80c1fe', '82c105', '8807', '81c6'):
    status, length, text = o.expected(bytes.fromhex(h))
    if status != 'DEC_OK':
        want.append(f'bytes={h.upper()} status={status}\n')
        continue
    op, dw, dr, kind, sw, sr, imm = fields(text)
    srcs = f'reg{sw}:{sr}' if kind == 0 else f'imm{imm}'
    want.append(f'bytes={h.upper()} status=DEC_OK op={OPNAMES[op]} length={length} dst=reg{dw}:{dr} src={srcs}\n')
check(ex(4) == ''.join(want), 'ex04 driver output agrees with the oracle')
check(ex(5) == 'text="mov cx, bx" length=10\ntext="add si, -2" length=10\ntext="cmp al, 12" length=10\n'
              'text="cmp ax, -32768" length=14\ntext="sub ah, bh" length=10\n', 'ex05 driver output')

# ---- C contract suites -------------------------------------------------------------------------------------------------
for n in range(1, 7):
    exe = build / f'contract{n:02}'
    sources = [f'-DSOURCE="{src / (f"ex{n:02}.c" if n < 6 else "decode.c")}"']
    if n == 6:
        sources.append(f'-DSOURCE2="{src / "decode8086.c"}"')
    r = run([a.cc, *flags, '-Isupport', f'-I{src}', f'-DEXERCISE={n}', *sources, f'-DORACLE_DIR="{orc}"',
             f'-DFIXTURE_DIR="{fixtures}"', f'-DTEST_TMPDIR="{tmp}"', 'tests/contracts.c', '-o', exe])
    if check(r.returncode == 0, f'contract E{n:02} did not compile:\n{r.stderr[-2500:]}'):
        r = run([exe], timeout=900)
        check(r.returncode == 0 and 'contract passed' in r.stdout, f'contract E{n:02} failed:\n{r.stdout[-800:]}{r.stderr[-1500:]}')
        if r.returncode == 0:
            print(f'E{n:02}: {r.stdout.strip().splitlines()[0]}', flush=True)

# ---- decode8086 --------------------------------------------------------------------------------------------------------
tool = build / 'decode8086'
for name, (data, text) in built.items():
    r = run([tool, fixtures / 'listings' / f'{name}.bin'])
    m = re.fullmatch(r'error (\w+) at offset (\d+)\n', text)
    if m:
        check(r.returncode == 1 and r.stdout == '' and r.stderr == f'decode8086: {m.group(1)} at offset {m.group(2)}\n',
              f'decode8086 {name}: {r.returncode} {r.stderr!r}')
    else:
        check(r.returncode == 0 and r.stdout == text and r.stderr == '', f'decode8086 {name}: output differs')
(tmp / 'empty.bin').write_bytes(b'')
r = run([tool, tmp / 'empty.bin'])
check(r.returncode == 0 and r.stdout == 'bits 16\n', 'decode8086 of an empty file prints bits 16 alone')
(tmp / 'max.bin').write_bytes(b'\x89\xd9' * 32768)
r = run([tool, tmp / 'max.bin'])
check(r.returncode == 0 and r.stdout == 'bits 16\n' + 'mov cx, bx\n' * 32768, 'decode8086 of exactly 65536 bytes')
(tmp / 'big.bin').write_bytes(b'\x89\xd9' * 32768 + b'\x90')
r = run([tool, tmp / 'big.bin'])
check(r.returncode == 1 and r.stdout == '' and r.stderr == 'decode8086: input too large\n', 'decode8086 of 65537 bytes')
for argv, message in (([tmp / 'missing.bin'], 'decode8086: input error\n'), ([tmp], 'decode8086: input error\n')):
    r = run([tool, *argv])
    check(r.returncode == 1 and r.stdout == '' and r.stderr == message, f'decode8086 {argv}: {r.returncode} {r.stderr!r}')
for argv in ([], ['a', 'b']):
    r = run([tool, *argv])
    check(r.returncode == 1 and r.stdout == '' and r.stderr.startswith('decode8086: usage'), f'decode8086 usage {argv}')
if Path('/dev/full').exists():
    with open('/dev/full', 'w') as full:
        r = run([tool, fixtures / 'listings' / 'program.bin'], stdout=full)
    check(r.returncode == 1 and r.stderr == 'decode8086: output error\n', 'decode8086 to /dev/full reports an output error')

# ---- objdump cross-check (toolchain observation, gated) -----------------------------------------------------------------
objdump = shutil.which('objdump')
probe = run([objdump, '-D', '-b', 'binary', '-m', 'i8086', '-M', 'intel', fixtures / 'listings' / 'program.bin']) if objdump else None
if probe is None or probe.returncode != 0:
    print('objdump cross-check skipped: objdump with i8086 support not found (toolchain observation)')
else:
    encs = list(o.TABLE.items())
    (tmp / 'all.bin').write_bytes(b''.join(e for e, _t in encs))
    r = run([objdump, '-D', '-b', 'binary', '-m', 'i8086', '-M', 'intel', tmp / 'all.bin'], timeout=900)
    got = re.findall(r'^\s*[0-9a-f]+:\t(?:[0-9a-f]{2} )+\s*\t(\S+)\s+(\S+),(\S+)$', r.stdout, re.M)
    mismatches = []
    for (enc, text), (mn, dst, srcop) in zip(encs, got):
        width = 1 if dst in o.REG16 else 0
        if srcop.startswith('0x'):
            srcop = str(o.signed(int(srcop, 16), width))  # objdump prints the unsigned operand-width pattern
        if f'{mn} {dst}, {srcop}' != text:
            mismatches.append((enc.hex(), text, f'{mn} {dst},{srcop}'))
    check(len(got) == len(encs) and not mismatches,
          f'objdump disagrees on {len(mismatches)} of {len(encs)} encodings (parsed {len(got)}): {mismatches[:3]}')
    print(f'objdump cross-check: {len(encs)} encodings agree after normalizing immediates (toolchain observation)')

# ---- instructor stretch programs (S01, S02) ------------------------------------------------------------------------------
if package == 'instructor':
    for name in ('s01_jumps', 's02_table'):
        r = run([a.cc, *flags, '-Isupport', f'-I{src}', f'instructor/extras/{name}.c', build / 'decode.o', '-o', build / name])
        check(r.returncode == 0, f'{name} did not compile: {r.stderr[-1500:]}')
    jumps = list(o.jump_encodings())
    (tmp / 'jumps.bin').write_bytes(b''.join(e for e, _t in jumps) + bytes.fromhex('89d983c6fe'))
    r = run([build / 's01_jumps', tmp / 'jumps.bin'])
    want = 'bits 16\n' + ''.join(t + '\n' for _e, t in jumps) + 'mov cx, bx\nadd si, -2\n'
    check(r.returncode == 0 and r.stdout == want, 'S01: branch decoding disagrees with the oracle')
    if probe is not None and probe.returncode == 0:
        r = run([objdump, '-D', '-b', 'binary', '-m', 'i8086', '-M', 'intel', tmp / 'jumps.bin'])
        got = re.findall(r'^\s*([0-9a-f]+):\t(?:[0-9a-f]{2} )+\s*\t(\S+)\s+0x([0-9a-f]+)$', r.stdout, re.M)
        bad = 0
        for (enc, text), (addr, mn, target) in zip(jumps, got):
            rel = (int(target, 16) - int(addr, 16)) % 2 ** 32
            rel = rel - 2 ** 32 if rel >= 2 ** 31 else rel
            bad += f'{o.OBJDUMP_ALIASES.get(mn, mn)} ${"+" if rel >= 0 else "-"}{abs(rel)}' != text
        check(len(got) == len(jumps) and bad == 0, f'S01: objdump disagrees on {bad} of {len(jumps)} branches')
    r = run([build / 's02_table'], timeout=900)
    check(r.returncode == 0 and 'table_decoder_agrees=1' in r.stdout, f'S02: {r.stdout} {r.stderr[-800:]}')
    print(f'S01: {len(jumps)} branches agree with the oracle and objdump; S02: {r.stdout.strip()}')

# ---- E07: the package's own test cases -----------------------------------------------------------------------------------
cases = root / package / 'cases.txt'
r = run([sys.executable, root / 'tests' / 'run_cases.py', '--cases', cases, '--tool', tool])
check(r.returncode == 0, f'E07 cases: {r.stdout[-1500:]}{r.stderr[-800:]}')
print(r.stdout.strip().splitlines()[-1] if r.stdout.strip() else 'E07 cases: no output')

# ---- symbols (toolchain observation) ------------------------------------------------------------------------------------
if shutil.which('nm'):
    for obj, allowed in (('decode.o', {'decode_one', 'format_instruction', 'decode_stream'}), ('decode8086.o', {'read_input', 'main'})):
        r = run(['nm', '-g', '--defined-only', build / obj])
        syms = {l.split()[-1] for l in r.stdout.splitlines() if l.strip()}
        check(syms == allowed, f'{obj} exports {sorted(syms)}, expected {sorted(allowed)}')

if failures:
    print(f'{len(failures)} check(s) failed')
    sys.exit(1)
print('PASS: oracle self-test, 5 demo drivers, 6 C contract suites (all encodings and every two-byte prefix), decode8086 '
      'command contract, objdump cross-check, E07 cases, symbols')

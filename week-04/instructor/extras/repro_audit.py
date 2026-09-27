"""S02(b): reproducibility audit. Build the E06 processor and the E07 summations with GCC and Clang at -O0 and -O2,
run each, and compare the printed results bit for bit. Then, gated on FMA-capable hardware, repeat with
-ffp-contract=fast -march=x86-64-v3 (this violates the week's flag rules ONLY inside this labelled experiment) and
count the fused multiply-add instructions that were actually generated, so that "no difference" cannot be mistaken for
"nothing was contracted".
Run from week-04: python3 instructor/extras/repro_audit.py   (it is also part of `make verify`)."""
from pathlib import Path
import re
import shutil
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
out = root / 'build' / 'audit'
out.mkdir(parents=True, exist_ok=True)
STRICT = ['-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror']


def build(cc, opt, extra, program):
    exe = out / f'{program}_{cc}_{opt}_{"exp" if extra != ["-ffp-contract=off"] else "strict"}'
    subprocess.run([cc, *STRICT, opt, *extra, '-I', str(root / 'support'), str(root / 'instructor/src' / f'{program}.c'),
                    '-o', str(exe), '-lm'], check=True, capture_output=True, text=True)
    return exe


def count_fma(exe):
    if shutil.which('objdump') is None:
        return None
    text = subprocess.run(['objdump', '-d', str(exe)], check=True, capture_output=True, text=True).stdout
    return len(re.findall(r'\bvf(?:n?m)(?:add|sub)\d{3}[sp][sd]\b', text))


def audit(extra, label):
    results, fma = {}, {}
    for cc in ('gcc', 'clang'):
        if shutil.which(cc) is None:
            continue
        for opt in ('-O0', '-O2'):
            exes = [build(cc, opt, extra, p) for p in ('ex06', 'ex07')]
            results[(cc, opt)] = tuple(subprocess.run([str(e)], check=True, capture_output=True, text=True).stdout for e in exes)
            fma[(cc, opt)] = tuple(count_fma(e) for e in exes)
    baseline_key = next(iter(results))
    baseline = results[baseline_key]
    same = all(v == baseline for v in results.values())
    print(f'{label}: {len(results)} builds, printed outputs bit-for-bit identical: {same}')
    print('  fused multiply-add instructions generated (ex06, ex07) per build:', {f'{c} {o}': n for (c, o), n in fma.items()})
    if not same:
        for key, value in results.items():
            for program, got, want in zip(('ex06', 'ex07'), value, baseline):
                if got != want:
                    print(f'  {key} differs from {baseline_key} in {program}:')
                    for g, w in zip(got.splitlines(), want.splitlines()):
                        if g != w:
                            print(f'    got  {g}\n    want {w}')
    return same, baseline


strict_same, strict_out = audit(['-ffp-contract=off'], 'strict flags (-ffp-contract=off)')
assert strict_same, 'strict builds must agree bit for bit on this platform; investigate before trusting a result'
cpu = ' '.join(Path('/proc/cpuinfo').read_text().split()) if Path('/proc/cpuinfo').exists() else ''
if ' fma ' in cpu and ' avx2 ' in cpu:
    try:
        exp_same, exp_out = audit(['-ffp-contract=fast', '-march=x86-64-v3'], 'EXPERIMENT ONLY (-ffp-contract=fast -march=x86-64-v3)')
        print('experiment printed output differs from the strict output:', exp_out != strict_out)
    except subprocess.CalledProcessError as e:
        print('experiment skipped: compiler rejected the flags:', (e.stderr or '')[:200])
else:
    print('experiment skipped: no FMA/AVX2 reported by /proc/cpuinfo (gated observation)')
sys.exit(0)

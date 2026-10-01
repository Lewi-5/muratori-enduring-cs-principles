"""Record actual optimized benchmarks, not expected performance fixtures."""
from pathlib import Path
import json, subprocess, hashlib
from datetime import datetime, timezone
root=Path(__file__).resolve().parents[1]
out=root/'instructor/sample-bench';out.mkdir(parents=True,exist_ok=True)
records=[]
for cc in ['gcc','clang']:
    build=root/'build/instructor'/cc/'optimized/bench'
    subprocess.run(['make','PACKAGE=instructor',f'CC={cc}','MODE=optimized','all'],cwd=root,check=True)
    rows=[]
    for n in [16,64,256,1024]:
        lines=subprocess.check_output([str(build),str(n),'9'],text=True).splitlines()
        rows.extend(lines if not rows else lines[1:])
    (out/(cc+'.csv')).write_text('\n'.join(rows)+'\n',encoding='utf-8')
    records.append(dict(compiler=subprocess.check_output([cc,'--version'],text=True).splitlines()[0],target=subprocess.check_output([cc,'-dumpmachine'],text=True).strip(),csv=cc+'.csv'))
sources=['support/bench.c']+['instructor/src/'+name+'.c' for name in ['insertion','merge','radix','summary']]
metadata=dict(date=datetime.now(timezone.utc).date().isoformat(),kernel=subprocess.check_output(['uname','-r'],text=True).strip(),
    flags='-std=c11 -Wall -Wextra -Wpedantic -Werror -Wconversion -Wsign-conversion -ffp-contract=off -fno-lto -O2 -g',
    timer='CLOCK_MONOTONIC',sizes=[16,64,256,1024],repeats=9,warmups=1,records=records,
    hashes={s:hashlib.sha256((root/s).read_bytes()).hexdigest() for s in sources},
    policy='Reset outside timing; instrumented sort inside; validation/checksum outside. Fixed algorithm order. Warm-cache favorable trials; no universal crossover or speed claim.')
(out/'environment.json').write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8')
print('PASS recorded actual GCC/Clang optimized rows for four sizes and four shapes')

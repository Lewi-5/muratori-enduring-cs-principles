from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parents[1];build=Path(sys.argv[1]).resolve()
r=subprocess.run([str(build/'playground')],capture_output=True,text=True)
assert r.returncode==0 and r.stdout==(root/'fixtures/playground.txt').read_text(),r
r=subprocess.run([str(build/'bench')],capture_output=True,text=True);assert r.returncode==0 and not r.stderr,r
lines=r.stdout.splitlines()
if root.name=='week-13':
    samples=[s.split(',') for s in lines if s.startswith('sample,')]
    assert len(samples) in (18,36)
    for s in samples: assert int(s[3])>=0 and int(s[4])==(0 if s[1].startswith('empty-') else 4202496) and s[5] in ('0','1')
else:
    assert len(lines)==9
    for line in lines:
        s=line.split(',');assert s[0]=='pair' and int(s[2])>=0 and int(s[3])>=0 and int(s[5])==4202496 and int(s[7])==33
with open('/dev/full','w') as full:
    r=subprocess.run([str(build/'bench')],stdout=full,stderr=subprocess.PIPE);assert r.returncode!=0
print('PASS exact playground, real measurement structure/checksums and output failure')

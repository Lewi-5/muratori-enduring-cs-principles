from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parents[1];build=Path(sys.argv[1]).resolve()
r=subprocess.run([str(build/'playground')],capture_output=True,text=True)
assert r.returncode==0 and r.stdout==(root/'fixtures/playground.txt').read_text(),r
r=subprocess.run([str(build/'bench')],capture_output=True,text=True);assert r.returncode==0 and not r.stderr,r
lines=r.stdout.splitlines()
if root.name=='week-13':
    samples=[s.split(',') for s in lines if s.startswith('sample,')]
    assert len(samples) in (18,27)
    for s in samples: assert int(s[3])>=0 and int(s[4])==(0 if s[1]=='empty-ns' else 4202496) and s[5] in ('0','1')
else:
    assert len(lines)==9
    for line in lines:
        s=line.split(',');assert s[0]=='pair' and int(s[2])>=0 and int(s[3])>=0 and int(s[5])==4202496 and int(s[7])==33
        assert s[4]=='NA' if int(s[2])==0 else abs(float(s[4])-(int(s[3])-int(s[2]))/int(s[2]))<=0.00000051
    outer=subprocess.run([str(build/'bench'),'outer'],capture_output=True,text=True)
    assert outer.returncode==0 and not outer.stderr and len(outer.stdout.splitlines())==9
    for line in outer.stdout.splitlines():
        s=line.split(',');assert int(s[5])==4202496 and int(s[7])==1
    assert subprocess.run([str(build/'bench'),'bad'],capture_output=True).returncode!=0
with open('/dev/full','w') as full:
    r=subprocess.run([str(build/'bench')],stdout=full,stderr=subprocess.PIPE);assert r.returncode!=0
print('PASS exact playground, real measurement structure/checksums and output failure')

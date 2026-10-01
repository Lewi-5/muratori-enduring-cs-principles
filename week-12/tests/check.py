"""Golden byte streams and independently calculated complete checkpoint traces."""
from pathlib import Path
import subprocess,sys,tempfile
root=Path(__file__).resolve().parents[1];build=Path(sys.argv[1]).resolve()
def run(code):
    with tempfile.TemporaryDirectory() as d:
        p=Path(d)/'program.bin';p.write_bytes(code)
        return subprocess.run([str(build/'sim8086'),str(p)],capture_output=True,text=True)
fixture=bytes.fromhex((root/'fixtures/program.hex').read_text())
r=run(fixture);assert r.returncode==0 and r.stdout==(root/'fixtures/program.txt').read_text() and not r.stderr,r
for name in ['wrap','push-sp']:
    r=run(bytes.fromhex((root/f'fixtures/{name}.hex').read_text()))
    assert r.returncode==0 and r.stdout==(root/f'fixtures/{name}.txt').read_text() and not r.stderr,(name,r)
r=subprocess.run([str(build/'playground')],capture_output=True,text=True)
assert r.returncode==0 and r.stdout==(root/'fixtures/playground.txt').read_text(),r
def flags(a,b,subtract,width):
    mod=2**width;value=(a-b if subtract else a+b)%mod
    signed=lambda v:v if v<mod//2 else v-mod
    full=signed(a)-signed(b) if subtract else signed(a)+signed(b)
    return value,(int(a<b if subtract else a+b>=mod)+4*int((value%256).bit_count()%2==0)
        +16*int(a%16<b%16 if subtract else a%16+b%16>=16)+64*int(value==0)
        +128*int(value>=mod//2)+2048*int(full < -mod//2 or full>=mod//2))
for count in range(1,129):
    code=bytearray(fixture);code[4]=count
    cpu=[0]*8;cpu[4]=256;ip=fl=0;mem={};expected=[]
    def emit(after,writes=()):
        global ip
        changed=[(a,v) for a,v in writes if mem.get(a,0)!=v]
        mem.update(writes)
        delta=','.join(f'{a:04x}:{v:02x}' for a,v in sorted(changed)) or '-'
        expected.append(f'{ip:04x} -> {after:04x}'+''.join(f' {name}={v:04x}' for name,v in zip(['ax','cx','dx','bx','sp','bp','si','di'],cpu))+f' flags={fl:04x} mem={delta}')
        ip=after
    cpu[3]=256;emit(3);cpu[1]=count;emit(6);emit(8)
    for turn in range(count):
        cpu[4]=254;emit(16,[(254,11),(255,0)])
        cpu[4]=252;emit(17,[(252,0),(253,0)])
        value,fl=flags(mem.get(256,0),1,False,8);emit(20,[(256,value)])
        cpu[4]=254;emit(21);cpu[4]=256;emit(11)
        cpu[1],next_flags=flags(cpu[1],1,True,16)
        fl=(next_flags & ~1)|(fl & 1) # DEC preserves the preceding carry
        emit(12);emit(8 if cpu[1] else 14)
    emit(22)
    steps=len(expected)
    expected.append(f'final ip=0016 ax=0000 cx=0000 bx=0100 sp=0100 flags=0044 data[0100]={count:02x} steps={steps}')
    r=run(code);assert r.returncode==0 and r.stdout=='\n'.join(expected)+'\n',(count,r)
for code,status in [(b'\xc3','M_STACK'),(b'\xeb\xfe','M_LIMIT'),(b'\x50\xe8','M_DECODE'),
                    (b'\xeb\x01\xff','M_DECODE'),(b'\xc6\x06\x00\x01\x07\xeb\xfa','M_TARGET'),
                    (b'\x90'*1025,'M_CAPACITY'),(b'\x90'*65536,'too large')]:
    r=run(code);assert r.returncode!=0 and not r.stdout and status in r.stderr,r
for code in [b'',b'\x90'*1024]:assert run(code).returncode==0
for args in [[],['/nonexistent/week12-file']]:
    r=subprocess.run([str(build/'sim8086'),*args],capture_output=True,text=True);assert r.returncode!=0 and not r.stdout
if Path('/dev/full').exists():
    with tempfile.TemporaryDirectory() as d:
        p=Path(d)/'empty.bin';p.write_bytes(b'')
        with open('/dev/full','wb') as f:r=subprocess.run([str(build/'sim8086'),str(p)],stdout=f,stderr=subprocess.PIPE,text=True)
        assert r.returncode!=0 and 'output error' in r.stderr
print('PASS hand golden, 128 independent call/loop/stack/memory traces, capacity and CLI failure checks')

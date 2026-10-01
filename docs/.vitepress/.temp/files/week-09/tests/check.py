"""Independent Python state oracle, CLI golden trace and failure checks."""
from pathlib import Path
import subprocess,sys,tempfile
build=Path(sys.argv[1]).resolve()
def run(code):
    with tempfile.TemporaryDirectory(prefix='week09-cli-') as d:
        p=Path(d)/'code.bin';p.write_bytes(code)
        return subprocess.run([str(build/'sim8086'),str(p)],text=True,capture_output=True)
fixture=bytes.fromhex(Path('fixtures/program.hex').read_text())
r=run(fixture);assert r.returncode==0 and r.stdout==Path('fixtures/program.txt').read_text(),r
r=subprocess.run([str(build/'playground')],text=True,capture_output=True)
assert r.returncode==0 and r.stdout==Path('fixtures/playground.txt').read_text(),r
# Independently calculate complete register/memory/flag trace of countdown loop
# for every byte count 1..255. Positive word CX is compared to zero by SUB;
# memory byte addition wraps even at count 255. Flags derived arithmetically.
def flags(a,b,sub,wide):
    mod=65536 if wide else 256
    result=(a-b if sub else a+b)%mod
    signed=lambda v:v if v<mod//2 else v-mod
    full=signed(a)-signed(b) if sub else signed(a)+signed(b)
    return (result,
        int(a<b if sub else a+b>=mod)
        +4*int((result%256).bit_count()%2==0)
        +16*int((a%16<b%16) if sub else (a%16+b%16>=16))
        +64*int(result==0)+128*int(result>=mod//2)
        +2048*int(full < -mod//2 or full>=mod//2))
for count in range(1,256):
    code=bytearray(fixture);code[1]=count
    expected=[];ip=ax=bx=cx=fl=data=steps=0
    def emit(after):
        global ip,steps
        expected.append(f'{ip:04x} -> {after:04x} ax={ax:04x} bx={bx:04x} cx={cx:04x} flags={fl:04x} mem[0100]={data:02x}')
        ip=after;steps+=1
    cx=count;emit(3);bx=256;emit(6);emit(9)
    for _ in range(count):
        data,fl=flags(data,1,False,False);emit(12)
        cx,fl=flags(cx,1,True,True);emit(15)
        emit(9 if cx else 17)
    ax=data;emit(19)
    expected.append(f'final ip=0013 ax={ax:04x} bx=0100 cx=0000 steps={steps} mem[0100]={data:02x}')
    r=run(code);assert r.returncode==0 and r.stdout=='\n'.join(expected)+'\n',(count,r)
for code,status in [(b'\xeb\xfe','M_LIMIT'),(b'\xeb\xff','M_TARGET'),
                    (b'\xb0\x07\xeb\xff','M_TARGET'),(b'\xeb\x01\xff','M_DECODE'),
                    (b'\xe9\x00','M_DECODE'),(b'\xc7\x06\x00','M_DECODE')]:
    r=run(code);assert r.returncode!=0 and not r.stdout and status in r.stderr,r
for code in [b'',b'\xeb\x00',b'\xe9\x00\x00']:
    r=run(code);assert r.returncode==0,r
r=run(bytes(65536));assert r.returncode!=0 and not r.stdout
r=subprocess.run([str(build/'sim8086')],text=True,capture_output=True);assert r.returncode!=0 and not r.stdout
r=subprocess.run([str(build/'sim8086'),'/nonexistent/week09-file'],text=True,capture_output=True);assert r.returncode!=0 and not r.stdout
print('PASS hand-derived golden trace, 255 independent complete loop traces, CLI failures and output transaction')

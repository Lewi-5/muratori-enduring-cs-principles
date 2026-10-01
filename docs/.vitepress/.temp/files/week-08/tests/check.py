from pathlib import Path
import argparse, subprocess, tempfile
from oracle import cases,trace_program
parser=argparse.ArgumentParser(); parser.add_argument('--build',required=True)
build=Path(parser.parse_args().build).resolve()
with tempfile.TemporaryFile(mode='w+') as file:
    for row in cases(): file.write(' '.join(map(str,row))+'\n')
    file.seek(0)
    subprocess.run([str(build/'oracle_probe')],stdin=file,check=True)
def run(data):
    with tempfile.NamedTemporaryFile() as file:
        file.write(data); file.flush()
        return subprocess.run([str(build/'sim8086'),file.name],text=True,capture_output=True)
# Independently encode and simulate programs; trace every state, not only final.
for wide in [0,1]:
    for reg in range(8):
        commands=[(0,wide,reg,127),(1,wide,reg,1),(3,wide,reg,-128),(2,wide,reg,-1),(0,wide,reg,0)]
        data,text=trace_program(commands); p=run(data)
        assert p.returncode==0 and p.stdout==text,p.stderr or p.stdout
for fixture in Path('fixtures').glob('*.hex'):
    p=run(bytes.fromhex(fixture.read_text())); assert p.returncode==0
    assert p.stdout==fixture.with_suffix('.txt').read_text(),p.stdout
for data,message in [(b'\xb8\x34\x12\x8b\x07','SIM_UNSUPPORTED_OPERAND at offset 3'),
                     (b'\xb8\x34\x12\xb9\x56','DEC_TRUNCATED at offset 3'),
                     (b'\xb0\x01\x90','DEC_UNSUPPORTED_OPCODE at offset 2'),
                     (b'\x81\x0e','DEC_UNSUPPORTED_OPERATION at offset 0')]:
    p=run(data); assert p.returncode!=0 and not p.stdout and message in p.stderr
p=run(b'\x00'*65537); assert p.returncode!=0 and not p.stdout and 'input too large' in p.stderr
p=run(b''); assert p.returncode==0 and p.stdout.startswith('final steps=0 |')
for argv,message in [([], 'usage'),(['nonexistent-file.bin'],'input error')]:
    p=subprocess.run([str(build/'sim8086'),*argv],text=True,capture_output=True)
    assert p.returncode!=0 and not p.stdout and message in p.stderr
play=subprocess.check_output([str(build/'playground')],text=True)
assert play==Path('fixtures/playground.txt').read_text()
print('PASS 16 independent state traces, golden programs, playground and CLI failures')

from pathlib import Path
import argparse, subprocess, tempfile
from oracle import cases
parser=argparse.ArgumentParser(); parser.add_argument('--build',required=True)
parser.add_argument('--cases',required=True)
args=parser.parse_args(); build=Path(args.build).resolve()
def run(data):
    with tempfile.NamedTemporaryFile() as f:
        f.write(data); f.flush()
        return subprocess.run([str(build/'decode8086'),f.name],capture_output=True,text=True)
# Chunking respects the CLI input cap; each case is compared in stream order.
batch=bytearray(); expected=[]; count=0
def compare():
    p=run(batch)
    assert p.returncode==0 and p.stdout=='bits 16\n'+'\n'.join(expected)+'\n',p.stderr or p.stdout[:500]
for encoded,text in cases():
    if len(batch)+len(encoded)>60000:
        compare(); batch=bytearray(); expected=[]
    batch.extend(encoded); expected.append(text); count+=1
compare()
for data,status,offset in [
    (b'\x89\xd9\x8b\x06\x34','DEC_TRUNCATED',2),
    (b'\x81\x0e','DEC_UNSUPPORTED_OPERATION',0),
    (b'\xc7\x0e','DEC_UNSUPPORTED_OPERATION',0),
    (b'\x26\x8b\x07','DEC_UNSUPPORTED_OPCODE',0),
    (b'\x82','DEC_UNSUPPORTED_OPCODE',0),
    (b'\x90','DEC_UNSUPPORTED_OPCODE',0)]:
    p=run(data); assert p.returncode!=0 and not p.stdout and f'{status} at offset {offset}' in p.stderr
p=run(b''); assert p.returncode==0 and p.stdout=='bits 16\n'
p=run(b'\x00'*65537); assert p.returncode!=0 and not p.stdout and 'too large' in p.stderr
p=subprocess.run([str(build/'decode8086'),'does-not-exist.bin'],capture_output=True,text=True)
assert p.returncode!=0 and not p.stdout and 'input error' in p.stderr
with tempfile.TemporaryDirectory() as other:
    p=subprocess.run([str(build/'client')],cwd=other,capture_output=True,text=True)
    assert p.returncode==0 and p.stdout=='api=7 mov ax, [bp - 2]\n',p.stderr
names=subprocess.check_output(['nm','-D','--defined-only',str(build/'libdecode.so')],text=True)
assert {line.split()[-1] for line in names.splitlines()}=={'decode_one','decode_stream','format_instruction','decoder_api_version'}
dynamic=subprocess.check_output(['readelf','-d',str(build/'client')],text=True)
assert 'libdecode.so' in dynamic and '$ORIGIN' in dynamic
for source in Path('fixtures').glob('*.hex'):
    p=run(bytes.fromhex(source.read_text())); assert p.returncode==0
    assert p.stdout==source.with_suffix('.txt').read_text()
hand_cases=[line for line in Path(args.cases).read_text().splitlines() if line.strip() and not line.startswith('#')]
assert len(hand_cases)>=5, 'E05 requires five hand-derived cases'
for line in hand_cases:
    encoded,expected,purpose=(part.strip() for part in line.split('|'))
    assert purpose, 'each case needs a stated defect/purpose'
    p=run(bytes.fromhex(encoded))
    if expected.startswith('DEC_'):
        assert p.returncode!=0 and not p.stdout and expected in p.stderr
    else:
        assert p.returncode==0 and p.stdout=='bits 16\n'+expected+'\n'
print(f'PASS {count} independently encoded cases, golden streams, CLI failures, shared client and exports')

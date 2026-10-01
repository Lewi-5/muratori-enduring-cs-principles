from pathlib import Path
import subprocess, sys, tempfile
build=Path(sys.argv[1]).resolve()
root=Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory() as directory:
    file=Path(directory)/'program.bin'
    file.write_bytes(bytes.fromhex((root/'fixtures/program.hex').read_text()))
    r=subprocess.run([str(build/'sim8086'),str(file)],capture_output=True,text=True)
    assert r.returncode==0 and r.stderr=='' and r.stdout==(root/'fixtures/program.txt').read_text(),r
    p=subprocess.run([str(build/'playground')],capture_output=True,text=True)
    assert p.returncode==0 and p.stdout==(root/'fixtures/playground.txt').read_text(),p
    for data,status in [(b'\xc3','M_STACK'),(b'\xe8\xfe\xff\x90','M_TARGET'),
                        (b'\x50\xe8','M_DECODE'),(b'\xeb\xfe','M_LIMIT'),
                        (b'\x90'*65536,'too large')]:
        file.write_bytes(data)
        r=subprocess.run([str(build/'sim8086'),str(file)],capture_output=True,text=True)
        assert r.returncode!=0 and r.stdout=='' and status in r.stderr,r
    for args in [[],[str(file.parent/'missing')]]:
        r=subprocess.run([str(build/'sim8086'),*args],capture_output=True,text=True)
        assert r.returncode!=0 and r.stdout=='' and r.stderr,r
    file.write_bytes(b'')
    r=subprocess.run([str(build/'sim8086'),str(file)],capture_output=True,text=True)
    assert r.returncode==0 and 'steps=0' in r.stdout,r
    if Path('/dev/full').exists():
        with open('/dev/full','wb') as full:
            r=subprocess.run([str(build/'sim8086'),str(file)],stdout=full,stderr=subprocess.PIPE,text=True)
        assert r.returncode!=0 and 'output error' in r.stderr,r
print('PASS golden traces and CLI errors')

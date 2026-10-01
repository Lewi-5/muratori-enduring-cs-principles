from pathlib import Path
import subprocess, sys
root=Path(__file__).resolve().parents[1]
build=Path(sys.argv[1]).resolve()
r=subprocess.run([str(build/'playground')],capture_output=True,text=True)
assert r.returncode==0 and r.stdout==(root/'fixtures/playground.txt').read_text(encoding='utf-8'),r
print('PASS deterministic playground output')

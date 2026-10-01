"""Capture one reproducible host measurement; never assert a timing threshold."""
from pathlib import Path
import hashlib,json,platform,subprocess,sys
root=Path(__file__).resolve().parents[1]
cc,mode,package=sys.argv[1:] if len(sys.argv)==4 else ('gcc','optimized','learner')
assert cc in ('gcc','clang') and mode in ('debug','optimized') and package in ('learner','instructor')
subprocess.run(['make',f'CC={cc}',f'MODE={mode}',f'PACKAGE={package}','all'],cwd=root,check=True)
exe=root/'build'/package/cc/mode/'bench'
result=subprocess.run([str(exe)],check=True,capture_output=True,text=True)
folder=root/'build/measurements'/package/cc/mode;folder.mkdir(parents=True,exist_ok=True)
(folder/'raw.csv').write_text(result.stdout,encoding='utf-8')
cpu=Path('/proc/cpuinfo').read_text().splitlines()
manifest={'compiler':subprocess.check_output([cc,'--version'],text=True).splitlines()[0],
 'platform':platform.platform(),'machine':platform.machine(), 'cpu':next((x for x in cpu if x.startswith('model name')),'unknown'),
 'package':package,'mode':mode,'command':[str(exe)],'samples':9,'points':512,'folds_per_batch':32,'checksum':4202496,
 'flags':'C11 strict warnings; POSIX 200809; fno-lto; ffp-contract=off; '+('-O0 -g' if mode=='debug' else '-O2 -g'),
 'sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(root.rglob('*')) if p.is_file() and 'build' not in p.relative_to(root).parts and p.suffix in ('.c','.h')},
 'binary_sha256':hashlib.sha256(exe.read_bytes()).hexdigest(),'raw_sha256':hashlib.sha256(result.stdout.encode()).hexdigest()}
(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print('Captured',folder.relative_to(root))

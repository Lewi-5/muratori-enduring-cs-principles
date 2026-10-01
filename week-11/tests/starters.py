from pathlib import Path
import subprocess
for cc in ['gcc','clang']:
    build=Path('build/learner')/cc/'debug'
    for name in ['contracts','warmups','playground']:
        if name=='contracts': subprocess.run(['make','PACKAGE=learner',f'CC={cc}',str(build/name)],check=True)
        r=subprocess.run([str(build/name)],capture_output=True)
        assert r.returncode!=0,f'{cc} {name} untouched scaffold passed unexpectedly'
print('PASS warning-clean starters fail correctness gates')

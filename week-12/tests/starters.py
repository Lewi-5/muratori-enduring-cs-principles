from pathlib import Path
import subprocess
for cc in ['gcc','clang']:
    build=Path('build/learner')/cc/'debug'
    for name in ['contracts','warmups','playground']:
        if name=='contracts':
            subprocess.run(['make','PACKAGE=learner',f'CC={cc}',str(build/name)],check=True)
        r=subprocess.run([str(build/name)],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        assert r.returncode!=0, f'{cc} untouched {name} unexpectedly passed'
print('PASS warning-clean learner scaffolds fail meaningful correctness checks')

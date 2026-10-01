import subprocess
for cc in ['gcc','clang']:
    build=f'build/learner/{cc}/debug'
    for binary in ['contracts','warmups']:
        subprocess.run(['make',f'CC={cc}',f'{build}/{binary}'],check=True,stdout=subprocess.DEVNULL)
        p=subprocess.run([f'{build}/{binary}'],capture_output=True)
        assert p.returncode!=0, f'{binary}: unfinished learner work unexpectedly passed'
print('PASS: warning-clean starters fail meaningful correctness gates')

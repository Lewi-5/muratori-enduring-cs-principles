"""Check the beginner's exact checked-in code and displayed output."""
from pathlib import Path
import re, subprocess, tempfile
root=Path(__file__).resolve().parents[2]
page=(root/'docs/content/beginners/week-15.md').read_text(encoding='utf-8')
fence=r'\n```[a-z]*\n(.*?)\n```'
code=re.search(r'<!-- snippet:example -->'+fence,page,re.S).group(1)
expected=re.search(r'<!-- output:example -->'+fence,page,re.S).group(1)+'\n'
source=root/'docs/examples/week-15/example.c'
assert source.read_text(encoding='utf-8').rstrip('\n')==code
with tempfile.TemporaryDirectory() as directory:
    for cc in ['gcc','clang']:
        for level in ['-O0','-O2']:
            exe=Path(directory)/f'example-{cc}{level}'
            subprocess.run([cc,'-std=c11','-Wall','-Wextra','-Wpedantic','-Werror',
                            '-Wconversion','-Wsign-conversion',level,str(source),'-o',str(exe)],check=True)
            result=subprocess.run([str(exe)],check=True,capture_output=True,text=True)
            assert result.stdout==expected,(cc,level,result.stdout)
print('PASS checked beginner snippet and exact output: GCC/Clang at O0/O2')

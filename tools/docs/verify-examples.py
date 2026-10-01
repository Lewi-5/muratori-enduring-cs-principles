"""Compile the chapter's exact worked inputs against unchanged reference code.

Run with python3 from Linux/WSL. All generated C and executables stay in /tmp.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, subprocess, tempfile, platform

root=Path(__file__).resolve().parents[2]
records=[]
examples=[
    (2,3,'''MemberSpec m[]={{1,1},{8,8},{4,4}}; size_t o[3],s,a;
assert(predict_layout(m,3,o,&s,&a));
assert(o[0]==0 && o[1]==8 && o[2]==16 && s==24 && a==8);
puts("offsets=0,8,16 size=24 alignment=8");'''),
    (2,4,'''FieldSpan f[]={{0,1},{8,8},{16,4}}; char out[25];
assert(layout_map(f,3,24,out,sizeof out));
assert(strcmp(out,"A.......BBBBBBBBCCCC....")==0); puts(out);'''),
    (3,1,'''DoubleParts p; assert(GEO_IEC559);
assert(decompose_double(0.75,&p));
assert(p.sign==0 && p.exponent==1022 && p.fraction==UINT64_C(0x8000000000000));
puts("0.75: sign=0 exponent=1022 fraction=0x8000000000000");'''),
    (4,2,'''char out[22]; assert(format_record(7,-5,10,out,sizeof out));
assert(strcmp(out,"7,-0.000005,0.000010\\n")==0 && strlen(out)==21);
puts("record=20 visible characters + LF; capacity=22 including NUL");''')
]
with tempfile.TemporaryDirectory(prefix='enduring-doc-examples-') as directory:
    work=Path(directory)
    for week,exercise,body in examples:
        package=root/f'week-{week:02}'
        source=package/f'instructor/src/ex{exercise:02}.c'
        harness=work/f'w{week}e{exercise}.c'
        harness.write_text(f'#include <assert.h>\n#define main original_demo_main\n#include "{source.as_posix()}"\n#undef main\nint main(void){{\n{body}\nreturn 0;\n}}\n')
        for cc in ['gcc','clang']:
            exe=work/f'w{week}e{exercise}-{cc}'
            subprocess.run([cc,'-std=c11','-Wall','-Wextra','-Wpedantic','-Werror','-ffp-contract=off','-I',str(package/'support'),str(harness),'-lm','-o',str(exe)],check=True)
            result=subprocess.run([str(exe)],check=True,text=True,capture_output=True)
            records.append(dict(week=week,exercise=exercise,compiler=cc,output=result.stdout))
            print(cc,result.stdout.strip())
# Beginner pages: every `<!-- snippet:NAME -->` code block must equal docs/examples/week-NN/NAME.c, and every
# `<!-- output:NAME -->` block must equal what that file prints under GCC and Clang at -O0 and -O2 with the
# course flags. A mismatch fails the run, so a page cannot show output that the code does not produce.
import re
fence=r'\n```[a-z]*\n(.*?)\n```'
snippet_pages=sorted((root/'docs/content/beginners').glob('week-*.md'))
with tempfile.TemporaryDirectory(prefix='enduring-beginner-snippets-') as directory:
    work=Path(directory)
    for page in snippet_pages:
        text=page.read_text(encoding='utf-8')
        examples=root/'docs/examples'/page.stem
        codes=dict(re.findall(r'<!-- snippet:(\w+) -->'+fence, text, re.S))
        outputs=dict(re.findall(r'<!-- output:(\w+) -->'+fence, text, re.S))
        assert set(outputs) <= set(codes), f'{page.name}: output without a shown snippet: {set(outputs)-set(codes)}'
        for name, code in codes.items():
            source=examples/f'{name}.c'
            assert source.read_text(encoding='utf-8').rstrip('\n')==code, f'{page.name}: snippet {name} differs from {source}'
            for cc in ['gcc','clang']:
                for level in ['-O0','-O2']:
                    exe=work/f'{page.stem}-{name}-{cc}{level}'
                    subprocess.run([cc,'-std=c11','-Wall','-Wextra','-Wpedantic','-Werror','-ffp-contract=off',level,str(source),'-lm','-o',str(exe)],check=True)
                    result=subprocess.run([str(exe)],check=True,text=True,capture_output=True).stdout
                    if name in outputs:
                        assert result.rstrip('\n')==outputs[name], f'{page.name}: output of {name} ({cc} {level}) differs:\n{result}'
                    records.append(dict(page=page.name,snippet=name,compiler=cc,level=level,output=result))
            print('beginner', page.stem, name, 'matches' if name in outputs else 'compiles')
environment={name:subprocess.check_output(args,text=True).splitlines()[0] for name,args in {'gcc':['gcc','--version'],'clang':['clang','--version'],'make':['make','--version'],'python':['python3','--version'],'binutils':['objdump','--version']}.items()}
report=dict(checkedAt=datetime.now(timezone.utc).isoformat(),platform=platform.platform(),environment=environment,results=records)
(root/'tools/docs/example-validation.json').write_text(json.dumps(report,indent=2)+'\n')

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
environment={name:subprocess.check_output(args,text=True).splitlines()[0] for name,args in {'gcc':['gcc','--version'],'clang':['clang','--version'],'make':['make','--version'],'python':['python3','--version'],'binutils':['objdump','--version']}.items()}
report=dict(checkedAt=datetime.now(timezone.utc).isoformat(),platform=platform.platform(),environment=environment,results=records)
(root/'tools/docs/example-validation.json').write_text(json.dumps(report,indent=2)+'\n')

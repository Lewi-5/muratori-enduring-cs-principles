"""Run documentation-relevant C checks in an isolated Linux temporary copy."""
from pathlib import Path
import json, shutil, subprocess, tempfile, time
root=Path(__file__).resolve().parents[2]
workspace=Path(tempfile.mkdtemp(prefix='enduring-docs-'))
results=[]
def run(cwd,args,expected=0):
    started=time.monotonic()
    result=subprocess.run(args,cwd=cwd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    entry=dict(week=cwd.name,command=args,exitCode=result.returncode,expectedExit=expected,seconds=round(time.monotonic()-started,2),tail=result.stdout[-4500:])
    entry['passed']=result.returncode==0 if expected==0 else result.returncode!=0
    results.append(entry)
    print(cwd.name,'PASS' if entry['passed'] else 'FAIL',' '.join(args),flush=True)
    return result
for f in ['PLAN.md','README.md','solPlan.md','analysis.md','WRITINGFORBEGINNERS.md','computerEnhanceTOC.txt','rawTranscript.txt','handmadeHeroLessonList.txt','relevantHHLessons.txt']:
    shutil.copy2(root/f,workspace/f)
shutil.copytree(root/'docs/content',workspace/'docs/content')
week_numbers=[w['n'] for w in json.loads((root/'tools/docs/catalogue.json').read_text(encoding='utf-8'))]
for n in week_numbers:
    week=f'week-{n:02}'
    shutil.copytree(root/week,workspace/week,ignore=shutil.ignore_patterns('build','__pycache__','results','build-docs-check.log'))
for n in week_numbers:
    cwd=workspace/f'week-{n:02}'
    if n==5: run(cwd,['make','PACKAGE=instructor','expected'])
    run(cwd,['make','PACKAGE=instructor','CC=gcc','MODE=debug','test'])
    run(cwd,['make','PACKAGE=instructor','CC=clang','MODE=optimized','test'])
    run(cwd,['make','starters'])
    run(cwd,['make','test'],expected=1)
    if n==1:
        demo=run(cwd,['build/instructor/gcc/debug/ex06'])
        assert demo.stdout.strip()=='index=16 pointer=16'
    if n==6:
        run(cwd,['python3','tools/hex2bin.py','t.bin','89','d9','83','c6','fe'])
        demo=run(cwd,['build/instructor/gcc/debug/decode8086','t.bin'])
        assert demo.stdout=='bits 16\nmov cx, bx\nadd si, -2\n'
        run(cwd,['objdump','-D','-b','binary','-m','i8086','-M','intel','t.bin'])
assert len('7,-0.000005,0.000010')==20
report={'temporaryCopy':str(workspace),'results':results,'allPassed':all(r['passed'] for r in results)}
(root/'tools/docs/course-validation.json').write_text(json.dumps(report,indent=2)+'\n')
raise SystemExit(0 if report['allPassed'] else 1)

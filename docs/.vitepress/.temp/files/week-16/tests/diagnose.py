"""Expected failures run in child processes; no broken program is a normal lab."""
from pathlib import Path
import subprocess, os
root=Path(__file__).resolve().parents[1]
out=root/'build/diagnostics';out.mkdir(parents=True,exist_ok=True)
for cc in ['gcc','clang']:
    result=subprocess.run([cc,'-std=c11','-Wall','-Wextra','-Wpedantic','-Werror','-c','bugs/return_local.c','-o',str(out/(cc+'-local.o'))],cwd=root,capture_output=True,text=True)
    assert result.returncode!=0 and ('return-local-addr' in result.stderr or 'return-stack-address' in result.stderr),result
    (out/(cc+'-local.txt')).write_text(result.stderr)
    for name,diagnostic in [('use_after_free','heap-use-after-free'),('double_free','double-free')]:
        exe=out/(cc+'-'+name)
        subprocess.run([cc,'-std=c11','-O0','-g','-fsanitize=address','-fno-omit-frame-pointer','-no-pie','bugs/'+name+'.c','-o',str(exe)],cwd=root,check=True)
        env=dict(os.environ,ASAN_OPTIONS='detect_leaks=0:abort_on_error=0:halt_on_error=1')
        result=subprocess.run([str(exe)],cwd=root,capture_output=True,text=True,env=env)
        assert result.returncode!=0 and diagnostic in result.stderr,(cc,name,result)
        (out/(cc+'-'+name+'.txt')).write_text(result.stderr)
print('PASS two compiler lifetime warnings and four isolated expected ASan failures')

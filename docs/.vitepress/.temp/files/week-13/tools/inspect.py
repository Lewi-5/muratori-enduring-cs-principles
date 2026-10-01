"""Produce real compiler/object artifacts; never require one instruction listing."""
from pathlib import Path
import hashlib, json, subprocess, sys
root=Path(__file__).resolve().parents[1]
cc, mode, package=sys.argv[1:4]
assert mode in ['debug','optimized'] and package in ['learner','instructor']
build=root/'build'/package/Path(cc).name/mode/'inspection'
build.mkdir(parents=True,exist_ok=True)
flags=['-D_POSIX_C_SOURCE=200809L','-std=c11','-Wall','-Wextra','-Wpedantic','-Werror','-ffp-contract=off','-fno-lto',
       '-O0' if mode=='debug' else '-O2','-g','-gdwarf-4','-Iinclude','-Isupport']
sources=[f'{package}/src/{name}' for name in ['clock.c', 'sample.c', 'summary.c', 'rate.c']]+['support/kernel.c','support/counter.c']
records=[]
for source in sources:
    name=Path(source).stem
    obj=build/(name+'.o'); asm=build/(name+'.s'); dump=build/(name+'.txt')
    subprocess.run([cc,*flags,'-c',source,'-o',str(obj)],cwd=root,check=True)
    # Clang 14's cpuid.h contains AT&T inline assembly that fails when its
    # surrounding assembly dialect is Intel. Keep native syntax for this
    # one source; objdump below still provides an Intel-syntax object view.
    syntax=[] if Path(cc).name=='clang' and source=='support/counter.c' else ['-masm=intel']
    subprocess.run([cc,*flags,'-S',*syntax,'-fverbose-asm',source,'-o',str(asm)],cwd=root,check=True)
    dump.write_text(subprocess.check_output(['objdump','-dr','-Mintel',str(obj)],text=True),encoding='utf-8')
    records.append(dict(source=source,sha256=hashlib.sha256((root/source).read_bytes()).hexdigest(),
                        assembly=asm.name,assembly_syntax='Intel' if syntax else 'AT&T',disassembly=dump.name))
manifest=dict(compiler=subprocess.check_output([cc,'--version'],text=True).splitlines()[0],
              target=subprocess.check_output([cc,'-dumpmachine'],text=True).strip(),
              mode=mode,package=package,flags=flags,sources=records,
              caveat='Disassembly and assembly are observations; neither is a cycle measurement or universal C translation.')
(build/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print('PASS generated compiler assembly, relocated object disassembly and manifest:',build.relative_to(root))

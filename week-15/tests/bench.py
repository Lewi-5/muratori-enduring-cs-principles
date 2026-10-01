from pathlib import Path
import csv, io, subprocess, sys
build=Path(sys.argv[1]).resolve()
result=subprocess.run([str(build/'bench'),'64','3'],capture_output=True,text=True,check=True)
rows=list(csv.DictReader(io.StringIO(result.stdout)))
assert len(rows)==12
for shape in ['sorted','reverse','random','duplicates']:
    selected=[r for r in rows if r['shape']==shape]
    assert {r['algorithm'] for r in selected}=={'insertion','merge','radix'}
    assert len({r['checksum'] for r in selected})==1
    for row in selected:
        assert row['n']=='64' and row['repeat']=='3'
        assert int(row['min_ns'])<=float(row['median_ns'])<=int(row['max_ns'])
        assert int(row['min_ns'])<=float(row['mean_ns'])<=int(row['max_ns'])
for args in [['0'],['65537'],['-1'],['x'],['3','0'],['3','65'],['3','2','extra']]:
    result=subprocess.run([str(build/'bench'),*args],capture_output=True,text=True)
    assert result.returncode==2 and not result.stdout and 'usage:' in result.stderr
print('PASS benchmark reset/consumption, twelve result rows and malformed arguments; no speed threshold')

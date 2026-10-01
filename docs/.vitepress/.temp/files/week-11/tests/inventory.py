from pathlib import Path
import re
import os
os.chdir(Path(__file__).resolve().parents[1])
learner=[]; answers=[]
pattern=r'^### ((?:E\d{2}\.[CQ])|(?:[PSRWF]\d{2}))\s*$'
for name in ['exercises','practice','observations','warmups','reading-questions']:
    learner += re.findall(pattern,Path(f'learner/{name}.md').read_text(encoding='utf-8'),re.M)
for name in ['answers','observations','warmups','reading-answers']:
    answers += re.findall(pattern,Path(f'instructor/{name}.md').read_text(encoding='utf-8'),re.M)
assert len(learner)==len(set(learner)) and len(answers)==len(set(answers))
assert set(learner)==set(answers),(set(learner)-set(answers),set(answers)-set(learner))
expected={f'E{k:02}.{part}' for k in range(1,6) for part in ['C','Q']} | {f'P{k:02}' for k in range(1,7)} | {f'S{k:02}' for k in range(1,3)} | {f'R{k:02}' for k in range(1,6)} | {f'W{k:02}' for k in range(1,4)} | {f'F{k:02}' for k in range(1,4)}
assert set(learner)==expected
print(f'PASS {len(learner)} prompts and separate answers')

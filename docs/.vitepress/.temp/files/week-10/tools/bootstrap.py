"""One-time package assembly; preserves completed prerequisite code verbatim."""
from pathlib import Path
import shutil

root = Path(__file__).resolve().parents[2]
week = root / 'week-10'
for directory in ['include', 'support/decoder', 'support/alu', 'learner/src',
                  'instructor/src', 'tests', 'fixtures']:
    (week / directory).mkdir(parents=True, exist_ok=True)
for name in ['decode.h', 'decode.c', 'address.h', 'address.c', 'format.c']:
    shutil.copyfile(root / 'week-08/support/decoder' / name, week / 'support/decoder' / name)
for name in ['registers.c', 'alu.c']:
    shutil.copyfile(root / 'week-08/instructor/src' / name, week / 'support/alu' / name)
shutil.copyfile(root / 'week-08/include/sim.h', week / 'support/alu/sim.h')

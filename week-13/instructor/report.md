# Week 13 reference report

## Prediction and deterministic observation

The injected intervals are 10,40,30,20, giving min 10/lower median 20/max 40 and four work calls with checksum 42. A sixth-read collection failure leaves the complete output unchanged after three tasks have already run. Normalized 18,446,744,073 seconds plus 709,551,615 ns is exactly UINT64_MAX; one more ns fails.

The exact playground output is checked against fixtures/playground.txt. The deterministic C tests include 10,000 calculated conversion cases, range/error cases and failure snapshots. These tests cover the stated domains and are not a proof for every possible program.

## Actual host measurements

- [gcc/debug raw CSV](evidence/gcc-debug/raw.csv) and [manifest](evidence/gcc-debug/manifest.json).
- [gcc/optimized raw CSV](evidence/gcc-optimized/raw.csv) and [manifest](evidence/gcc-optimized/manifest.json).
- [clang/debug raw CSV](evidence/clang-debug/raw.csv) and [manifest](evidence/clang-debug/manifest.json).
- [clang/optimized raw CSV](evidence/clang-optimized/raw.csv) and [manifest](evidence/clang-optimized/manifest.json).

| Compiler/mode | Work lower median (ns) | Empty lower median (ns) | Counter lower medians (ticks) |
| --- | ---: | ---: | --- |
| gcc/debug | 23697 | 20 | work 70060 ticks; empty 76 ticks |
| gcc/optimized | 19664 | 76 | work 50198 ticks; empty 156 ticks |
| clang/debug | 41280 | 19 | work 27514 ticks; empty 84 ticks |
| clang/optimized | 4360 | 21 | work 13216 ticks; empty 80 ticks |

Host: `Linux-6.18.40.1-microsoft-standard-WSL2-x86_64-with-glibc2.35`; `model name	: 12th Gen Intel(R) Core(TM) i7-12650H`. GCC/Clang versions and complete source/binary/raw hashes are in each manifest. Workload: 512 points, 32 folds, checksum 4202496. Samples are nine per group, with all raw values retained; comparisons use lower ranked median. These are observations from this host, not goldens or pass thresholds.

The read-resolution query reported 1 ns on the captured host. It does not establish 1 ns read cost or accuracy. Work and empty intervals use different code paths. Optional calibration retains ns/tick windows and an empirical ratio; AUX differences are diagnostics, equal AUX is not proof of no migration, and the result is not core execution frequency. The counter reader follows the stated Intel ordering assumptions; synchronization and virtualization remain limits.

## Actual emitted code

The GCC 11.4 optimized kernel adds one 64-bit ID per iteration and advances the pointer by 0x18. Clang 14’s optimized kernel emits a four-element unrolled body with loads at offsets 0,0x18,0x30,0x48 plus a remainder path. Both debug kernels preserve a more literal loop. The GCC optimized counter object contains LFENCE at 0xad, RDTSCP at 0xb0 and LFENCE at 0xc4 in this capture; both compilers emit the fenced sequence. CPUID remains in the separate capability probe, outside timed intervals.

Clang 14’s cpuid.h has native AT&T inline assembly incompatible with -masm=intel for source assembly output. The inspection tool keeps native assembly for that one file, explicitly records its syntax, and still emits Intel object disassembly. This is a toolchain observation, not a counter semantic difference.

Regenerate with `make PACKAGE=instructor CC=gcc MODE=optimized inspect` and the other compiler/mode choices. The relevant artifacts are in `build/instructor/COMPILER/MODE/inspection`. Offsets and instruction choices are observations of these actual objects, not required translations or cycle counts.

## Claim and next experiment

Supported: the checked harness passes the specified deterministic domains and retains actual raw host measurements with correct checksums. Unsupported: the reported counter ratio equals a core’s current frequency or predicts every workload. A next experiment would choose a longer calibration window, record endpoint assumptions and repeat on a specified nonvirtualized target.

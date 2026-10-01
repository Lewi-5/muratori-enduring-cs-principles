# Week 11 — The ABI and generated x64 assembly

[Lesson](../docs/content/weeks/week-11.md) · [Beginner section](../docs/content/beginners/week-11.md) · [Further reading](../docs/content/further-reading/week-11.md)

Week 10's CALL saves a continuation, but that alone does not tell separately compiled routines where arguments arrive or which registers survive. This week connects C functions to the System V AMD64 LP64 calling convention and compares debug/optimized compiler output for real geolab functions. All substantial authored software is C. There is one optional 16-line handwritten assembly probe; no simulator assembly is introduced.

Bring [Week 5](../week-05/README.md)'s scalar geolab, [Week 7](../week-07/README.md)'s translation units and [Week 10](../week-10/README.md)'s saved return words. You will classify simple scalar signatures, implement checked wrappers and an ID fold, follow an indirect callback, inspect compiler assembly plus object relocations, and explain an optimized-away local. Distinguish ISA semantics, ABI agreements, compiler choices and microarchitecture prediction.

## Build and inspect

Use x86-64 Linux/WSL, GCC, Clang, C11, make, Python 3.10+ and binutils. This is the Linux System V convention, not Windows x64. From week-11:

```sh
make
make test
make warmups
make inspect
make MODE=optimized inspect
make CC=clang MODE=optimized inspect
make PACKAGE=instructor probe
make verify
```

Default builds compile typed learner stubs; correctness gates fail until implementation. The four learner modules own the scalar planner, wrappers, fold and callback. Completed Week 5 geo/query sources are pinned in support/geolab; no Week 11 solution is linked into the default learner build. support/local.c and playground.c are supplied observation subjects/drivers. `make verify` checks both compilers in debug, optimized and sanitizer modes, untouched starter failures, the one reference probe and the beginner output. [Validation](instructor/validation.md) records actual runs.

`make inspect` accepts debug or optimized mode and generates an inspection directory under the selected build: Intel-syntax compiler `.s`, relocated object disassembly `.txt`, and manifest.json with compiler version/target, exact flags and source SHA-256. No LTO, fast-math or march=native is used. Files are compiler observations and must not be replaced by an invented required instruction sequence. Compare wrappers, fold, callback, supplied local_example, geo_distance_km and query_hit_compare. Object CALL operands need relocation records to identify an unresolved external target; a compiler .s, object dump and final linked executable answer different questions.

Submit one graded assignment: E01–E05, actual annotated listings and R01–R05. Core estimate 600 minutes, unpiloted: viewing/reference 100, E01 80, E02 80, E03 80, E04 100, E05/report/practice 160. Beginner work adds 2–4 hours; optional stretch/further reading is additional. Record actual time.

## Restricted scalar ABI model

[lab.h](include/lab.h) specifies the API and error contracts. The planner models only fixed nonvariadic LP64 signatures with full-width integer, pointer and double arguments, at most 32. It is not a general ABI classifier: aggregates, vectors, long double, varargs, hidden return pointers and narrow-integer extension rules are outside its input domain.

| Item | System V rule used here |
| --- | --- |
| Integer/pointer arguments | RDI, RSI, RDX, RCX, R8, R9, then eight-byte stack slots |
| Double arguments | XMM0–XMM7 independently, then eight-byte stack slots |
| Scalar integer/status result | RAX or its appropriate low-width view; int uses EAX |
| Scalar double result | XMM0; geo_distance_km itself returns int, while writing distance through a pointer |
| Preserved GP registers | RBX, RBP, R12–R15; RSP must also be restored correctly |
| Caller-clobbered | Other GP registers and XMM registers in this convention |
| Ordinary entry RSP | RSP modulo 16 equals 8 after the eight-byte return push; caller RSP is aligned before CALL |
| First spilled argument | Entry RSP+8 before prologue; subsequent scalar spill slots follow in source order |

For this subset the planner assigns independent GP and XMM pools, spilling only an exhausted class. It rounds stack-argument reservation up to 16 from an initially aligned caller RSP, with padding above the highest argument. Those offsets describe callee entry, not a frame after pushes/subtractions. A real ABI can require greater alignment for excluded argument types. A leaf may use the ABI's 128-byte red zone below RSP; that is not storage a caller can keep live across a nested call.

The checked wrappers keep geolab's meaning. Four doubles reach geo_distance_km in XMM0–3 and its output pointer in RDI; its success status returns in EAX. query_hit_compare takes two object pointers in RDI/RSI and returns an ordering int. Locally assembled QueryHit values are objects needed for that pointer call, not evidence that every local needs a permanent stack slot. The unsigned ID fold wraps by defined C arithmetic. keep_across_call asks the compiler to retain seed and out across one indirect callback; either preserved registers or stack storage can satisfy that obligation.

## Prediction is not the architectural stack

Week 10's data word determines a modeled return destination. A modern return predictor can guess a likely destination earlier to guide fetching; the architectural RET operation still obtains the actual return target. Predictor state is not a C object, stack frame or extra source-level guarantee. Depth and behavior vary by processor. The simulator has no return predictor and a disassembly does not expose its prediction success. CE's historical cycle-estimation exercise illustrates an explicit cost model; do not attach 8086 instruction costs to modern x64 listings or equate instruction count with cycles.

## Read and watch

Direct pages, durations and HH markers were checked on 2026-10-01. View the two CE entries in full (50:17), and HH Chat 020 at 27:24–39:14 and 58:29–1:08:27 (21:48 total). Allow 90–110 minutes including ABI consultation and pauses. CE is required subscription material; all exercises and explanations are original.

- [CE: Estimating Cycles](https://www.computerenhance.com/p/estimating-cycles), 23:56: identify what a historical cost model assumes and omits.
- [CE: From 8086 to x64](https://www.computerenhance.com/p/from-8086-to-x64), 26:21: connect related instruction families without importing historical sizes/costs.
- [HH Chat 020](https://guide.handmadehero.org/chat/chat020/), indexed portions above: compare source and compiler assembly, including zeroing and removed work. Its compiler/Windows examples are observations, not System V rules.
- [System V x86-64 ABI draft 0.21](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf), §§3.2.1–3.2.3: register ownership, stack and scalar argument/result classification. This linked 2002 draft is identified as such; use the [maintained ABI repository](https://gitlab.com/x86-psABIs/x86-64-ABI) for later extensions, outside our scalar model.
- [Intel optimization reference, volume 1 revision 050](https://cdrdv2-public.intel.com/821612/248966-Optimization-Reference-Manual-V1-050.pdf), §3.4.1, branch prediction and return-address stack discussion: architecture-specific prediction, not a universal fixed depth.
- [GCC optimization options](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html) and [code-generation options](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html), O0/O2, LTO and verbose assembly; [Clang user manual](https://clang.llvm.org/docs/UsersManual.html), optimization/debugging and floating-point controls. Verify actual flags in each manifest.

## Source → mechanism → observation

C's call expression describes values and effects. The ABI assigns their boundary locations, and the compiler generates register moves, stack accesses and calls that implement those requirements. An optimized local may vanish into an expression while its numerical result stays unchanged. Compare actual artifacts, state which rule each instruction satisfies, and retain uncertainty about unmeasured timing and predictor behavior. Week 12 integrates the historical simulator and this modern comparison as Project 2.

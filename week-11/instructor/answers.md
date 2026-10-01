# Complete core, practice and stretch answers

### E01.C

Reference src/abi.c uses a local zero-initialized AbiPlan. Validate pointers/count, then walk types in source order. INTEGER/POINTER take successive GP slots when available; DOUBLE takes successive XMM slots. A full pool spills only that argument class, assigning the next eight-byte stack slot from entry RSP+8. At most 32 arguments keep all arithmetic bounded. Commit only after every type is valid; an invalid type late in the array leaves the original out unchanged. Rounding stack bytes up to sixteen assumes the caller is aligned before allocating its argument area, with padding on the high side.

The independent counter test is essential: one source-argument counter incorrectly assigns a pointer after four doubles to GP slot four. The prototype excludes aggregates, vectors, varargs and narrow scalar extension rules, so it cannot promise full ABI classification. Tests enumerate scalar counts and interleave pointer/double values to catch cross-pool interference. A zero-argument success initializes every field, including unused locations.

### E01.Q

| Function | Argument boundary locations | Result |
| --- | --- | --- |
| geo_distance_km(lat1,lon1,lat2,lon2,out) | XMM0, XMM1, XMM2, XMM3, RDI | int status in EAX; distance written through out |
| query_hit_compare(a,b) | RDI, RSI | ordering int in EAX |
| query_points(points,count,lat,lon,radius,hits,nhits) | RDI, RSI, XMM0, XMM1, XMM2, RDX, RCX | int status in EAX; pointer/count through output objects |

Seven scalar integer arguments use RDI,RSI,RDX,RCX,R8,R9 and entry RSP+8. The caller reserves sixteen bytes for one spilled word: eight bytes of value then eight bytes of high-address padding, under our aligned-start assumption. Nine double arguments use XMM0–7 and entry RSP+8, with the same restricted reservation. The double pool does not consume GP slots. Full ABI cases outside this domain can need more involved classifications/alignment and are not inferred from these two examples.

### E02.C

Reference src/wrappers.c delegates distance_to_origin to geo_distance_km with fixed origin doubles. The original routine validates coordinates and output before writing. The hit wrapper validates finite/nonnegative distances and a live output, creates two QueryHit objects and calls the original comparator, then writes the ordering. Direct relational ID comparisons preserve the whole uint64_t range; subtract-and-narrow can reverse order or collapse unequal values. NaN must be rejected because relational comparisons do not provide the required total order on it. Tests cover identical positions, a quarter-circle distance, invalid/NaN values, ties and extreme IDs.

The geolab code remains a completed prerequisite; learners implement wrappers, not a new Haversine algorithm. The objects passed by address to query_hit_compare must exist during the call. Under separate compilation without LTO, the callee's pointers are a genuine boundary even when the wrapper is otherwise optimized.

### E02.Q

distance_to_origin receives lat in XMM0, lon in XMM1 and out in RDI. Before entering geo_distance_km, the caller supplies zero in XMM0/XMM1, original lat in XMM2, original lon in XMM3; RDI remains the output pointer. The fifth source argument is the first GP-class argument because earlier doubles use the independent pool. In the recorded GCC 11.4 O2 wrapper, movapd moves lon to XMM3 and lat to XMM2, pxor clears XMM1, a move supplies XMM0, and a jmp has a geo_distance_km relocation. Different valid implementations may use different zeroing/move instructions.

The compiler .s contains symbolic expressions; the object contains encoded instructions plus relocation requests; linking resolves them into the executable's layout, possibly through dynamic-link stubs. A zero placeholder displacement cannot identify the final target. Here the optimized tail jump transfers using the caller's existing return word, so the distance routine returns directly to the original caller. That is a compiler choice preserving the C result, not evidence that source code had no function boundary or that every wrapper must tail-call.

### E03.C

Reference src/fold.c checks out and NULL/count before reading, accumulates uint64_t IDs, then commits out. Unsigned addition is defined modulo 2^64; UINT64_MAX+1+9 therefore produces 9. Coordinates do not affect this ID-only function, and no position validation is claimed. Empty input succeeds with zero. A signed accumulator would invoke undefined overflow for the supported domain; reading element zero before handling an empty input would be another fault.

Run tools/inspect.py via make inspect for each compiler/mode. In the loop annotation identify the field stride, termination, accumulator and final output store. On this LP64 platform GeoPoint has an ID followed by two doubles; tie the observed stride to sizeof/offset facts rather than a universal C layout assumption. Vectorized or differently structured loops are acceptable when they preserve the modular result. Pinning fast-math off matters for geo code, while unsigned addition has its own independent rules.

### E03.Q

The recorded GCC debug local_example stores value at RBP−0x18 and doubled at RBP−0x8 after a frame-pointer prologue. Its O2 output computes RDI+RDI+1 with LEA into RAX, then returns; no doubled stack slot is needed. The recorded Clang O2 output uses LEA for twice RDI then ADD one, also without that slot. These observations are reproduced in sample-assembly; neither sequence is mandatory under another configuration. Entry instrumentation such as endbr64 in the GCC sample is a toolchain/default observation, not the arithmetic operation or a required ABI prologue.

LEA evaluates its effective-address expression into a register; it does not dereference memory. The arithmetic result is the observable requirement, including unsigned wrapping. A local's source name does not force a physical write. Instruction count alone omits dependencies, memory behavior, fusion, execution resources, calls and prediction. It cannot supply elapsed cycles, and adding historical 8086 instruction costs to these modern listings is invalid.

### E04.C

Reference src/calls.c validates callback/out before calling. Save the logical seed value through ordinary C data dependence, invoke fn(seed+1) once, then write seed+result. The compiler implements the preservation, not hand-written inline asm. Callback effects are permitted and not rolled back by this API; unchanged output on invalid initial arguments is the narrower error contract. Tests record callback count and input, check modular max-value behavior and prove NULL output does not trigger callback execution.

In the recorded GCC O2 listing, RBP retains the output pointer and RBX retains seed, with both incoming registers saved/restored. The indirect call uses RSI, RDI holds seed+1, and the callback's uint64_t result arrives in RAX. The compiler adds saved seed and stores through the saved pointer, then returns int success in EAX. Stack storage or different preserved registers would also be valid. Merely assuming RDI/RDX survive the callback would violate caller-clobbered rules for a handwritten implementation.

### E04.Q

Caller-clobbered registers may change across a call; the caller must preserve any values it needs afterward. RBX,RBP,R12–R15 must have their incoming values restored by a callee that changes them, and RSP must return to the correct continuation position. A routine can save the incoming RBX then use it for seed; restoring at exit satisfies the ABI.

If P is RSP immediately before an ordinary CALL, P is sixteen-aligned. Callee entry has RSP=P−8 and remainder eight; PUSH RBX makes it P−16 and remainder zero. Further prologue allocation and nested-call preparation must maintain their own labeled alignment. A leaf red-zone observation does not justify storing live caller values there across a nested call: the nested return push and callee stack/red-zone usage can overlap them.

Architectural RET obtains the actual continuation from stack data. A return predictor guesses early to guide fetching; it has separate processor state and machine-dependent behavior. Our compiler listings cannot reveal whether those guesses were correct, predictor depth, penalties or measured cycles. The Week 10 simulator models the actual state transition only.

### E05.C

fixtures/playground.txt gives the deterministic consumed output: distance zero, hit ordering +1, folded IDs 16, callback result combination 31 and local result 15. The ABI planner's four-double/pointer example prints pointer GP index zero and no spill reservation. Tests run on actual code and input; a matching manifest does not by itself establish correctness.

Reference probe.S is sixteen lines: six register additions and the word at entry RSP+8 yield the seven-argument uint64_t sum in RAX. It changes only caller-clobbered RAX/flags, leaves RSP and preserved registers untouched and includes a non-executable-stack note. Tests cover 1..7→28, wrap and repeated values. Sanitizers instrument the C harness, not the probe's assembly instructions, so passing sanitizer mode is not a general proof of handwritten assembly memory safety. An entirely C-only core submission is acceptable; do not write a second assembly probe to expand scope.

Actual four-way assembly observations and toolchain manifests accompany the reference sample files. A complete submission annotates argument moves, return/status, preserved values, frame changes, at least one local-storage difference and one unresolved relocation. It permits another valid listing and does not invent timings.

### E05.Q

Week 10 saves two-byte near IP values within its simplified fixed code segment; an ordinary x64 near CALL stores an eight-byte return position. System V additionally specifies arguments, results, preservation and alignment. Those agreements are software interfaces built on instruction semantics, not supplied by CALL alone.

CE's 8086 estimates assume a particular historical instruction/addressing cost model. Modern x64 can overlap work, translate instructions into micro-operations, speculate and encounter caches or library calls; the old table cannot time this geolab. ABI-correct behavior and a return-target trace establish functional obligations, not prediction accuracy. Week 12 combines the tested historical subset, traces and a qualified x64 comparison into Project 2 while keeping cost assumptions explicitly separate.

### P01

Arguments use RDI, XMM0, RSI, XMM1 in source order. The pools count their own classes, not all prior source parameters. A scalar double result uses XMM0; an int result uses EAX. A pointer-written double is separate from an integer status result.

### P02

Reserve sixteen bytes from an aligned caller RSP. Put the spilled value at the low eight bytes and padding at the higher eight bytes. At callee entry the saved return occupies RSP..RSP+7, so argument seven is at RSP+8. After PUSH RBX, the same argument is at new RSP+16. The argument's absolute address is unchanged; the reference register moved.

### P03

The object displacement is not yet the final address. The relocation requests resolution of sin relative to the encoded operand. Inspect that record and the final linked code before claiming a target. A disassembler showing an apparent nearby address is displaying the unresolved bytes, not proving recursion. Compiler .s can show the symbolic operand more directly, but still does not establish final runtime linking.

### P04

A leaf can legally use the 128-byte System V red zone without allocating a conventional frame; entry RSP remainder eight is normal. It must obey alignment for actual accesses and calls, not force every instruction to have aligned RSP. A nonleaf cannot rely on that same below-RSP region to keep values live across its nested call. It can allocate explicit stack space or use/restorably borrow preserved registers.

### P05

doubled's automatic lifetime is a C semantic rule for the block execution. Its value can be folded into another expression without an addressable slot when observable behavior is preserved. Debug and optimized physical layouts can differ. Absence of a slot is not an expired source lifetime; conversely stale storage after return is not a live object.

### P06

Missing evidence includes target CPU, clock/timing method, workload, code paths, dependency lengths, cache state, call implementations and prediction/counter behavior. Equal counts can have unequal throughput/latency. RET shows the actual instruction operation; neither it nor its count reports predictor hits. A controlled later measurement is required before a speed claim.

### S01

Complete exemplar protocol: keep the existing geo_distance_km implementation and fixed correctness cases (identical, quarter-circle, invalid latitude, NaN); compare separate compilation with no LTO against a single C translation unit that includes completed geo.c and the wrapper. Use the same compiler/target, O2 and floating policy, changing only visibility to the optimizer. Run the same tests and consume out/status. Save both source hashes, commands and assembly; identify any removed call, inlined validation or tail transfer. A valid result is that no important boundary changes under that compiler.

Do not change source math or enable fast-math simultaneously. If timing is added, use Week 5's repeatable protocol, identical data and consumed results, record uncertainty and distinguish within-translation-unit visibility from general whole-program behavior. Assembly changes alone cannot establish speedup. This is a design/protocol exercise, not a request for another handwritten assembly probe.

### S02

QueryHit has two eightbytes in LP64: integer ID and double distance. The ABI classifies them as INTEGER and SSE. With both pools available, by-value a takes RDI/XMM0 and b takes RSI/XMM1; that differs from query_hit_compare, whose arguments are two pointers in RDI/RSI to existing objects. The planner cannot represent a single parameter requiring two different classes.

If an aggregate's complete register assignment cannot be made, ABI rules can roll back tentative assignments and pass the whole argument in memory. A guessed one-GP-per-struct rule misses both the mixed register transfer and exhaustion behavior. Layout, alignment and other aggregate forms require the full classifier. Keep this worked case outside abi_plan rather than silently accepting unsupported types.

# Project 2 exemplar report

This is a worked implementation report with actual compiler observations from 2026-10-01, not a fictional learner submission or workload pilot. A learner report should preserve its own predictions, artifacts and measured conditions.

## 1. Contract and initial conditions

The simulator implements the explicit subset in CHECKPOINT-2.md and project.h. Its prepared map is host metadata; guest state consists of CPU fields, data bytes and stack-window settings. The CLI starts IP, flags, general data and all registers except SP at zero, SP at 0100 and the stack window at [0080,0100). Code is immutable and separate from the flat 65536-byte data space. Halting at code length, full predecode and checked instruction targets are course policies.

The reference keeps the complete Machine local for both step and run commit. Traces validate execution and capacity before replay/output. The caller must keep the borrowed bytes and prepared map alive and unchanged. No instruction-count speedup or complete 8086 claim follows from this design.

## 2. Predicted combined program

The original main fixture begins with MOV BX,0100, MOV CX,3 and MOV AL,0. At IP 0008, CALL's following IP is 000B and its displacement +5 selects 0010. CALL stores return word 000B at 00FE/00FF. PUSH AX at 0010 saves word 0000 at 00FC/00FD. ADD byte [BX],1 changes data[0100], POP restores AX, RET resumes at 000B, DEC decreases CX, and JNE selects either 0008 or 000E.

| Stage | SP | Data bytes relevant to the stage |
| --- | --- | --- |
| Before CALL | 0100 | All stack bytes initially zero |
| After CALL | 00FE | 00FE = 0B, 00FF = 00 |
| After PUSH AX | 00FC | 00FC = 00, 00FD = 00 |
| After POP AX | 00FE | Saved bytes remain |
| After RET | 0100 | Return bytes remain |

There are three setup instructions, three iterations of seven instructions each, then one final JMP: 3 + 3×7 + 1 = 25 steps. Final AX = 0000, CX = 0000, BX = 0100, SP = 0100, IP = 0016, flags = 0044 and data[0100] = 03. The final flags come from DEC reaching zero; JMP preserves them. An unchanged store of zero or a repeated return word may produce no delta even though the instruction executes.

fixtures/program.txt is the complete hand-derived trace. wrap.txt independently predicts low byte 34 at FFFF and high byte 12 at 0000, while push-sp.txt predicts original 8086 PUSH SP storing 00FE. The trace lists changed bytes by numerical address, so wrapping word deltas list 0000 before FFFF without reversing little-endian meaning.

## 3. Error and independence evidence

A memory store followed by a jump into an immediate reports M_TARGET at offset 5 after one tentative step and leaves all caller state unchanged. A valid two-record program with capacity one reports M_CAPACITY at the end and steps = 2, preserving trace sentinels and count. An execution error takes precedence over capacity, because invalid programs are rejected before output sizing.

The recursive NOP/CALL example uses 64 return words in its 128-byte window. It executes 65 NOPs and 64 successful CALLs, then reports M_STACK at CALL offset 1 after 129 steps. An initial test with budget 100 reached the budget first; correcting the budget to 300 made the intended stack-boundary assertion meaningful. This is a corrected test prediction, not a change to the executor's stack semantics.

The independent arithmetic oracle checks 196608 byte ADD/SUB/CMP cases using mathematical ranges, nibble arithmetic and parity. The Python state oracle computes all fields and deltas for 128 combined programs. Pinned predecessor comparisons detect regressions but share helpers, so they are weaker independence evidence. Neither comparison claims to run against physical 8086 hardware. Actual gate results are recorded separately in validation.md.

## 4. Actual modern x64 observations

Artifacts were produced under x86-64 WSL2 with GCC 11.4.0 and Clang 14.0.0. Inspection uses C11, -O0 or -O2, -g, -gdwarf-4, -ffp-contract=off and -fno-lto; manifests record exact command flags, targets and SHA-256 source hashes. Generate your own with make inspect. These excerpts are from GCC's relocated object dumps, with byte/address columns omitted for readability; differing correct Clang output is accepted.

### Defined unsigned local

The supplied C function computes doubled = value×2, then returns doubled+1 with uint64_t modulo arithmetic. GCC debug stored its argument at [RBP-18h], doubled at [RBP-8], and returned through RAX:

```asm
push rbp
mov rbp,rsp
mov QWORD PTR [rbp-0x18],rdi
mov rax,QWORD PTR [rbp-0x18]
add rax,rax
mov QWORD PTR [rbp-0x8],rax
mov rax,QWORD PTR [rbp-0x8]
add rax,0x1
pop rbp
ret
```

GCC optimized used:

```asm
lea rax,[rdi+rdi*1+0x1]
ret
```

Both actual dumps also began with endbr64 on this toolchain; it is outside the arithmetic excerpt. The optimized doubled value has no dedicated stack slot. LEA performs address-style arithmetic here without a data-memory load. The result remains in RAX, with the incoming scalar integer in RDI. Debug storage locations are observations, not a C requirement that every local has an architectural stack slot.

### A real geolab boundary

checkpoint_distance(lat,lon,out) calls geo_distance_km(0.0,0.0,lat,lon,out). For the [identified System V scalar convention](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf), incoming lat/lon use XMM0/XMM1 and the output pointer uses RDI. The target needs four doubles in XMM0–3 and the pointer still in RDI; it returns status in EAX and writes distance through the pointer.

GCC debug rearranged those values, emitted CALL with R_X86_64_PLT32 geo_distance_km-0x4, then LEAVE/RET. GCC optimized instead emitted this tail transfer:

```asm
movapd xmm3,xmm1
pxor xmm1,xmm1
movapd xmm2,xmm0
movapd xmm0,xmm1
jmp <relocated geo_distance_km target>
```

The actual object JMP displacement was zero before relocation and carried R_X86_64_PLT32 geo_distance_km-0x4. Its apparent local destination is unresolved object data, not a claim that the executed transfer lands in the next instruction. In the tail form, the target returns directly to the wrapper's caller using the existing continuation. A valid implementation must still obey the convention's argument, stack and preservation obligations. No new return word is needed for this observed tail transfer.

The inspection also includes the real query_hit_compare object. Its two input pointers use RDI/RSI and its ordering int uses EAX. The defined comparator orders distance before full-width ID rather than subtracting and narrowing identifiers. Annotate your compiler's comparisons and branches against that source meaning instead of requiring one exact listing.

## 5. Claims and limits

Observation: tested state outputs match the explicit golden/oracle domains and actual x64 objects differ under optimization. Inference: the validated code implements the chosen subset on these toolchains, while the observed x64 transformations satisfy defined source effects and ABI obligations. Limits: finite tests, shared predecessor helpers, no full historical hardware, omitted segments/devices and no measured timing or predictor behavior.

The C standard governs host arithmetic/lifetimes; ISA semantics govern guest instructions; the course chooses boundaries and rollback; the ABI governs function boundaries; the compiler chooses a valid implementation; microarchitecture affects performance. A two-instruction optimized arithmetic excerpt does not measure cycles, and fewer guest steps are not evidence of successful prediction.

## 6. Handoff and workload record

Submit the actual manifests, fixture/log names, source revision/hashes and exact commands alongside this reasoning. Record your own minutes spent viewing, implementing, debugging, reading and reporting. No learner pilot values are supplied. Week 13 adds explicit timing: correctness comes first, then clock selection, repetition and variation support a measured performance claim.

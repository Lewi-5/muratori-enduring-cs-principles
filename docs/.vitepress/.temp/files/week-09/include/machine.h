#ifndef WEEK09_MACHINE_H
#define WEEK09_MACHINE_H
#include "sim.h"
enum { REG_AX, REG_CX, REG_DX, REG_BX, REG_SP, REG_BP, REG_SI, REG_DI };
typedef struct { CpuState cpu; uint8_t memory[65536]; } Machine;
typedef enum { M_OK, M_ARGUMENT, M_DECODE, M_TARGET, M_LIMIT } MachineStatus;
typedef enum { X_BASE, X_JMP, X_JCC } Extension;
typedef struct {
    Extension kind;
    unsigned length, condition;
    int32_t relative;
    Instruction base;
} Decoded;
typedef struct { MachineStatus status; size_t offset, steps; } MachineResult;
/* Caller owns all storage. Inputs/outputs must be accessible, disjoint and
   unchanged by concurrent writers. Code is immutable and separate from data.
   No allocation, I/O, globals, host pointer punning or retained pointers.
   Code starts at IP zero; n<=65535. IP==n is the course halt boundary.
   Flat 64KiB data omits CS/DS/SS segmentation and self-modifying code.
   All failures preserve outputs/state except returned status/result records. */
/* E01: compute numeric effective offset modulo 65536. direct must be 0/1;
   rm must be 0..7 and displacement -32768..32767 for non-direct expressions.
   Direct address ignores rm/displacement. Returns 1 or 0; output unchanged
   on bad arguments. Word address registers are used even for byte data. */
int machine_address(const Address *address, const CpuState *cpu, uint16_t *out);
/* E02: condition 0..15 corresponds to opcode 70..7F. Returns 1/0 for
   taken/not taken, -1 for an invalid code. Tests CF/PF/ZF/SF/OF only. */
int machine_condition(unsigned condition, uint16_t flags);
/* E02: reuse MOV/ADD/SUB/CMP revision-7 decoder, extend with 70..7F rel8
   conditional jumps, EB rel8 and E9 rel16 unconditional JMP. No LOOP/JCXZ,
   prefixes, stack, CALL/RET or indirect/far transfers. Relative patterns
   become mathematical signed int32_t values. Empty input returns M_DECODE;
   NULL bytes at n=0 allowed. NULL output returns M_ARGUMENT. */
MachineStatus machine_decode(const uint8_t *bytes, size_t n, Decoded *out);
/* E03: predecode whole code, validate current IP boundary, then execute one
   instruction atomically. A taken target is (following IP+relative) mod 65536
   and must be a decoded boundary or n. An untaken target is not checked.
   MOV and jumps preserve flags; arithmetic replaces six modeled flags;
   CMP writes none of its operands. All reads and destination addresses use
   pre-state. Word data is little endian and wraps FFFF -> 0000.
   At the halt boundary, step returns M_TARGET. */
MachineStatus machine_step(const uint8_t *code, size_t n, Machine *machine);
/* E04: positive budget, full predecode (including unreachable bytes), initial
   boundary check, then atomic whole-program run. On failure offset/steps
   describe attempted execution but no registers, flags, IP or bytes commit.
   Decode failure offset is its first opcode; steps=0. Target/limit failures
   report current IP and number of successful tentative steps. Argument
   failures offset=steps=0. Empty input at IP zero succeeds; halt on the last
   allowed step succeeds. Oversized code, zero budget or bad pointers fail. */
MachineResult machine_run(const uint8_t *code, size_t n, size_t max_steps, Machine *machine);
/* W01 rel8 signed interpretation; W02 next-IP+signed displacement modulo
   65536 (next<=65535, displacement -32768..32767); W03 little-endian word.
   Return 1/0; NULL or invalid arguments preserve output. */
int w01(unsigned pattern, int32_t *out);
int w02(unsigned next, int32_t displacement, uint16_t *out);
int w03(const uint8_t *bytes, uint16_t *out);
static inline const char *machine_status_name(MachineStatus s)
{
    switch (s) {
    case M_OK: return "M_OK"; case M_ARGUMENT: return "M_ARGUMENT";
    case M_DECODE: return "M_DECODE"; case M_TARGET: return "M_TARGET";
    case M_LIMIT: return "M_LIMIT";
    }
    return "M_UNKNOWN";
}
#endif

#ifndef WEEK10_MACHINE_H
#define WEEK10_MACHINE_H
#include "sim.h"
enum { REG_AX, REG_CX, REG_DX, REG_BX, REG_SP, REG_BP, REG_SI, REG_DI };
typedef struct {
    CpuState cpu;
    uint8_t memory[65536]; /* guest data; no host pointers stored here */
    uint16_t stack_low, stack_high; /* [low,high), initial empty SP=high */
} Machine;
typedef enum {
    M_OK, M_ARGUMENT, M_DECODE, M_STACK, M_TARGET, M_LIMIT
} MachineStatus;
typedef enum {
    X_BASE, X_PUSH, X_POP, X_CALL, X_RET, X_JMP, X_JCC, X_INC, X_DEC, X_NOP
} Extension;
typedef struct {
    Extension kind;
    unsigned length, reg, condition;
    int32_t relative;
    Instruction base;
} Decoded;
typedef struct { MachineStatus status; size_t offset, steps; } MachineResult;
/* All storage is caller-owned, disjoint and accessible. Code is immutable
   during calls and distinct from guest data. No allocation, I/O or globals.
   The guest has one flat 64KiB data space, not real segmented SS/DS/CS.
   Code starts at IP=0; length 0..65535. IP==length is the course halt rule.
   Branch/return targets must be instruction boundaries or the halt boundary.
   Stack windows are nonempty, high<=65535; SP may be odd. No stack wrap.
   A failure preserves all outputs/state except the returned result record. */
/* E01: PUSH decrements SP by two then writes a little-endian word;
   POP reads the current word then increments SP. Under/overflow are course
   window checks, not hardware exceptions. Helpers preserve IP and flags.
   POP leaves old memory bytes intact; outputs must not alias Machine. */
MachineStatus machine_push(Machine *machine, uint16_t value);
MachineStatus machine_pop(Machine *machine, uint16_t *value);
/* E02: Decode BASE MOV/ADD/SUB/CMP via pinned revision-7 decoder; extend with
   50..57 PUSH r16, 58..5F POP r16, E8 CALL rel16, C3 RET, EB/E9 JMP,
   70..7F Jcc rel8, 40..47 INC r16, 48..4F DEC r16, 90 NOP.
   Relative patterns are signed mathematically, never host int16_t casts.
   NULL bytes at n=0 is allowed but returns M_DECODE. Failure preserves out.
   No immediate PUSH (80186), far transfers, RET imm16, FF groups or prefixes. */
MachineStatus machine_decode(const uint8_t *bytes, size_t n, Decoded *out);
/* E03: Execute one fetched instruction atomically. CALL pushes next IP,
   then transfers. RET pops and validates target before committing. Original
   8086 PUSH SP stores decremented SP; POP SP's final SP is the popped word
   (required to remain within the window). Other register PUSH captures pre-SP.
   Stack and transfers preserve flags. INC/DEC preserve CF, update other
   arithmetic flags. Memory BASE words wrap from FFFF to 0000; stack words do
   not wrap. Every decoded boundary in code is validated before execution. */
MachineStatus machine_step(const uint8_t *code, size_t n, Machine *machine);
/* E04: Whole-program transaction, including all guest memory. Decode the
   entire immutable code first (even unreachable bytes). Execute until IP==n.
   max_steps>0. On a late failure no tentative state escapes; offset and steps
   describe the attempted run. Initial IP must also be a boundary. End reached
   on the last permitted step succeeds. Empty code at IP=0 succeeds. */
MachineResult machine_run(const uint8_t *code, size_t n, size_t max_steps, Machine *machine);
/* W01..W03: small independent warm-ups, 0 on bad arguments, outputs unchanged.
   w01 accepts 0..65535 patterns, returns signed interpretation in int32_t.
   w02 accepts high<=65535 and sp<=high, returns word depth floor((high-sp)/2).
   w03 reads two little-endian bytes numerically. */
int w01(unsigned pattern, int32_t *signed_value);
int w02(unsigned high, unsigned sp, unsigned *depth);
int w03(const uint8_t *bytes, uint16_t *value);
static inline const char *machine_status_name(MachineStatus s)
{
    switch (s) {
    case M_OK: return "M_OK"; case M_ARGUMENT: return "M_ARGUMENT";
    case M_DECODE: return "M_DECODE"; case M_STACK: return "M_STACK";
    case M_TARGET: return "M_TARGET"; case M_LIMIT: return "M_LIMIT";
    }
    return "M_UNKNOWN";
}
#endif

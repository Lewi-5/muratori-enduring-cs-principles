#ifndef WEEK08_SIM_H
#define WEEK08_SIM_H
#include "decode.h"
enum { FLAG_CF=0x0001, FLAG_PF=0x0004, FLAG_AF=0x0010,
       FLAG_ZF=0x0040, FLAG_SF=0x0080, FLAG_OF=0x0800, FLAG_ARITH=0x08d5 };
/* Word order: ax,cx,dx,bx,sp,bp,si,di. Byte codes 0..3 address the
   low halves of the first four words, 4..7 their high halves. No host union
   or pointer punning: aliasing is part of the guest ISA model. */
typedef struct { uint16_t regs[8]; uint16_t flags, ip; } CpuState;
typedef struct { uint16_t value, flags; } AluResult;
typedef enum { SIM_OK, SIM_INVALID_ARGUMENT, SIM_INVALID_INSTRUCTION,
               SIM_UNSUPPORTED_OPERAND, SIM_DECODE_ERROR, SIM_INPUT_TOO_LARGE } SimStatus;
typedef struct {
    SimStatus status;
    DecodeStatus decode_status; /* meaningful only for SIM_DECODE_ERROR */
    size_t offset; /* file offset of first failing instruction; n on success */
    size_t steps;  /* successful tentative steps, even if state is rolled back */
} RunResult;

/* No allocation, retained pointers, I/O or shared mutable state. Caller owns
   all objects. Inputs/outputs must be accessible and disjoint, including
   state versus instruction/bytes. Keep input immutable throughout a call.
   Independent caller storage permits concurrent calls. */
/* E01: wide 0/1 and code 0..7. Read/write return 1 or 0. NULL/invalid
   arguments or a byte value above 255 fail without changing any output. */
int sim_read_register(const CpuState *state, unsigned wide, unsigned code, uint16_t *out);
int sim_write_register(CpuState *state, unsigned wide, unsigned code, uint16_t value);
/* E02: only ADD/SUB/CMP, wide 0/1, operands within that width. Return 1
   with the masked result and precisely six arithmetic flags, or 0 with out
   unchanged. CF for subtraction is borrow. PF examines the LOW BYTE only.
   Results wrap at the guest width; no host signed overflow is required. */
int sim_alu(Operation op, unsigned wide, uint16_t left, uint16_t right, AluResult *out);
/* E03: validate operation, operands, equal widths and byte length 2..6.
   Valid memory operands return UNSUPPORTED_OPERAND. Other invalid objects
   return INVALID_INSTRUCTION. NULL gives INVALID_ARGUMENT. Every failure
   preserves state. MOV preserves all flags; arithmetic replaces only the
   six modeled flags and preserves other bits. CMP never writes a register.
   Each successful step advances 16-bit guest IP modulo 65536. Source values
   are captured before writes, including overlapping byte/word registers. */
SimStatus sim_step(const Instruction *instruction, CpuState *state);
/* E04: sequential program, maximum 65536 bytes. A file cursor (size_t) locates
   the next encoded instruction independently of wrapping guest IP. A local
   state is executed and committed ONLY when the whole stream succeeds.
   On failure state is unchanged; returned offset and steps describe the
   tentative run. Empty input succeeds unchanged; NULL bytes only at n=0.
   Argument/size failures return offset=steps=0. Decode status is DEC_OK on
   every non-decode failure. No jumps, memory effects, stack or cycle model. */
RunResult sim_run(const uint8_t *bytes, size_t n, CpuState *state);
static inline const char *sim_status_name(SimStatus s)
{
    switch (s) {
    case SIM_OK: return "SIM_OK";
    case SIM_INVALID_ARGUMENT: return "SIM_INVALID_ARGUMENT";
    case SIM_INVALID_INSTRUCTION: return "SIM_INVALID_INSTRUCTION";
    case SIM_UNSUPPORTED_OPERAND: return "SIM_UNSUPPORTED_OPERAND";
    case SIM_DECODE_ERROR: return "SIM_DECODE_ERROR";
    case SIM_INPUT_TOO_LARGE: return "SIM_INPUT_TOO_LARGE";
    }
    return "SIM_UNKNOWN";
}
#endif

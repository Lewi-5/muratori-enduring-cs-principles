#ifndef WEEK06_DECODE_TYPES_H
#define WEEK06_DECODE_TYPES_H
/* Supplied types for the week-6 8086 subset decoder. No exercise answer lives here. */
#include <stddef.h>
#include <stdint.h>

/* The byte-decoding statuses come first, in the order the decoder checks them (see the plan's status order).
   DEC_OUTPUT_TOO_SMALL and DEC_INVALID_ARGUMENT are API failures of the stream and format functions, not
   classifications of bytes. */
typedef enum {
    DEC_OK = 0,
    DEC_TRUNCATED,             /* the instruction's bytes run past the end of the input */
    DEC_UNSUPPORTED_OPCODE,    /* the first byte is not an opcode in the course subset */
    DEC_UNSUPPORTED_MODE,      /* a recognized form with ModR/M mod != 11 (memory operands are week 7) */
    DEC_UNSUPPORTED_OPERATION, /* 0x80/0x81/0x83 with a reg field other than add (000), sub (101), cmp (111) */
    DEC_OUTPUT_TOO_SMALL,
    DEC_INVALID_ARGUMENT
} DecodeStatus;

typedef enum { OP_MOV, OP_ADD, OP_SUB, OP_CMP } Operation;
typedef enum { OPERAND_REG, OPERAND_IMM } OperandKind;

/* A register operand uses wide (0 = 8-bit, 1 = 16-bit) and reg (0..7). An immediate operand uses wide (the width of
   the operation) and imm, the SIGNED value of the operand-width bit pattern: 8-bit patterns give -128..127 and
   16-bit patterns -32768..32767. An 8-bit immediate sign-extended by s = 1 is stored as its 16-bit value. */
typedef struct {
    OperandKind kind;
    unsigned wide;
    unsigned reg;
    int32_t imm;
} Operand;

typedef struct {
    Operation op;
    Operand dst;
    Operand src;
    unsigned length; /* bytes consumed, 2..4 in the subset */
} Instruction;

#define DEC_MAX_INPUT 65536u /* one 8086 segment; decode8086 rejects larger files */
#define DEC_MAX_TEXT 32u     /* bytes for one instruction's canonical text, including the terminator */

static inline const char *decode_status_name(DecodeStatus s)
{
    switch (s) {
    case DEC_OK: return "DEC_OK";
    case DEC_TRUNCATED: return "DEC_TRUNCATED";
    case DEC_UNSUPPORTED_OPCODE: return "DEC_UNSUPPORTED_OPCODE";
    case DEC_UNSUPPORTED_MODE: return "DEC_UNSUPPORTED_MODE";
    case DEC_UNSUPPORTED_OPERATION: return "DEC_UNSUPPORTED_OPERATION";
    case DEC_OUTPUT_TOO_SMALL: return "DEC_OUTPUT_TOO_SMALL";
    case DEC_INVALID_ARGUMENT: return "DEC_INVALID_ARGUMENT";
    }
    return "DEC_UNKNOWN";
}
#endif

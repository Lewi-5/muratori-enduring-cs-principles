#ifndef WEEK07_DECODE_H
#define WEEK07_DECODE_H
#include <stddef.h>
#include <stdint.h>

/* Public C API, revision 7. Build client and library with this same header and
   target ABI. Revision 7 changes Operand's layout from week 6; it is not a
   promise of binary compatibility with that week or arbitrary future headers. */
typedef enum {
    DEC_OK, DEC_TRUNCATED, DEC_UNSUPPORTED_OPCODE, DEC_UNSUPPORTED_MODE,
    DEC_UNSUPPORTED_OPERATION, DEC_OUTPUT_TOO_SMALL, DEC_INVALID_ARGUMENT
} DecodeStatus;
typedef enum { OP_MOV, OP_ADD, OP_SUB, OP_CMP } Operation;
typedef enum { OPERAND_REG, OPERAND_IMM, OPERAND_MEM } OperandKind;
typedef struct {
    unsigned direct;   /* 1: address; 0: rm expression plus displacement */
    unsigned rm;       /* 0..7, word ADDRESS registers even for byte operations */
    int32_t displacement; /* -32768..32767; sign interpreted from encoded width */
    uint16_t address;  /* direct addresses are UNSIGNED 0..65535 */
} Address;
typedef struct {
    OperandKind kind;
    unsigned wide;     /* data width: 0 byte, 1 word */
    unsigned reg;
    int32_t imm;       /* signed operand-width pattern, as in week 6 */
    Address memory;
} Operand;
typedef struct { Operation op; Operand dst, src; unsigned length; } Instruction;
#define DEC_MAX_INPUT 65536u
#define DEC_MAX_TEXT 64u
#define DEC_API_VERSION 7u

/* These functions allocate nothing, perform no I/O, exit nowhere and retain no
   pointers. Inputs must stay unchanged during each call. Independent requests
   may run concurrently; the caller owns all storage. Input and output regions,
   including scalar outputs, must not overlap each other. Extents must describe
   actual accessible objects. NULL bytes is allowed only at zero length.
   Thread safety does not permit a concurrent writer to an input/output object. */
unsigned decoder_api_version(void);

/* Decode only the first instruction. Success commits *out and its byte length
   (2..6). Every failure preserves *out. NULL out is INVALID_ARGUMENT; zero
   available bytes is TRUNCATED. Extra bytes belong to subsequent instructions.
   Error precedence: arguments, empty input, opcode, missing ModR/M, unsupported
   group operation, displacement bytes, immediate bytes. See README for subset. */
DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out);

/* Validate fields and produce canonical text plus NUL. Returns 1 on success;
   returns 0 on malformed operands, NULL pointers, or insufficient capacity,
   preserving out. length is metadata, not used to reconstruct an encoding.
   No memory-to-memory operands; immediate only on the source side. */
int format_instruction(const Instruction *ins, char *out, size_t size);

/* Complete stream -> "bits 16\n", one canonical line per instruction, and NUL.
   Empty stream succeeds. No library-level input cap (CLI cap is DEC_MAX_INPUT).
   Success: *text_len excludes NUL, *error_offset=n. Byte failure: only
   *error_offset changes, to the failing instruction's first byte. Argument or
   capacity failure preserves ALL outputs. Two passes validate before writing;
   immutable, nonoverlapping inputs are therefore part of the contract. */
DecodeStatus decode_stream(const uint8_t *bytes, size_t n, char *text,
                           size_t capacity, size_t *text_len, size_t *error_offset);
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

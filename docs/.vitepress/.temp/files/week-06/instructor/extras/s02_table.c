/* S02: a decoding table. Link with the reference decode.o and compare exhaustively:
     gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -Iinstructor/src -Isupport instructor/extras/s02_table.c \
         build/instructor/gcc/debug/decode.o -o build/s02_table && ./build/s02_table
   decode_table() replaces decode_one's branches with a 256-entry table indexed by the first byte: the form, the
   operation (or "taken from the ModR/M reg field"), and where the width comes from. The comparison covers the whole
   input domain of the subset, not only two-byte prefixes:
     - every first byte alone, and every (first, second) pair with 0, 1 and 2 trailing bytes 0x34 0x12;
     - for every accepted 3-byte form, all 256 values of the third byte;
     - for every accepted 4-byte form and every 3-byte form with a 16-bit immediate, all 65,536 immediates.
   Two decoders that agree there agree on every input of every length, because nothing after an instruction's last
   byte is read. No speed claim is made. */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"

typedef enum { F_NONE, F_MOV_RM, F_ARITH_RM, F_MOV_IMM, F_ARITH_ACC, F_ARITH_IMM } Form;
typedef struct { Form form; Operation op; unsigned wide, reg, imm_bytes, sign_extend; } Entry;

static Entry table[256];

static void build_table(void)
{
    memset(table, 0, sizeof table); /* F_NONE everywhere */
    for (unsigned b = 0x88; b <= 0x8B; ++b) table[b] = (Entry){F_MOV_RM, OP_MOV, b & 1u, 0, 0, 0};
    for (unsigned b = 0xB0; b <= 0xBF; ++b) table[b] = (Entry){F_MOV_IMM, OP_MOV, (b >> 3) & 1u, b & 7u, (b >> 3) & 1u ? 2u : 1u, 0};
    static const struct { unsigned code; Operation op; } ops[] = {{0, OP_ADD}, {5, OP_SUB}, {7, OP_CMP}};
    for (size_t i = 0; i < 3; ++i) {
        unsigned base = ops[i].code << 3;
        for (unsigned low = 0; low < 4; ++low) table[base | low] = (Entry){F_ARITH_RM, ops[i].op, low & 1u, 0, 0, 0};
        table[base | 4u] = (Entry){F_ARITH_ACC, ops[i].op, 0, 0, 1, 0};
        table[base | 5u] = (Entry){F_ARITH_ACC, ops[i].op, 1, 0, 2, 0};
    }
    table[0x80] = (Entry){F_ARITH_IMM, OP_ADD, 0, 0, 1, 0};
    table[0x81] = (Entry){F_ARITH_IMM, OP_ADD, 1, 0, 2, 0};
    table[0x83] = (Entry){F_ARITH_IMM, OP_ADD, 1, 0, 1, 1};
}

static int32_t imm_value(const uint8_t *p, unsigned bytes, unsigned wide, unsigned sign_extend)
{
    unsigned v = bytes == 2 ? (unsigned)p[0] | ((unsigned)p[1] << 8) : p[0];
    if (bytes == 1 && (wide == 0 || sign_extend)) return v >= 0x80u ? (int32_t)v - 0x100 : (int32_t)v;
    return v >= 0x8000u ? (int32_t)v - 0x10000 : (int32_t)v;
}

static DecodeStatus decode_table(const uint8_t *b, size_t avail, Instruction *out)
{
    if (out == NULL || (b == NULL && avail > 0)) return DEC_INVALID_ARGUMENT;
    if (avail == 0) return DEC_TRUNCATED;
    Entry e = table[b[0]];
    Instruction ins;
    memset(&ins, 0, sizeof ins);
    ins.op = e.op;
    if (e.form == F_NONE) return DEC_UNSUPPORTED_OPCODE;
    if (e.form == F_MOV_IMM || e.form == F_ARITH_ACC) {
        if (avail < 1u + e.imm_bytes) return DEC_TRUNCATED;
        ins.dst = (Operand){OPERAND_REG, e.wide, e.reg, 0};
        ins.src = (Operand){OPERAND_IMM, e.wide, 0, imm_value(b + 1, e.imm_bytes, e.wide, 0)};
        ins.length = 1u + e.imm_bytes;
        *out = ins;
        return DEC_OK;
    }
    if (avail < 2) return DEC_TRUNCATED;
    unsigned mod = (unsigned)b[1] >> 6, reg = ((unsigned)b[1] >> 3) & 7u, rm = (unsigned)b[1] & 7u;
    if (mod != 3) return DEC_UNSUPPORTED_MODE;
    if (e.form == F_ARITH_IMM) {
        if (reg == 0) ins.op = OP_ADD;
        else if (reg == 5) ins.op = OP_SUB;
        else if (reg == 7) ins.op = OP_CMP;
        else return DEC_UNSUPPORTED_OPERATION;
        if (avail < 2u + e.imm_bytes) return DEC_TRUNCATED;
        ins.dst = (Operand){OPERAND_REG, e.wide, rm, 0};
        ins.src = (Operand){OPERAND_IMM, e.wide, 0, imm_value(b + 2, e.imm_bytes, e.wide, e.sign_extend)};
        ins.length = 2u + e.imm_bytes;
        *out = ins;
        return DEC_OK;
    }
    unsigned d = ((unsigned)b[0] >> 1) & 1u;
    ins.dst = (Operand){OPERAND_REG, e.wide, d ? reg : rm, 0};
    ins.src = (Operand){OPERAND_REG, e.wide, d ? rm : reg, 0};
    ins.length = 2;
    *out = ins;
    return DEC_OK;
}

static unsigned long long compared = 0;

static int same(const uint8_t *b, size_t n)
{
    Instruction x, y;
    memset(&x, 0x5A, sizeof x);
    memset(&y, 0x5A, sizeof y);
    DecodeStatus sx = decode_one(b, n, &x), sy = decode_table(b, n, &y);
    ++compared;
    if (sx != sy || (sx == DEC_OK && memcmp(&x, &y, sizeof x) != 0)) {
        fprintf(stderr, "differ on");
        for (size_t i = 0; i < n; ++i) fprintf(stderr, " %02x", b[i]);
        fprintf(stderr, ": %s versus %s\n", decode_status_name(sx), decode_status_name(sy));
        return 0;
    }
    return 1;
}

int main(void)
{
    build_table();
    uint8_t b[4];
    for (unsigned b0 = 0; b0 < 256; ++b0) {
        b[0] = (uint8_t)b0;
        if (!same(b, 1)) return 1;
        for (unsigned b1 = 0; b1 < 256; ++b1) {
            b[1] = (uint8_t)b1;
            b[2] = 0x34;
            b[3] = 0x12;
            for (size_t k = 0; k <= 2; ++k)
                if (!same(b, 2 + k)) return 1;
            Instruction ins;
            if (decode_one(b, 4, &ins) != DEC_OK || ins.length < 3) continue;
            if (ins.length == 3 && ins.src.kind == OPERAND_IMM && (b0 == 0x80 || b0 == 0x83)) {
                for (unsigned v = 0; v < 256; ++v) {
                    b[2] = (uint8_t)v;
                    if (!same(b, 3)) return 1;
                }
            } else if (ins.length == 3) { /* a 16-bit immediate after the first byte: b[1..2] */
                if (b1 != 0) continue;    /* the loop over all 65,536 immediates covers every b1 once */
                for (unsigned v = 0; v < 65536; ++v) {
                    b[1] = (uint8_t)(v & 0xFFu);
                    b[2] = (uint8_t)(v >> 8);
                    if (!same(b, 3)) return 1;
                }
            } else {                      /* length 4: 0x81 with a 16-bit immediate in b[2..3] */
                for (unsigned v = 0; v < 65536; ++v) {
                    b[2] = (uint8_t)(v & 0xFFu);
                    b[3] = (uint8_t)(v >> 8);
                    if (!same(b, 4)) return 1;
                }
            }
        }
    }
    printf("table_decoder_agrees=1 compared=%llu\n", compared);
    return 0;
}

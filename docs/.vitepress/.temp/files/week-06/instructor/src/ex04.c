/* E04: decoding one instruction. Reference solution. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "decode_types.h"

/* ---- helpers copied from E01-E03 (non-static, so an unused copy never trips -Werror) ---- */
typedef struct { unsigned mod, reg, rm; } ModRM;

ModRM split_modrm(uint8_t byte)
{
    ModRM m = {(unsigned)(byte >> 6) & 3u, (unsigned)(byte >> 3) & 7u, (unsigned)byte & 7u};
    return m;
}

int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)
{
    if (bytes == NULL || out == NULL || (size != 1 && size != 2)) return 0;
    if (offset > avail || size > avail - offset) return 0;
    if (size == 1) *out = bytes[offset];
    else *out = (uint16_t)((unsigned)bytes[offset] | ((unsigned)bytes[offset + 1] << 8));
    return 1;
}

int32_t to_signed(uint16_t value, unsigned wide)
{
    if (wide == 0) {
        uint16_t v = (uint16_t)(value & 0xFFu);
        return v >= 0x80u ? (int32_t)v - 0x100 : (int32_t)v;
    }
    return value >= 0x8000u ? (int32_t)value - 0x10000 : (int32_t)value;
}

uint16_t sign_extend8(uint8_t value) { return (uint16_t)(value & 0x80u ? 0xFF00u | value : value); }

/* ---- E04 ---- */

/* The 3-bit operation code shared by the arithmetic forms: bits 5..3 of the first byte in the register and
   accumulator forms, the reg field of the ModR/M byte in 0x80-0x83. */
static int arith_op(unsigned code, Operation *op)
{
    if (code == 0) *op = OP_ADD;
    else if (code == 5) *op = OP_SUB;
    else if (code == 7) *op = OP_CMP;
    else return 0;
    return 1;
}

static Operand reg_operand(unsigned wide, unsigned r)
{
    Operand o = {OPERAND_REG, wide, r, 0};
    return o;
}

static Operand imm_operand(unsigned wide, int32_t value)
{
    Operand o = {OPERAND_IMM, wide, 0, value};
    return o;
}

/* Decode the first instruction of bytes[0..avail). Status order (the plan's): no byte -> DEC_TRUNCATED; opcode not
   in the subset -> DEC_UNSUPPORTED_OPCODE; ModR/M needed but missing -> DEC_TRUNCATED; mod != 11 ->
   DEC_UNSUPPORTED_MODE; 0x80-0x83 with reg not add/sub/cmp -> DEC_UNSUPPORTED_OPERATION; immediate bytes missing ->
   DEC_TRUNCATED. Every byte is read only after checking that it exists. *out is written only on DEC_OK. */
DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out)
{
    if (out == NULL || (bytes == NULL && avail > 0)) return DEC_INVALID_ARGUMENT;
    if (avail == 0) return DEC_TRUNCATED;
    const unsigned b0 = bytes[0];
    Instruction ins;
    uint16_t raw = 0;

    if ((b0 & 0xF0u) == 0xB0u) {                         /* mov reg, imm: 1011 w rrr */
        unsigned w = (b0 >> 3) & 1u, r = b0 & 7u;
        if (!read_imm(bytes, avail, 1, w ? 2u : 1u, &raw)) return DEC_TRUNCATED;
        ins.op = OP_MOV;
        ins.dst = reg_operand(w, r);
        ins.src = imm_operand(w, to_signed(raw, w));
        ins.length = w ? 3u : 2u;
        *out = ins;
        return DEC_OK;
    }
    if ((b0 & 0xC4u) == 0x04u) {                         /* op acc, imm: 00 ooo 10w */
        Operation op;
        if (!arith_op((b0 >> 3) & 7u, &op)) return DEC_UNSUPPORTED_OPCODE;
        unsigned w = b0 & 1u;
        if ((b0 & 0x02u) != 0) return DEC_UNSUPPORTED_OPCODE; /* 00ooo11w is not an accumulator form */
        if (!read_imm(bytes, avail, 1, w ? 2u : 1u, &raw)) return DEC_TRUNCATED;
        ins.op = op;
        ins.dst = reg_operand(w, 0);                     /* al or ax */
        ins.src = imm_operand(w, to_signed(raw, w));
        ins.length = w ? 3u : 2u;
        *out = ins;
        return DEC_OK;
    }
    int reg_reg = (b0 & 0xFCu) == 0x88u;                 /* mov r/m, r: 100010dw */
    Operation op = OP_MOV;
    if (!reg_reg && (b0 & 0xC4u) == 0x00u) {             /* op r/m, r: 00 ooo 0dw */
        if (!arith_op((b0 >> 3) & 7u, &op)) return DEC_UNSUPPORTED_OPCODE;
        reg_reg = 1;
    }
    if (reg_reg) {
        if (avail < 2) return DEC_TRUNCATED;
        ModRM m = split_modrm(bytes[1]);
        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;
        unsigned d = (b0 >> 1) & 1u, w = b0 & 1u;
        ins.op = op;
        ins.dst = reg_operand(w, d ? m.reg : m.rm);      /* d = 1: reg is the destination */
        ins.src = reg_operand(w, d ? m.rm : m.reg);
        ins.length = 2;
        *out = ins;
        return DEC_OK;
    }
    if (b0 == 0x80u || b0 == 0x81u || b0 == 0x83u) {     /* op r/m, imm: 100000sw (0x82 is outside the subset) */
        if (avail < 2) return DEC_TRUNCATED;
        ModRM m = split_modrm(bytes[1]);
        if (m.mod != 3) return DEC_UNSUPPORTED_MODE;
        if (!arith_op(m.reg, &op)) return DEC_UNSUPPORTED_OPERATION;
        unsigned s = (b0 >> 1) & 1u, w = b0 & 1u;
        unsigned size = (s == 0 && w == 1) ? 2u : 1u;
        if (!read_imm(bytes, avail, 2, size, &raw)) return DEC_TRUNCATED;
        int32_t value = size == 2 ? to_signed(raw, 1) : (s && w ? to_signed(sign_extend8((uint8_t)raw), 1) : to_signed(raw, 0));
        ins.op = op;
        ins.dst = reg_operand(w, m.rm);
        ins.src = imm_operand(w, value);
        ins.length = 2u + size;
        *out = ins;
        return DEC_OK;
    }
    return DEC_UNSUPPORTED_OPCODE;
}

int main(void)
{
    static const uint8_t samples[][4] = {{0x89, 0xD9}, {0x8B, 0xCB}, {0xB1, 0x0C}, {0xB9, 0xF4, 0xFF}, {0x83, 0xC6, 0xFE},
                                         {0x80, 0xC1, 0xFE}, {0x82, 0xC1, 0x05}, {0x88, 0x07}, {0x81, 0xC6}};
    static const size_t lengths[] = {2, 2, 2, 3, 3, 3, 3, 2, 2};
    static const char *const names[] = {"mov", "add", "sub", "cmp"};
    for (size_t i = 0; i < sizeof lengths / sizeof lengths[0]; ++i) {
        Instruction ins;
        DecodeStatus s = decode_one(samples[i], lengths[i], &ins);
        printf("bytes=");
        for (size_t k = 0; k < lengths[i]; ++k) printf("%02X", samples[i][k]);
        if (s != DEC_OK) {
            printf(" status=%s\n", decode_status_name(s));
            continue;
        }
        printf(" status=DEC_OK op=%s length=%u dst=%s%u:%u src=%s", names[ins.op], ins.length,
               ins.dst.kind == OPERAND_REG ? "reg" : "imm", ins.dst.wide, ins.dst.reg,
               ins.src.kind == OPERAND_REG ? "reg" : "imm");
        if (ins.src.kind == OPERAND_REG) printf("%u:%u\n", ins.src.wide, ins.src.reg);
        else printf("%ld\n", (long)ins.src.imm);
    }
    return 0;
}

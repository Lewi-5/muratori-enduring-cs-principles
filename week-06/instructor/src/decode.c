/* decode.c: the decoder library (E06). Reference solution. The helpers are the E01-E05 code with internal linkage;
   only the three functions declared in decode.h are external. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"

/* ---- E01-E03 helpers ---- */
typedef struct { unsigned mod, reg, rm; } ModRM;

static ModRM split_modrm(uint8_t byte)
{
    ModRM m = {(unsigned)(byte >> 6) & 3u, (unsigned)(byte >> 3) & 7u, (unsigned)byte & 7u};
    return m;
}

static int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)
{
    if (bytes == NULL || out == NULL || (size != 1 && size != 2)) return 0;
    if (offset > avail || size > avail - offset) return 0;
    if (size == 1) *out = bytes[offset];
    else *out = (uint16_t)((unsigned)bytes[offset] | ((unsigned)bytes[offset + 1] << 8));
    return 1;
}

static int32_t to_signed(uint16_t value, unsigned wide)
{
    if (wide == 0) {
        uint16_t v = (uint16_t)(value & 0xFFu);
        return v >= 0x80u ? (int32_t)v - 0x100 : (int32_t)v;
    }
    return value >= 0x8000u ? (int32_t)value - 0x10000 : (int32_t)value;
}

static uint16_t sign_extend8(uint8_t value) { return (uint16_t)(value & 0x80u ? 0xFF00u | value : value); }

static const char *reg_name(unsigned wide, unsigned reg)
{
    static const char *const names[2][8] = {{"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"},
                                            {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"}};
    if (wide > 1 || reg > 7) return NULL;
    return names[wide][reg];
}

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

/* ---- E05 ---- */

static int valid_operand(const Operand *o, int may_be_imm)
{
    if (o->wide > 1) return 0;
    if (o->kind == OPERAND_REG) return o->reg <= 7;
    if (o->kind != OPERAND_IMM || !may_be_imm) return 0;
    return o->wide ? (o->imm >= -32768 && o->imm <= 32767) : (o->imm >= -128 && o->imm <= 127);
}

/* Write "mnemonic dst, src" and a NUL into out. The whole instruction is validated first (operation, operand kinds,
   registers, widths, immediate ranges; the destination is always a register and both operands have the same
   width). The text is formatted into a local buffer and the snprintf result is checked; only a complete text that
   fits in size bytes (with its NUL) is copied to out. On any rejection out is not modified. An integer conversion
   in snprintf ("%ld", "%s") does not depend on the locale's decimal point. */
int format_instruction(const Instruction *ins, char *out, size_t size)
{
    static const char *const mnemonics[] = {"mov", "add", "sub", "cmp"};
    if (ins == NULL || out == NULL) return 0;
    if (ins->op != OP_MOV && ins->op != OP_ADD && ins->op != OP_SUB && ins->op != OP_CMP) return 0;
    if (ins->dst.kind != OPERAND_REG || !valid_operand(&ins->dst, 0) || !valid_operand(&ins->src, 1)) return 0;
    if (ins->src.wide != ins->dst.wide) return 0;
    char text[DEC_MAX_TEXT];
    int n;
    const char *dst = reg_name(ins->dst.wide, ins->dst.reg);
    if (ins->src.kind == OPERAND_REG) {
        n = snprintf(text, sizeof text, "%s %s, %s", mnemonics[ins->op], dst, reg_name(ins->src.wide, ins->src.reg));
    } else {
        n = snprintf(text, sizeof text, "%s %s, %ld", mnemonics[ins->op], dst, (long)ins->src.imm);
    }
    if (n < 0 || (size_t)n >= sizeof text) return 0; /* cannot happen for a valid instruction (at most 14 characters) */
    if ((size_t)n + 1 > size) return 0;
    memcpy(out, text, (size_t)n + 1);
    return 1;
}

/* ---- E06: the stream ---- */

static const char STREAM_HEADER[] = "bits 16\n";

/* Two passes over the same bytes. Pass 1 decodes and formats every instruction into a scratch buffer only to count
   the output (checked size_t arithmetic: each line is at most DEC_MAX_TEXT bytes, and the running total is compared
   with SIZE_MAX before adding), and stops at the first decoding failure. Pass 2 runs only when everything decoded
   and fits, and writes the text. Decoding is a pure function of the bytes, so both passes see the same
   instructions. An instruction stream is decoded from its start: the length of each instruction decides where the
   next begins, so there is no way to resynchronize at an arbitrary offset. */
DecodeStatus decode_stream(const uint8_t *bytes, size_t n, char *text, size_t text_size, size_t *text_len,
                           size_t *error_offset)
{
    if ((bytes == NULL && n > 0) || text == NULL || text_len == NULL || error_offset == NULL) return DEC_INVALID_ARGUMENT;
    size_t need = sizeof STREAM_HEADER - 1; /* visible bytes so far */
    size_t pos = 0;
    while (pos < n) {
        Instruction ins;
        DecodeStatus s = decode_one(bytes + pos, n - pos, &ins);
        if (s != DEC_OK) {
            *error_offset = pos;
            return s;
        }
        char line[DEC_MAX_TEXT];
        if (!format_instruction(&ins, line, sizeof line)) return DEC_INVALID_ARGUMENT; /* unreachable */
        size_t len = strlen(line) + 1; /* plus the newline */
        if (need > SIZE_MAX - len) return DEC_OUTPUT_TOO_SMALL;
        need += len;
        pos += ins.length;
    }
    if (need >= text_size) return DEC_OUTPUT_TOO_SMALL; /* need + 1 bytes are required, for the NUL */
    memcpy(text, STREAM_HEADER, sizeof STREAM_HEADER - 1);
    size_t at = sizeof STREAM_HEADER - 1;
    for (pos = 0; pos < n;) {
        Instruction ins;
        (void)decode_one(bytes + pos, n - pos, &ins); /* succeeded in pass 1 on the same bytes */
        char line[DEC_MAX_TEXT];
        (void)format_instruction(&ins, line, sizeof line);
        size_t len = strlen(line);
        memcpy(text + at, line, len);
        at += len;
        text[at++] = '\n';
        pos += ins.length;
    }
    text[at] = '\0';
    *text_len = at;
    *error_offset = n;
    return DEC_OK;
}

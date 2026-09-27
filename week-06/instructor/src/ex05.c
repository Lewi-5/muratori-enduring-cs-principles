/* E05: canonical text. Reference solution. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode_types.h"

/* ---- helper copied from E02 (non-static) ---- */
const char *reg_name(unsigned wide, unsigned reg)
{
    static const char *const names[2][8] = {{"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"},
                                            {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"}};
    if (wide > 1 || reg > 7) return NULL;
    return names[wide][reg];
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

int main(void)
{
    const Instruction samples[] = {
        {OP_MOV, {OPERAND_REG, 1, 1, 0}, {OPERAND_REG, 1, 3, 0}, 2},
        {OP_ADD, {OPERAND_REG, 1, 6, 0}, {OPERAND_IMM, 1, 0, -2}, 3},
        {OP_CMP, {OPERAND_REG, 0, 0, 0}, {OPERAND_IMM, 0, 0, 12}, 2},
        {OP_CMP, {OPERAND_REG, 1, 0, 0}, {OPERAND_IMM, 1, 0, -32768}, 3},
        {OP_SUB, {OPERAND_REG, 0, 4, 0}, {OPERAND_REG, 0, 7, 0}, 2},
    };
    for (size_t i = 0; i < sizeof samples / sizeof samples[0]; ++i) {
        char text[DEC_MAX_TEXT];
        if (format_instruction(&samples[i], text, sizeof text)) printf("text=\"%s\" length=%zu\n", text, strlen(text));
        else printf("rejected\n");
    }
    return 0;
}

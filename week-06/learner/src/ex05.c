/* E05: canonical text. Implement format_instruction; the driver is supplied. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode_types.h"

/* ---- copy your E02 helper here (non-static) ---- */
const char *reg_name(unsigned wide, unsigned reg)
{
    (void)wide;
    (void)reg;
    return NULL; /* TODO: paste E02 */
}

/* ---- E05 ---- */

/* TODO: write "mnemonic dst, src" and a NUL into out. Validate the whole instruction first (operation, operand kinds,
   registers 0..7, widths 0..1, the destination a register, both operands the same width, an immediate within the
   signed range of its width). Format into a local DEC_MAX_TEXT buffer, check snprintf's result, and copy only a
   complete text that fits in size bytes. On any rejection return 0 and leave out untouched. */
int format_instruction(const Instruction *ins, char *out, size_t size)
{
    (void)ins;
    (void)out;
    (void)size;
    return 0;
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

/* E03: formatting is a second transaction, with its own validity checks. */
#include <stdio.h>
#include <string.h>
#include "decode.h"
static int valid(const Operand *o, int immediate)
{
    if (o->wide > 1) return 0;
    if (o->kind == OPERAND_REG) return o->reg < 8;
    if (o->kind == OPERAND_IMM)
        return immediate && (o->wide ? o->imm >= -32768 && o->imm <= 32767
                                    : o->imm >= -128 && o->imm <= 127);
    if (o->kind != OPERAND_MEM || o->memory.direct > 1) return 0;
    if (o->memory.direct) return o->memory.rm == 0 && o->memory.displacement == 0;
    return o->memory.rm < 8 && o->memory.address == 0 &&
           o->memory.displacement >= -32768 && o->memory.displacement <= 32767;
}
static void operand_text(const Operand *o, char *text, size_t n)
{
    static const char *const regs[2][8] = {
        {"al","cl","dl","bl","ah","ch","dh","bh"},
        {"ax","cx","dx","bx","sp","bp","si","di"}};
    static const char *const bases[] = {"bx + si","bx + di","bp + si","bp + di","si","di","bp","bx"};
    if (o->kind == OPERAND_REG) (void)snprintf(text, n, "%s", regs[o->wide][o->reg]);
    else if (o->kind == OPERAND_IMM) (void)snprintf(text, n, "%ld", (long)o->imm);
    else if (o->memory.direct) (void)snprintf(text, n, "[%u]", (unsigned)o->memory.address);
    else if (o->memory.displacement == 0) (void)snprintf(text, n, "[%s]", bases[o->memory.rm]);
    else {
        long d = (long)o->memory.displacement;
        (void)snprintf(text, n, "[%s %c %ld]", bases[o->memory.rm], d < 0 ? '-' : '+', d < 0 ? -d : d);
    }
}
int format_instruction(const Instruction *ins, char *out, size_t size)
{
    static const char *const names[] = {"mov","add","sub","cmp"};
    if (!ins || !out || ins->op < OP_MOV || ins->op > OP_CMP ||
        !valid(&ins->dst, 0) || !valid(&ins->src, 1) ||
        ins->dst.wide != ins->src.wide ||
        (ins->dst.kind == OPERAND_MEM && ins->src.kind == OPERAND_MEM)) return 0;
    char dst[40], src[40], text[DEC_MAX_TEXT];
    operand_text(&ins->dst, dst, sizeof dst);
    operand_text(&ins->src, src, sizeof src);
    /* Register width already determines memory width. Only memory + immediate
       needs an explicit byte/word qualifier in the course's NASM-style text. */
    const char *width = ins->dst.kind == OPERAND_MEM && ins->src.kind == OPERAND_IMM
                        ? (ins->dst.wide ? "word " : "byte ") : "";
    int n = snprintf(text, sizeof text, "%s %s%s, %s", names[ins->op], width, dst, src);
    if (n < 0 || (size_t)n >= sizeof text || (size_t)n >= size) return 0;
    memcpy(out, text, (size_t)n + 1);
    return 1;
}

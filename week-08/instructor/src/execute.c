/* E03 reference: validation and both reads precede the state commit. */
#include "sim.h"
static int valid_operand(const Operand *o, int immediate)
{
    if (o->wide>1) return 0;
    if (o->kind==OPERAND_REG) return o->reg<8;
    if (o->kind==OPERAND_IMM)
        return immediate && (o->wide ? o->imm>=-32768 && o->imm<=32767 : o->imm>=-128 && o->imm<=127);
    if (o->kind!=OPERAND_MEM || o->memory.direct>1) return 0;
    if (o->memory.direct) return !o->memory.rm && !o->memory.displacement;
    return o->memory.rm<8 && !o->memory.address &&
           o->memory.displacement>=-32768 && o->memory.displacement<=32767;
}
SimStatus sim_step(const Instruction *ins, CpuState *state)
{
    if (!ins || !state) return SIM_INVALID_ARGUMENT;
    if (ins->op<OP_MOV || ins->op>OP_CMP || ins->length<2 || ins->length>6 ||
        !valid_operand(&ins->dst,0) || !valid_operand(&ins->src,1) ||
        ins->dst.wide!=ins->src.wide ||
        (ins->dst.kind==OPERAND_MEM && ins->src.kind==OPERAND_MEM)) return SIM_INVALID_INSTRUCTION;
    if (ins->dst.kind==OPERAND_MEM || ins->src.kind==OPERAND_MEM) return SIM_UNSUPPORTED_OPERAND;
    /* Keep original state available even for overlapping AL/AH operands. */
    CpuState next=*state;
    uint16_t left=0, right=0;
    (void)sim_read_register(state,ins->dst.wide,ins->dst.reg,&left);
    if (ins->src.kind==OPERAND_REG)
        (void)sim_read_register(state,ins->src.wide,ins->src.reg,&right);
    else right=(uint16_t)((uint32_t)ins->src.imm & (ins->src.wide ? 65535u : 255u));
    if (ins->op==OP_MOV) (void)sim_write_register(&next,ins->dst.wide,ins->dst.reg,right);
    else {
        AluResult arithmetic;
        (void)sim_alu(ins->op,ins->dst.wide,left,right,&arithmetic);
        /* Only the modeled bits change. CMP deliberately skips the write. */
        next.flags=(uint16_t)(((unsigned)next.flags & (65535u ^ FLAG_ARITH)) | arithmetic.flags);
        if (ins->op!=OP_CMP) (void)sim_write_register(&next,ins->dst.wide,ins->dst.reg,arithmetic.value);
    }
    next.ip=(uint16_t)(((uint32_t)next.ip+ins->length) & 65535u);
    *state=next;
    return SIM_OK;
}

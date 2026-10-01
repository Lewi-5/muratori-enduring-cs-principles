#include "machine.h"
/* Build a boundary map before a step: no target can select an immediate byte.
   This intentionally simple teaching implementation favors auditability over
   throughput. A cached map belongs in an optional optimization, not ISA state. */
static MachineStatus boundaries(const uint8_t *code, size_t n, uint8_t *map)
{
    size_t cursor=0;
    while (cursor<n) {
        Decoded d;
        map[cursor]=1;
        MachineStatus s=machine_decode(code+cursor,n-cursor,&d);
        if (s!=M_OK) return s;
        cursor+=d.length;
    }
    map[n]=1;
    return M_OK;
}
static int condition(unsigned code, uint16_t flags)
{
    int c=(flags & FLAG_CF)!=0, z=(flags & FLAG_ZF)!=0;
    int s=(flags & FLAG_SF)!=0, o=(flags & FLAG_OF)!=0, p=(flags & FLAG_PF)!=0;
    switch (code) {
    case 0: return o; case 1: return !o; case 2: return c; case 3: return !c;
    case 4: return z; case 5: return !z; case 6: return c || z; case 7: return !c && !z;
    case 8: return s; case 9: return !s; case 10: return p; case 11: return !p;
    case 12: return s!=o; case 13: return s==o; case 14: return z || s!=o;
    case 15: return !z && s==o;
    }
    return 0;
}
static uint16_t address(const Address *a, const CpuState *cpu)
{
    if (a->direct) return a->address;
    static const unsigned first[8]={REG_BX,REG_BX,REG_BP,REG_BP,REG_SI,REG_DI,REG_BP,REG_BX};
    static const unsigned second[4]={REG_SI,REG_DI,REG_SI,REG_DI};
    uint32_t sum=cpu->regs[first[a->rm]];
    if (a->rm<4) sum+=cpu->regs[second[a->rm]];
    return (uint16_t)((sum+(uint32_t)a->displacement) & 65535u);
}
static uint16_t read_operand(const Operand *o, const Machine *m)
{
    uint16_t value=0;
    if (o->kind==OPERAND_REG) (void)sim_read_register(&m->cpu,o->wide,o->reg,&value);
    else if (o->kind==OPERAND_IMM) value=(uint16_t)((uint32_t)o->imm & (o->wide ? 65535u : 255u));
    else {
        unsigned a=address(&o->memory,&m->cpu);
        unsigned word=m->memory[a];
        if (o->wide) word|=(unsigned)m->memory[(a+1u) & 65535u] << 8;
        value=(uint16_t)word;
    }
    return value;
}
static void write_operand(const Operand *o, Machine *m, uint16_t value, uint16_t a)
{
    if (o->kind==OPERAND_REG) (void)sim_write_register(&m->cpu,o->wide,o->reg,value);
    else {
        m->memory[a]=(uint8_t)(value & 255u);
        if (o->wide) m->memory[((unsigned)a+1u) & 65535u]=(uint8_t)((unsigned)value >> 8);
    }
}
MachineStatus machine_step(const uint8_t *code, size_t n, Machine *m)
{
    if (!m || (!code && n) || n>65535) return M_ARGUMENT;
    uint8_t map[65536]={0};
    MachineStatus status=boundaries(code,n,map);
    if (status!=M_OK) return status;
    unsigned ip=m->cpu.ip;
    if (ip>=n || !map[ip]) return M_TARGET;
    Decoded d;
    status=machine_decode(code+ip,n-ip,&d);
    if (status!=M_OK) return status;
    Machine next=*m;
    unsigned after=ip+d.length;
    next.cpu.ip=(uint16_t)after;
    switch (d.kind) {
    case X_PUSH: {
        uint16_t value=m->cpu.regs[d.reg];
        /* Original 8086 quirk; later x86 PUSH SP semantics differ. */
        if (d.reg==REG_SP) value=(uint16_t)(((unsigned)value-2u) & 65535u);
        status=machine_push(&next,value);
        break;
    }
    case X_POP: {
        uint16_t value;
        status=machine_pop(&next,&value);
        if (status==M_OK) {
            if (d.reg==REG_SP && (value<next.stack_low || value>next.stack_high)) status=M_STACK;
            else next.cpu.regs[d.reg]=value;
        }
        break;
    }
    case X_RET: {
        uint16_t value;
        status=machine_pop(&next,&value);
        if (status==M_OK) {
            if (value>n || !map[value]) status=M_TARGET;
            else next.cpu.ip=value;
        }
        break;
    }
    case X_CALL: case X_JMP: case X_JCC: {
        if (d.kind==X_JCC && !condition(d.condition,m->cpu.flags)) break;
        uint16_t target=(uint16_t)(((uint32_t)after+(uint32_t)d.relative) & 65535u);
        if (target>n || !map[target]) { status=M_TARGET; break; }
        if (d.kind==X_CALL) status=machine_push(&next,(uint16_t)after);
        if (status==M_OK) next.cpu.ip=target;
        break;
    }
    case X_INC: case X_DEC: {
        AluResult a;
        (void)sim_alu(d.kind==X_INC ? OP_ADD : OP_SUB,1,m->cpu.regs[d.reg],1,&a);
        next.cpu.regs[d.reg]=a.value;
        unsigned replaced=FLAG_ARITH ^ FLAG_CF;
        next.cpu.flags=(uint16_t)(((unsigned)m->cpu.flags & (65535u ^ replaced)) | ((unsigned)a.flags & replaced));
        break;
    }
    case X_BASE: {
        uint16_t left=read_operand(&d.base.dst,m), right=read_operand(&d.base.src,m);
        uint16_t a=d.base.dst.kind==OPERAND_MEM ? address(&d.base.dst.memory,&m->cpu) : 0;
        if (d.base.op==OP_MOV) write_operand(&d.base.dst,&next,right,a);
        else {
            AluResult arithmetic;
            (void)sim_alu(d.base.op,d.base.dst.wide,left,right,&arithmetic);
            next.cpu.flags=(uint16_t)(((unsigned)m->cpu.flags & (65535u ^ FLAG_ARITH)) | arithmetic.flags);
            if (d.base.op!=OP_CMP) write_operand(&d.base.dst,&next,arithmetic.value,a);
        }
        break;
    }
    case X_NOP: break;
    }
    if (status==M_OK) *m=next;
    return status;
}

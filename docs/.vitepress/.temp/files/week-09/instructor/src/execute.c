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
static uint16_t address(const Address *a, const CpuState *cpu)
{
    uint16_t value=0;
    (void)machine_address(a,cpu,&value); /* fields came from checked decoder */
    return value;
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
    case X_JMP: case X_JCC: {
        if (d.kind==X_JCC && !machine_condition(d.condition,m->cpu.flags)) break;
        uint16_t target=(uint16_t)(((uint32_t)after+(uint32_t)d.relative) & 65535u);
        if (target>n || !map[target]) { status=M_TARGET; break; }
        next.cpu.ip=target;
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
    }
    if (status==M_OK) *m=next;
    return status;
}

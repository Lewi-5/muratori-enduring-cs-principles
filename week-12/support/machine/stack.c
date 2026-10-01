#include "machine.h"
static int valid_stack(const Machine *m)
{
    return m->stack_low<m->stack_high && m->cpu.regs[REG_SP]>=m->stack_low &&
           m->cpu.regs[REG_SP]<=m->stack_high;
}
MachineStatus machine_push(Machine *m, uint16_t value)
{
    if (!m) return M_ARGUMENT;
    if (!valid_stack(m) || (unsigned)m->cpu.regs[REG_SP]-(unsigned)m->stack_low<2u)
        return M_STACK;
    unsigned sp=(unsigned)m->cpu.regs[REG_SP]-2u;
    /* All checks precede writes. A numeric word never aliases host storage. */
    m->memory[sp]=(uint8_t)(value & 255u);
    m->memory[sp+1u]=(uint8_t)((unsigned)value >> 8);
    m->cpu.regs[REG_SP]=(uint16_t)sp;
    return M_OK;
}
MachineStatus machine_pop(Machine *m, uint16_t *value)
{
    if (!m || !value) return M_ARGUMENT;
    if (!valid_stack(m) || (unsigned)m->stack_high-(unsigned)m->cpu.regs[REG_SP]<2u)
        return M_STACK;
    unsigned sp=m->cpu.regs[REG_SP];
    uint16_t result=(uint16_t)((unsigned)m->memory[sp] | ((unsigned)m->memory[sp+1u] << 8));
    m->cpu.regs[REG_SP]=(uint16_t)(sp+2u);
    *value=result;
    return M_OK;
}

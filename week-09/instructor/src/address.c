#include "machine.h"
int machine_address(const Address *a, const CpuState *cpu, uint16_t *out)
{
    if (!a || !cpu || !out || a->direct>1) return 0;
    if (a->direct) { *out=a->address; return 1; }
    if (a->rm>7 || a->displacement < -32768 || a->displacement>32767) return 0;
    static const unsigned first[8]={REG_BX,REG_BX,REG_BP,REG_BP,REG_SI,REG_DI,REG_BP,REG_BX};
    static const unsigned second[4]={REG_SI,REG_DI,REG_SI,REG_DI};
    uint32_t sum=cpu->regs[first[a->rm]];
    if (a->rm<4) sum+=cpu->regs[second[a->rm]];
    /* Signed -> unsigned conversion is defined modulo 2^32; masking retains
       the desired low 16 bits, including a negative displacement. */
    *out=(uint16_t)((sum+(uint32_t)a->displacement) & 65535u);
    return 1;
}

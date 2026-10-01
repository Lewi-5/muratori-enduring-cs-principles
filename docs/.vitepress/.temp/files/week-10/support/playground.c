#include "machine.h"
#include <stdio.h>
int main(void)
{
    const uint8_t code[]={0xb8,0x34,0x12,0xe8,0x02,0x00,0xeb,0x0c,0x50,
                          0xb8,0x78,0x56,0xe8,0x03,0x00,0x5b,0xc3,0x90,0x40,0xc3};
    Machine m={0};
    m.stack_low=0x80; m.stack_high=0x100; m.cpu.regs[REG_SP]=0x100;
    MachineResult r=machine_run(code,sizeof code,100,&m);
    if (r.status!=M_OK) { puts(machine_status_name(r.status)); return 1; }
    printf("ax=%04x bx=%04x sp=%04x ip=%04x steps=%zu\n",(unsigned)m.cpu.regs[REG_AX],
           (unsigned)m.cpu.regs[REG_BX],(unsigned)m.cpu.regs[REG_SP],(unsigned)m.cpu.ip,r.steps);
    printf("stale return bytes=%02x %02x saved ax bytes=%02x %02x\n",
           (unsigned)m.memory[0xfe],(unsigned)m.memory[0xff],
           (unsigned)m.memory[0xfc],(unsigned)m.memory[0xfd]);
    return 0;
}

#include "machine.h"
#include <stdio.h>
int main(void)
{
    const uint8_t code[]={0xb9,3,0,0xbb,0,1,0xc6,7,0,0x80,7,1,0x83,0xe9,1,0x75,0xf8,0x8a,7};
    Machine m={0};
    MachineResult r=machine_run(code,sizeof code,100,&m);
    if (r.status!=M_OK) { puts(machine_status_name(r.status)); return 1; }
    printf("ax=%04x cx=%04x ip=%04x steps=%zu data[0100]=%u\n",(unsigned)m.cpu.regs[REG_AX],
           (unsigned)m.cpu.regs[REG_CX],(unsigned)m.cpu.ip,r.steps,(unsigned)m.memory[0x100]);
    return 0;
}

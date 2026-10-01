#include "project.h"
#include <stdio.h>
int main(void)
{
    const uint8_t code[]={0xbb,0,1,0xb9,3,0,0xb0,0,0xe8,5,0,0x49,0x75,0xfa,0xeb,6,0x50,0x80,7,1,0x58,0xc3};
    CodeImage image;MachineResult r=project_prepare(code,sizeof code,&image);
    Machine m={0};m.stack_low=0x80;m.stack_high=0x100;m.cpu.regs[REG_SP]=0x100;
    if (r.status==M_OK) r=project_run(&image,100,&m);
    if (r.status!=M_OK) { puts(machine_status_name(r.status));return 1; }
    printf("data[0100]=%u cx=%u sp=%04x ip=%04x steps=%zu\n",(unsigned)m.memory[0x100],
           (unsigned)m.cpu.regs[REG_CX],(unsigned)m.cpu.regs[REG_SP],(unsigned)m.cpu.ip,r.steps);
    return 0;
}

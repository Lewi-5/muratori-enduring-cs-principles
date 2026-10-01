#include "machine.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
int main(void)
{
    uint8_t code[]={0xb0,0x80,0x3c,1,0x72,0xfc};
    Machine m={0},zero=m;
    MachineResult r=machine_run(code,sizeof code,6,&m);
    assert(r.status==M_OK && r.steps==3 && m.cpu.regs[REG_AX]==0x80);
    printf("unsigned %s steps=%zu ax=%04x\n",machine_status_name(r.status),r.steps,(unsigned)m.cpu.regs[REG_AX]);
    code[4]=0x7c;m=zero;r=machine_run(code,sizeof code,6,&m);
    assert(r.status==M_LIMIT && r.steps==6 && r.offset==4 && memcmp(&m,&zero,sizeof m)==0);
    printf("signed %s steps=%zu rolled_back=yes\n",machine_status_name(r.status),r.steps);
    return 0;
}

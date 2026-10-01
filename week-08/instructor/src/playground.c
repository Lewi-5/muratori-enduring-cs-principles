#include <stdio.h>
#include "sim.h"
int main(void)
{
    const uint8_t program[]={0xb0,0x7f,0x04,0x01,0x3c,0x80,0xb4,0x12};
    CpuState state={0};
    for (size_t offset=0; offset<sizeof program;) {
        Instruction ins; char text[DEC_MAX_TEXT];
        if (decode_one(program+offset,sizeof program-offset,&ins)!=DEC_OK ||
            !format_instruction(&ins,text,sizeof text)) return 1;
        uint16_t before=state.regs[0];
        if (sim_step(&ins,&state)!=SIM_OK) return 1;
        printf("%s: ax %04x -> %04x flags=%04x ip=%u\n",text,(unsigned)before,
               (unsigned)state.regs[0],(unsigned)state.flags,(unsigned)state.ip);
        offset+=ins.length;
    }
    return 0;
}

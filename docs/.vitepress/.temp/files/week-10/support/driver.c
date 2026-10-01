#include "machine.h"
#include <stdio.h>
static void trace(const Machine *m, unsigned before)
{
    printf("%04x -> %04x ax=%04x bx=%04x sp=%04x flags=%04x\n",before,
           (unsigned)m->cpu.ip,(unsigned)m->cpu.regs[REG_AX],
           (unsigned)m->cpu.regs[REG_BX],(unsigned)m->cpu.regs[REG_SP],(unsigned)m->cpu.flags);
}
int main(int argc, char **argv)
{
    if (argc!=2) { fputs("usage: sim8086 FILE\n",stderr); return 1; }
    FILE *file=fopen(argv[1],"rb");
    if (!file) { fputs("input error\n",stderr); return 1; }
    uint8_t code[65536];
    size_t n=fread(code,1,sizeof code,file);
    int failed=ferror(file);
    if (fclose(file)!=0) failed=1;
    if (failed || n>65535) { fputs("input error or code too large\n",stderr); return 1; }
    Machine start={0};
    start.stack_low=0x80; start.stack_high=0x100; start.cpu.regs[REG_SP]=0x100;
    Machine checked=start;
    MachineResult r=machine_run(code,n,10000,&checked);
    if (r.status!=M_OK) {
        fprintf(stderr,"%s offset=%zu steps=%zu\n",machine_status_name(r.status),r.offset,r.steps);
        return 1;
    }
    while (start.cpu.ip!=n) {
        unsigned before=start.cpu.ip;
        if (machine_step(code,n,&start)!=M_OK) { fputs("replay error\n",stderr); return 1; }
        trace(&start,before);
    }
    printf("final ip=%04x ax=%04x bx=%04x sp=%04x steps=%zu\n",(unsigned)checked.cpu.ip,
           (unsigned)checked.cpu.regs[REG_AX],(unsigned)checked.cpu.regs[REG_BX],
           (unsigned)checked.cpu.regs[REG_SP],r.steps);
    if (fflush(stdout)==EOF || ferror(stdout)) { fputs("output error\n",stderr); return 1; }
    return 0;
}

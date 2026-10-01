#include "project.h"
#include <stdio.h>
static void print_record(const TraceRecord *r)
{
    static const char *names[8]={"ax","cx","dx","bx","sp","bp","si","di"};
    printf("%04x -> %04x",(unsigned)r->before_ip,(unsigned)r->after.ip);
    for (unsigned k=0;k<8;++k) printf(" %s=%04x",names[k],(unsigned)r->after.regs[k]);
    printf(" flags=%04x mem=",(unsigned)r->after.flags);
    if (!r->changed_count) putchar('-');
    for (unsigned k=0;k<r->changed_count;++k)
        printf("%s%04x:%02x",k ? "," : "",(unsigned)r->addresses[k],(unsigned)r->values[k]);
    putchar('\n');
}
int main(int argc,char **argv)
{
    if (argc!=2) { fputs("usage: sim8086 FILE\n",stderr);return 1; }
    FILE *f=fopen(argv[1],"rb");
    if (!f) { fputs("input error\n",stderr);return 1; }
    uint8_t bytes[65536];size_t n=fread(bytes,1,sizeof bytes,f);
    int bad=ferror(f);if (fclose(f)!=0) bad=1;
    if (bad || n>65535) { fputs("input error or code too large\n",stderr);return 1; }
    CodeImage image;MachineResult r=project_prepare(bytes,n,&image);
    Machine m={0};m.stack_low=0x80;m.stack_high=0x100;m.cpu.regs[REG_SP]=0x100;
    /* Bound trace storage is a CLI limit, not a guest ISA register. */
    TraceRecord records[1024];size_t count=0;
    if (r.status==M_OK) r=project_trace(&image,10000,&m,records,1024,&count);
    if (r.status!=M_OK) {
        fprintf(stderr,"%s offset=%zu steps=%zu\n",machine_status_name(r.status),r.offset,r.steps);return 1;
    }
    for (size_t k=0;k<count;++k) print_record(&records[k]);
    printf("final ip=%04x ax=%04x cx=%04x bx=%04x sp=%04x flags=%04x data[0100]=%02x steps=%zu\n",
           (unsigned)m.cpu.ip,(unsigned)m.cpu.regs[REG_AX],(unsigned)m.cpu.regs[REG_CX],
           (unsigned)m.cpu.regs[REG_BX],(unsigned)m.cpu.regs[REG_SP],(unsigned)m.cpu.flags,
           (unsigned)m.memory[0x100],r.steps);
    if (fflush(stdout)==EOF || ferror(stdout)) { fputs("output error\n",stderr);return 1; }
    return 0;
}

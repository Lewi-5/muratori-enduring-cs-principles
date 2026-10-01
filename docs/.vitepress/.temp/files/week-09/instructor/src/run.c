#include "machine.h"
MachineResult machine_run(const uint8_t *code, size_t n, size_t limit, Machine *m)
{
    MachineResult result={M_ARGUMENT,0,0};
    if (!m || (!code && n) || n>65535 || !limit) return result;
    /* Validation before execution makes unreachable malformed bytes errors. */
    uint8_t map[65536]={0};
    size_t cursor=0;
    while (cursor<n) {
        Decoded d;
        map[cursor]=1;
        result.status=machine_decode(code+cursor,n-cursor,&d);
        if (result.status!=M_OK) { result.offset=cursor; return result; }
        cursor+=d.length;
    }
    map[n]=1;
    if (m->cpu.ip>n || !map[m->cpu.ip]) { result.status=M_TARGET; result.offset=m->cpu.ip; return result; }
    Machine next=*m;
    while (next.cpu.ip!=n) {
        result.offset=next.cpu.ip;
        if (result.steps==limit) { result.status=M_LIMIT; return result; }
        result.status=machine_step(code,n,&next);
        if (result.status!=M_OK) return result;
        ++result.steps;
    }
    result.status=M_OK;
    result.offset=n;
    *m=next;
    return result;
}

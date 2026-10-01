/* Consume independently generated arithmetic expectations, one per line. */
#include <stdio.h>
#include "sim.h"
int main(void)
{
    unsigned op,wide,a,b,expected,flags; size_t count=0;
    int fields;
    while ((fields=scanf("%u %u %u %u %u %u",&op,&wide,&a,&b,&expected,&flags))==6) {
        AluResult result;
        if (!sim_alu((Operation)op,wide,(uint16_t)a,(uint16_t)b,&result) ||
            result.value!=expected || result.flags!=flags) {
            fprintf(stderr,"mismatch op=%u width=%u a=%u b=%u expected=%u flags=%u\n",op,wide,a,b,expected,flags);
            return 1;
        }
        ++count;
    }
    if (fields!=EOF || ferror(stdin)) return 1;
    printf("PASS %zu independent arithmetic cases\n",count); return 0;
}

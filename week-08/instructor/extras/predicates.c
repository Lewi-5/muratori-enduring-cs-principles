/* S01: evaluate two predicates on a supplied CMP result; no branches added
   to the guest instruction set. make PACKAGE=instructor extras */
#include <stdio.h>
#include "sim.h"
int main(void)
{
    AluResult r;
    if (!sim_alu(OP_CMP,0,128,1,&r)) return 1;
    int unsigned_less=(r.flags & FLAG_CF)!=0;
    int signed_less=((r.flags & FLAG_SF)!=0)!=((r.flags & FLAG_OF)!=0);
    printf("128 versus 1: unsigned_less=%d signed_less=%d\n",unsigned_less,signed_less);
    if (unsigned_less!=0 || signed_less!=1) return 1;
    if (!sim_alu(OP_CMP,0,128,128,&r)) return 1;
    unsigned_less=(r.flags & FLAG_CF)!=0;
    signed_less=((r.flags & FLAG_SF)!=0)!=((r.flags & FLAG_OF)!=0);
    int equal=(r.flags & FLAG_ZF)!=0;
    printf("128 versus 128: unsigned_less=%d signed_less=%d equal=%d\n",unsigned_less,signed_less,equal);
    return !unsigned_less && !signed_less && equal ? 0 : 1;
}

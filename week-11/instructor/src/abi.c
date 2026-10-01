#include "lab.h"
int abi_plan(const AbiType *types, size_t n, AbiPlan *out)
{
    if (!out || (!types && n) || n>ABI_MAX_ARGS) return 0;
    AbiPlan p={0};
    unsigned gp=0, fp=0, stack=0;
    for (size_t k=0; k<n; ++k) {
        AbiType type=types[k];
        if (type!=ABI_INTEGER && type!=ABI_POINTER && type!=ABI_DOUBLE) return 0;
        AbiLocation location={0};
        if (type==ABI_DOUBLE && fp<8) { location.place=ABI_XMM; location.index=fp++; }
        else if (type!=ABI_DOUBLE && gp<6) { location.place=ABI_GP; location.index=gp++; }
        else { location.place=ABI_STACK; location.offset=8u+8u*stack++; }
        p.args[k]=location;
    }
    p.count=(unsigned)n;
    p.stack_words=stack;
    p.reserve_bytes=(stack*8u+15u) & ~15u;
    *out=p;
    return 1;
}

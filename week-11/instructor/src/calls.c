#include "lab.h"
int keep_across_call(uint64_t seed, uint64_t (*fn)(uint64_t), uint64_t *out)
{
    if (!fn || !out) return 0;
    /* The C compiler owns preservation of seed/out across the indirect call.
       Do not assume caller-clobbered argument registers retain these values. */
    uint64_t transformed=fn(seed+UINT64_C(1));
    *out=seed+transformed;
    return 1;
}

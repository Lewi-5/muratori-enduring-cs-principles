#include "lab.h"
int keep_across_call(uint64_t seed, uint64_t (*fn)(uint64_t), uint64_t *out)
{
    (void)seed; (void)fn; (void)out; return 0;
}

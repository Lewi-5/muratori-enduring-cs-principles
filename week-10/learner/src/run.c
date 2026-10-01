#include "machine.h"
MachineResult machine_run(const uint8_t *code, size_t n, size_t limit, Machine *m)
{
    /* E04: predecode boundaries, run tentatively with budget, commit at halt. */
    (void)code; (void)n; (void)limit; (void)m;
    MachineResult r={M_ARGUMENT,0,0}; return r;
}

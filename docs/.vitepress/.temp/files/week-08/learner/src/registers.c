#include "sim.h"
int sim_read_register(const CpuState *state, unsigned wide, unsigned code, uint16_t *out)
{
    /* TODO E01: map guest byte aliases into the word bank. */
    (void)state; (void)wide; (void)code; (void)out; return 0;
}
int sim_write_register(CpuState *state, unsigned wide, unsigned code, uint16_t value)
{
    /* TODO E01: preserve the other half of a byte register. */
    (void)state; (void)wide; (void)code; (void)value; return 0;
}

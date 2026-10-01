/* E01 reference: numeric guest views, independent of host byte order. */
#include "sim.h"
int sim_read_register(const CpuState *state, unsigned wide, unsigned code, uint16_t *out)
{
    if (!state || !out || wide>1 || code>7) return 0;
    uint16_t value;
    if (wide) value=state->regs[code];
    else {
        /* AL..BL and AH..BH share slots 0..3, selecting different halves. */
        unsigned slot=code & 3u, shift=code<4 ? 0u : 8u;
        value=(uint16_t)(((uint32_t)state->regs[slot] >> shift) & 255u);
    }
    *out=value;
    return 1;
}
int sim_write_register(CpuState *state, unsigned wide, unsigned code, uint16_t value)
{
    if (!state || wide>1 || code>7 || (!wide && value>255)) return 0;
    if (wide) state->regs[code]=value;
    else {
        unsigned slot=code & 3u, shift=code<4 ? 0u : 8u;
        /* Clear only the destination half, preserving the companion byte. */
        uint32_t mask=255u << shift;
        uint32_t word=state->regs[slot];
        state->regs[slot]=(uint16_t)((word & (65535u ^ mask)) | ((uint32_t)value << shift));
    }
    return 1;
}

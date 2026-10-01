#include "sim.h"
RunResult sim_run(const uint8_t *bytes, size_t n, CpuState *state)
{
    /* TODO E04: independent file cursor, local state, whole-program commit. */
    (void)bytes; (void)n; (void)state;
    RunResult result={SIM_INVALID_ARGUMENT,DEC_OK,0,0}; return result;
}

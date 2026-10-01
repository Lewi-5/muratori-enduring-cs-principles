#include "machine.h"
MachineStatus machine_step(const uint8_t *code, size_t n, Machine *m)
{
    /* E03: fetch by guest IP; validate targets; execute into a local Machine. */
    (void)code; (void)n; (void)m; return M_TARGET;
}

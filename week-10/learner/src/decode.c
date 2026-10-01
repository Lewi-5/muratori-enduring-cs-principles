#include "machine.h"
MachineStatus machine_decode(const uint8_t *bytes, size_t n, Decoded *out)
{
    /* E02: extend pinned decoder; commit the complete description on success. */
    (void)bytes; (void)n; (void)out; return M_DECODE;
}

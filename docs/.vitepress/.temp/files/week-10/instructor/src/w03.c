#include "machine.h"
int w03(const uint8_t *bytes, uint16_t *out)
{
    if (!bytes || !out) return 0;
    *out=(uint16_t)((unsigned)bytes[0] | ((unsigned)bytes[1] << 8));
    return 1;
}

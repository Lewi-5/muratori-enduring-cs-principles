#include "machine.h"
int w02(unsigned high, unsigned sp, unsigned *out)
{
    if (!out || high>65535 || sp>high) return 0;
    *out=(high-sp)/2u;
    return 1;
}

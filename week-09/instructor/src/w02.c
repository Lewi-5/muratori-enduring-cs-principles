#include "machine.h"
int w02(unsigned next, int32_t d, uint16_t *out)
{ if (!out || next>65535 || d < -32768 || d>32767) return 0; *out=(uint16_t)(((uint32_t)next+(uint32_t)d) & 65535u); return 1; }

#include "machine.h"
int w03(const uint8_t *b, uint16_t *out)
{ if (!b || !out) return 0; *out=(uint16_t)((unsigned)b[0] | ((unsigned)b[1] << 8)); return 1; }

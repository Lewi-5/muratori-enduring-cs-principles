#include "project.h"
int w03(uint16_t word,uint8_t *bytes)
{ if (!bytes) return 0; bytes[0]=(uint8_t)(word & 255u); bytes[1]=(uint8_t)((unsigned)word >> 8); return 1; }

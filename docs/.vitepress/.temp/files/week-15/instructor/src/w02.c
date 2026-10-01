#include "lab.h"
int w02(uint32_t key,unsigned pass,unsigned *out) { if (!out || pass>=4) return 0; *out=(key>>(pass*8))&255u; return 1; }

#include "timing.h"
int w02(uint64_t b,uint64_t e,uint64_t *out)
{ if (!out || e<b) return 0; *out=e-b;return 1; }

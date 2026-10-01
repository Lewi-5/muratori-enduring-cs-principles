#include "timing.h"
int w03(uint64_t t,uint64_t b,uint64_t *out)
{ if (!out || !b) return 0; *out=t/b+(t%b!=0);return 1; }

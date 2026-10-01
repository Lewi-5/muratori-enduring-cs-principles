#include "timing.h"
int w01(uint64_t sec,unsigned ns,uint64_t *out)
{ if (!out || ns>=1000000000u || sec>(UINT64_MAX-ns)/UINT64_C(1000000000)) return 0; *out=sec*UINT64_C(1000000000)+ns; return 1; }

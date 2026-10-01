#include "profile.h"
int w01(uint64_t inclusive,uint64_t child,uint64_t *out)
{ if (!out || child>inclusive) return 0;*out=inclusive-child;return 1; }

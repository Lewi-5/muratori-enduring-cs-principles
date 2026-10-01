#include "machine.h"
int w01(unsigned v, int32_t *out)
{ if (!out || v>255) return 0; *out=v<128 ? (int32_t)v : (int32_t)v-256; return 1; }

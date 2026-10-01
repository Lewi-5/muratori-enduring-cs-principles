#include "profile.h"
int w02(uint64_t old,uint64_t *out)
{ if (!out || old==UINT64_MAX) return 0;*out=old+1;return 1; }

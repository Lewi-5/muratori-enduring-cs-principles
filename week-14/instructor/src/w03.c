#include "profile.h"
int w03(uint64_t part,uint64_t whole,double *out)
{ if (!out || !whole) return 0;*out=(double)part/(double)whole;return 1; }

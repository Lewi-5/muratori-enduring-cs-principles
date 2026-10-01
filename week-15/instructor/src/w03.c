#include "lab.h"
int w03(size_t n,size_t *out) { if (!out || n>SIZE_MAX/sizeof(Item)) return 0; *out=n*sizeof(Item); return 1; }

#include "lab.h"
int w02(size_t n,size_t *out) { if (!out || n>SIZE_MAX/sizeof(int)) return 0; *out=n*sizeof(int); return 1; }

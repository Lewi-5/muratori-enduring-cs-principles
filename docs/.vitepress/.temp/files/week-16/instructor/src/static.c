#include "lab.h"
int static_next(uint64_t *out) { static uint64_t counter; if (!out) return 0; counter+=UINT64_C(1); *out=counter; return 1; }

#include "timing.h"
/* TODO: implement the public contract. */
TimeStatus timing_ns(const struct timespec *t,uint64_t *o){(void)t;(void)o;return T_ARGUMENT;}
TimeStatus timing_elapsed(uint64_t b,uint64_t e,uint64_t *o){(void)b;(void)e;(void)o;return T_ARGUMENT;}
TimeStatus timing_monotonic(void *c,ClockStamp *o){(void)c;(void)o;return T_ARGUMENT;}

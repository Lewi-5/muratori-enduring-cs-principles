#include "timing.h"
TimeStatus timing_ns(const struct timespec *t,uint64_t *out)
{
    if (!t || !out || t->tv_sec<0 || t->tv_nsec<0 || t->tv_nsec>=1000000000L) return T_ARGUMENT;
    uintmax_t seconds=(uintmax_t)t->tv_sec;
    uint64_t nanos=(uint64_t)t->tv_nsec;
    if (seconds>(UINT64_MAX-nanos)/UINT64_C(1000000000)) return T_OVERFLOW;
    *out=(uint64_t)seconds*UINT64_C(1000000000)+nanos;return T_OK;
}
TimeStatus timing_elapsed(uint64_t begin,uint64_t end,uint64_t *out)
{
    if (!out) return T_ARGUMENT;
    if (end<begin) return T_ORDER;
    *out=end-begin;return T_OK;
}
TimeStatus timing_monotonic(void *context,ClockStamp *out)
{
    (void)context;
    if (!out) return T_ARGUMENT;
    struct timespec t;
    if (clock_gettime(CLOCK_MONOTONIC,&t)!=0) return T_CLOCK;
    ClockStamp stamp={0};TimeStatus s=timing_ns(&t,&stamp.value);
    if (s==T_OK) *out=stamp;
    return s;
}

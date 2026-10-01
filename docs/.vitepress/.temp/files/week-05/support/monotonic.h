#ifndef WEEK05_MONOTONIC_H
#define WEEK05_MONOTONIC_H
/* Supplied: a nanosecond reading of CLOCK_MONOTONIC. No exercise answer lives here.

   Source of each claim:
   - clock_gettime, clock_getres and CLOCK_MONOTONIC are POSIX (and Linux), not ISO C. ISO C's clock() measures
     processor time (C11 7.27.2.1), a different quantity; timespec_get (C11 7.27.2.5) gives only calendar time.
   - CLOCK_MONOTONIC cannot be set and does not jump when the wall clock is changed; Linux documents that it is
     affected by gradual NTP frequency adjustment (clock_gettime(2)). It counts time, not processor cycles.
   - The reported resolution is what clock_getres says; the real granularity of successive readings can be coarser.

   Overflow contract: tv_sec * 1000000000 + tv_nsec is computed in uint64_t only after checking that tv_sec is
   nonnegative, tv_nsec is in [0, 999999999], and tv_sec <= (UINT64_MAX - 999999999) / 1000000000
   (18446744072, about 584 years of uptime). Otherwise the call fails. Both functions return 1 on success and 0 on
   failure, leaving *out unchanged. Every caller must check the result. */
#include <stdint.h>
#include <time.h>

static inline int mono_timespec_ns(const struct timespec *ts, uint64_t *out)
{
    if (ts->tv_sec < 0 || ts->tv_nsec < 0 || ts->tv_nsec > 999999999L) return 0;
    uint64_t sec = (uint64_t)ts->tv_sec;
    if (sec > (UINT64_MAX - UINT64_C(999999999)) / UINT64_C(1000000000)) return 0;
    *out = sec * UINT64_C(1000000000) + (uint64_t)ts->tv_nsec;
    return 1;
}

static inline int mono_now_ns(uint64_t *out)
{
    struct timespec ts;
    if (out == NULL || clock_gettime(CLOCK_MONOTONIC, &ts) != 0) return 0;
    return mono_timespec_ns(&ts, out);
}

static inline int mono_resolution_ns(uint64_t *out)
{
    struct timespec ts;
    if (out == NULL || clock_getres(CLOCK_MONOTONIC, &ts) != 0) return 0;
    return mono_timespec_ns(&ts, out);
}
#endif

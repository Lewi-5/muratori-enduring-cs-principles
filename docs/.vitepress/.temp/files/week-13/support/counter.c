#include "timing.h"
#if defined(__x86_64__) && !defined(TIMING_NO_TSC)
#include <cpuid.h>
#include <x86intrin.h>
#include <stdatomic.h>
#endif
TimeStatus timing_counter_info(CounterInfo *out)
{
    if (!out) return T_ARGUMENT;
    CounterInfo info={0};
#if defined(__x86_64__) && !defined(TIMING_NO_TSC)
    unsigned a,b,c,d;
    if (__get_cpuid(1,&a,&b,&c,&d) && (d & (1u<<4)) &&
        __get_cpuid(0x80000001u,&a,&b,&c,&d) && (d & (1u<<27))) info.available=1;
    if (__get_cpuid(0x80000007u,&a,&b,&c,&d)) info.invariant=(d & (1u<<8))!=0;
#endif
    *out=info;return T_OK;
}
TimeStatus timing_counter_read(void *context,ClockStamp *out)
{
    if (!context || !out) return T_ARGUMENT;
    const CounterInfo *info=context;
    if (!info->available) return T_UNSUPPORTED;
#if defined(__x86_64__) && !defined(TIMING_NO_TSC)
    ClockStamp stamp;
    atomic_signal_fence(memory_order_seq_cst);
    _mm_lfence();stamp.value=(uint64_t)__rdtscp(&stamp.aux);_mm_lfence();
    atomic_signal_fence(memory_order_seq_cst);
    *out=stamp;return T_OK;
#else
    return T_UNSUPPORTED;
#endif
}

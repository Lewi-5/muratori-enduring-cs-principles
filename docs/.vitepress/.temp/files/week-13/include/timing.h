#ifndef WEEK13_TIMING_H
#define WEEK13_TIMING_H
#include <stddef.h>
#include <stdint.h>
#include <time.h>
enum { TIME_MAX_SAMPLES=64 };
typedef enum { T_OK,T_ARGUMENT,T_CLOCK,T_ORDER,T_OVERFLOW,T_WORK,T_UNSUPPORTED } TimeStatus;
typedef struct { uint64_t value; unsigned aux; } ClockStamp;
typedef TimeStatus (*ClockRead)(void *context,ClockStamp *out);
typedef struct { ClockRead read;void *context; } ClockSource;
typedef int (*WorkCall)(void *context,uint64_t *checksum);
typedef struct { WorkCall call;void *context; } Work;
typedef struct { uint64_t elapsed,checksum;unsigned begin_aux,end_aux;int aux_changed; } TimeSample;
typedef struct { uint64_t minimum,median,maximum;size_t zeros,aux_changes; } TimeSummary;
typedef struct { int available,invariant; } CounterInfo;
/* Caller owns accessible, disjoint storage. No globals, allocation or I/O in
   these APIs. Inputs immutable during calls; independent storage permits
   independent calls. Time units come from the chosen provider; do not mix
   clock domains. Every failure preserves library outputs. Callback/clock
   effects (including work already performed) are NOT rolled back. */
/* E01: normalize nonnegative timespec with 0<=tv_nsec<1e9 to uint64 ns,
   checking multiplication/addition overflow. elapsed rejects end<begin;
   equality succeeds with zero. monotonic reader uses CLOCK_MONOTONIC and
   commits aux=0. Its ignored context can be NULL. */
TimeStatus timing_ns(const struct timespec *stamp,uint64_t *out);
TimeStatus timing_elapsed(uint64_t begin,uint64_t end,uint64_t *out);
TimeStatus timing_monotonic(void *context,ClockStamp *out);
/* E02: validate pointers/function pointers, read begin, call work once,
   read end, compute delta. A read error propagates; work failure=T_WORK and
   does not call end reader. Reverse clock=T_ORDER. Record checksum and AUX
   values; unequal AUX is flagged, not silently accepted as calibrated time. */
TimeStatus timing_measure(const ClockSource *clock,const Work *work,TimeSample *out);
/* E03: n=1..64. Collect complete local sample array before publishing any
   output; callback effects remain. Summarize without mutating samples;
   median is LOWER middle for even n. Preserve every raw duration, including
   zeros and AUX changes. Overflow-safe comparisons, not subtract-and-narrow. */
TimeStatus timing_collect(const ClockSource *clock,const Work *work,size_t n,TimeSample *out);
TimeStatus timing_summary(const TimeSample *samples,size_t n,TimeSummary *out);
/* E04: empirical ticks/sec = ticks*1e9/ns, positive integer intervals;
   floating conversion avoids integer product overflow. This is neither
   calibrated CPU core frequency nor a claim about frequency invariance. */
TimeStatus timing_rate(uint64_t ticks,uint64_t ns,double *hz);
/* Supplied optional x86-64 experiment: CPUID probe outside timed regions.
   Reader context MUST be an unchanged CounterInfo from this probe, alive
   during reads. Feature absence/compile-time TIMING_NO_TSC gives UNSUPPORTED
   without executing RDTSCP. Advertised user-mode counter access is required.
   LFENCE/RDTSCP/LFENCE uses the documented Intel ordering model; does not
   guarantee store visibility, cross-core synchronization or VM fidelity.
   AUX equality cannot prove absence of migration. No raw RDTSC endpoint. */
TimeStatus timing_counter_info(CounterInfo *out);
TimeStatus timing_counter_read(void *context,ClockStamp *out);
/* W01 seconds/nanoseconds with same range/overflow rules; W02 ordered delta;
   W03 integer ceil(total/batch), batch>0, with no overflowing +batch-1. */
int w01(uint64_t seconds,unsigned nanos,uint64_t *out);
int w02(uint64_t begin,uint64_t end,uint64_t *out);
int w03(uint64_t total,uint64_t batch,uint64_t *out);
static inline const char *time_status_name(TimeStatus s)
{
    switch(s) {
    case T_OK:return "T_OK";case T_ARGUMENT:return "T_ARGUMENT";case T_CLOCK:return "T_CLOCK";
    case T_ORDER:return "T_ORDER";case T_OVERFLOW:return "T_OVERFLOW";case T_WORK:return "T_WORK";
    case T_UNSUPPORTED:return "T_UNSUPPORTED";
    }
    return "T_UNKNOWN";
}
#endif

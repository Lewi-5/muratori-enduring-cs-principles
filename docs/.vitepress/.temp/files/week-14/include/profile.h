#ifndef WEEK14_PROFILE_H
#define WEEK14_PROFILE_H
#include <stddef.h>
#include <stdint.h>
enum { PROFILE_IDS=16,PROFILE_DEPTH=32 };
typedef enum { P_OK,P_ARGUMENT,P_ORDER,P_NEST,P_CAPACITY,P_OVERFLOW,P_ACTIVE } ProfileStatus;
typedef struct { uint64_t inclusive,exclusive,hits; } Bucket;
typedef struct { unsigned id;uint64_t begin,children; } Frame;
typedef struct { Bucket totals[PROFILE_IDS];Frame stack[PROFILE_DEPTH];unsigned depth;uint64_t last;int has_time; } Profile;
typedef struct { Bucket totals[PROFILE_IDS];uint64_t covered,inclusive_sum,hits;unsigned used; } ProfileReport;
/* Zero-initialize Profile before first use. All event times are ordered ns
   from ONE clock domain. Caller owns accessible disjoint objects; no globals,
   allocation, clock reads or I/O in the profiler. Only API calls mutate state.
   Per-instance use is single-threaded/serialized: concurrent threads need
   separate Profiles. No locks/atomics, shared-instance thread safety or
   automatic scope exit. Every failure preserves complete state/outputs. */
/* E01: begin pushes id/start with zero child time; depth<=32 and id<16.
   end must match top id, with monotonic time across all successful events.
   elapsed=now-begin; exclusive=elapsed-immediate-child inclusive times.
   End accumulates this invocation and charges elapsed to its parent.
   Same-id recursion is allowed; inclusive sums ALL invocations and can exceed
   wall duration. On any nesting/order/capacity/overflow failure no event
   commits, including last-time field. Successful end clears popped frame. */
ProfileStatus profile_begin(Profile *profile,unsigned id,uint64_t now);
ProfileStatus profile_end(Profile *profile,unsigned id,uint64_t now);
/* E02: exclusive<=inclusive; add both totals and one hit with preflight
   uint64 overflow checks. Pure independent helper, output unchanged on error. */
ProfileStatus profile_accumulate(Bucket *bucket,uint64_t inclusive,uint64_t exclusive);
/* E03: only depth=0 may publish report; sum self time as covered, inclusive
   totals separately (may overlap) and hits, all overflow checked. Include all
   16 buckets in ID order and count used buckets by hits>0. Never clear input. */
ProfileStatus profile_report(const Profile *profile,ProfileReport *out);
/* E04: measured relative difference (instrumented-baseline)/baseline using
   floating conversion; baseline>0. Instrumented may be smaller (noise).
   This is not a fixed per-hook correction and can be negative. */
ProfileStatus profile_difference(uint64_t baseline,uint64_t instrumented,double *fraction);
/* W01 self=inclusive-child, reject child>inclusive. W02 checked hit increment.
   W03 ratio=part/whole, whole>0; overlap means part may exceed whole. */
int w01(uint64_t inclusive,uint64_t child,uint64_t *self);
int w02(uint64_t old,uint64_t *next);
int w03(uint64_t part,uint64_t whole,double *ratio);
static inline const char *profile_status_name(ProfileStatus s)
{
    switch(s) {
    case P_OK:return "P_OK";case P_ARGUMENT:return "P_ARGUMENT";case P_ORDER:return "P_ORDER";
    case P_NEST:return "P_NEST";case P_CAPACITY:return "P_CAPACITY";case P_OVERFLOW:return "P_OVERFLOW";
    case P_ACTIVE:return "P_ACTIVE";
    }
    return "P_UNKNOWN";
}
#endif

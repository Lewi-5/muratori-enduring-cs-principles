from pathlib import Path
import shutil
root=Path(__file__).resolve().parent
def put(n,name,text):
    p=root/f'week-{n:02}'/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text.strip()+'\n',encoding='utf-8',newline='\n')
put(13,'include/timing.h',r'''
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
''')
put(13,'instructor/src/clock.c',r'''
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
''')
put(13,'instructor/src/sample.c',r'''
#include "timing.h"
TimeStatus timing_measure(const ClockSource *clock,const Work *work,TimeSample *out)
{
    if (!clock || !work || !out || !clock->read || !work->call) return T_ARGUMENT;
    ClockStamp begin,end;uint64_t checksum;
    TimeStatus s=clock->read(clock->context,&begin);if (s!=T_OK) return s;
    if (!work->call(work->context,&checksum)) return T_WORK;
    s=clock->read(clock->context,&end);if (s!=T_OK) return s;
    TimeSample result={0};s=timing_elapsed(begin.value,end.value,&result.elapsed);
    if (s!=T_OK) return s;
    result.checksum=checksum;result.begin_aux=begin.aux;result.end_aux=end.aux;
    result.aux_changed=begin.aux!=end.aux;*out=result;return T_OK;
}
''')
put(13,'instructor/src/summary.c',r'''
#include "timing.h"
TimeStatus timing_collect(const ClockSource *clock,const Work *work,size_t n,TimeSample *out)
{
    if (!clock || !work || !out || !clock->read || !work->call || !n || n>TIME_MAX_SAMPLES) return T_ARGUMENT;
    TimeSample samples[TIME_MAX_SAMPLES];
    for (size_t k=0;k<n;++k) {TimeStatus s=timing_measure(clock,work,&samples[k]);if (s!=T_OK) return s;}
    for (size_t k=0;k<n;++k) out[k]=samples[k];
    return T_OK;
}
TimeStatus timing_summary(const TimeSample *samples,size_t n,TimeSummary *out)
{
    if (!samples || !out || !n || n>TIME_MAX_SAMPLES) return T_ARGUMENT;
    uint64_t sorted[TIME_MAX_SAMPLES];TimeSummary summary={0};
    for (size_t k=0;k<n;++k) {
        sorted[k]=samples[k].elapsed;
        summary.zeros+=samples[k].elapsed==0;summary.aux_changes+=samples[k].aux_changed!=0;
        size_t pos=k;
        while (pos && sorted[pos]<sorted[pos-1]) {
            uint64_t temp=sorted[pos];sorted[pos]=sorted[pos-1];sorted[pos-1]=temp;--pos;
        }
    }
    summary.minimum=sorted[0];summary.median=sorted[(n-1)/2];summary.maximum=sorted[n-1];
    *out=summary;return T_OK;
}
''')
put(13,'instructor/src/rate.c',r'''
#include "timing.h"
TimeStatus timing_rate(uint64_t ticks,uint64_t ns,double *hz)
{
    if (!hz || !ticks || !ns) return T_ARGUMENT;
    *hz=(double)ticks*1e9/(double)ns;return T_OK;
}
''')
put(13,'support/counter.c',r'''
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
''')
stubs={
'clock.c':'TimeStatus timing_ns(const struct timespec *t,uint64_t *o){(void)t;(void)o;return T_ARGUMENT;}\nTimeStatus timing_elapsed(uint64_t b,uint64_t e,uint64_t *o){(void)b;(void)e;(void)o;return T_ARGUMENT;}\nTimeStatus timing_monotonic(void *c,ClockStamp *o){(void)c;(void)o;return T_ARGUMENT;}',
'sample.c':'TimeStatus timing_measure(const ClockSource *c,const Work *w,TimeSample *o){(void)c;(void)w;(void)o;return T_ARGUMENT;}',
'summary.c':'TimeStatus timing_collect(const ClockSource *c,const Work *w,size_t n,TimeSample *o){(void)c;(void)w;(void)n;(void)o;return T_ARGUMENT;}\nTimeStatus timing_summary(const TimeSample *s,size_t n,TimeSummary *o){(void)s;(void)n;(void)o;return T_ARGUMENT;}',
'rate.c':'TimeStatus timing_rate(uint64_t t,uint64_t n,double *o){(void)t;(void)n;(void)o;return T_ARGUMENT;}'}
for name,code in stubs.items():put(13,'learner/src/'+name,'#include "timing.h"\n/* TODO: implement the public contract. */\n'+code)
warm13=[('int w01(uint64_t sec,unsigned ns,uint64_t *out)','if (!out || ns>=1000000000u || sec>(UINT64_MAX-ns)/UINT64_C(1000000000)) return 0; *out=sec*UINT64_C(1000000000)+ns; return 1;','(void)sec;(void)ns;(void)out;'),('int w02(uint64_t b,uint64_t e,uint64_t *out)','if (!out || e<b) return 0; *out=e-b;return 1;','(void)b;(void)e;(void)out;'),('int w03(uint64_t t,uint64_t b,uint64_t *out)','if (!out || !b) return 0; *out=t/b+(t%b!=0);return 1;','(void)t;(void)b;(void)out;')]
for k,(sig,body,unused) in enumerate(warm13,1):
    put(13,f'instructor/src/w{k:02}.c','#include "timing.h"\n'+sig+'\n{ '+body+' }')
    put(13,f'learner/src/w{k:02}.c','#include "timing.h"\n/* TODO */\n'+sig+'\n{ '+unused+'return 0; }')
put(14,'include/profile.h',r'''
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
''')
put(14,'instructor/src/totals.c',r'''
#include "profile.h"
ProfileStatus profile_accumulate(Bucket *bucket,uint64_t inclusive,uint64_t exclusive)
{
    if (!bucket || exclusive>inclusive) return P_ARGUMENT;
    if (bucket->inclusive>UINT64_MAX-inclusive || bucket->exclusive>UINT64_MAX-exclusive || bucket->hits==UINT64_MAX) return P_OVERFLOW;
    Bucket next=*bucket;next.inclusive+=inclusive;next.exclusive+=exclusive;++next.hits;*bucket=next;return P_OK;
}
''')
put(14,'instructor/src/events.c',r'''
#include "profile.h"
ProfileStatus profile_begin(Profile *p,unsigned id,uint64_t now)
{
    if (!p || id>=PROFILE_IDS) return P_ARGUMENT;
    if (p->depth==PROFILE_DEPTH) return P_CAPACITY;
    if (p->has_time && now<p->last) return P_ORDER;
    Profile next=*p;Frame frame={id,now,0};next.stack[next.depth++]=frame;
    next.last=now;next.has_time=1;*p=next;return P_OK;
}
ProfileStatus profile_end(Profile *p,unsigned id,uint64_t now)
{
    if (!p || id>=PROFILE_IDS) return P_ARGUMENT;
    if (!p->depth || p->stack[p->depth-1].id!=id) return P_NEST;
    if (now<p->last) return P_ORDER;
    Profile next=*p;Frame frame=next.stack[next.depth-1];uint64_t elapsed=now-frame.begin;
    if (frame.children>elapsed) return P_ORDER;
    ProfileStatus s=profile_accumulate(&next.totals[id],elapsed,elapsed-frame.children);
    if (s!=P_OK) return s;
    --next.depth;
    if (next.depth) {
        Frame *parent=&next.stack[next.depth-1];
        if (parent->children>UINT64_MAX-elapsed) return P_OVERFLOW;
        parent->children+=elapsed;
    }
    Frame cleared={0};next.stack[next.depth]=cleared;next.last=now;next.has_time=1;
    *p=next;return P_OK;
}
''')
put(14,'instructor/src/report.c',r'''
#include "profile.h"
ProfileStatus profile_report(const Profile *p,ProfileReport *out)
{
    if (!p || !out) return P_ARGUMENT;
    if (p->depth) return P_ACTIVE;
    ProfileReport report={0};
    for (unsigned k=0;k<PROFILE_IDS;++k) {
        Bucket b=p->totals[k];
        if (report.covered>UINT64_MAX-b.exclusive || report.inclusive_sum>UINT64_MAX-b.inclusive || report.hits>UINT64_MAX-b.hits) return P_OVERFLOW;
        report.totals[k]=b;report.covered+=b.exclusive;report.inclusive_sum+=b.inclusive;
        report.hits+=b.hits;report.used+=b.hits!=0;
    }
    *out=report;return P_OK;
}
''')
put(14,'instructor/src/overhead.c',r'''
#include "profile.h"
ProfileStatus profile_difference(uint64_t base,uint64_t measured,double *fraction)
{
    if (!fraction || !base) return P_ARGUMENT;
    *fraction=((double)measured-(double)base)/(double)base;return P_OK;
}
''')
stubs14={'events.c':'ProfileStatus profile_begin(Profile *p,unsigned i,uint64_t t){(void)p;(void)i;(void)t;return P_ARGUMENT;}\nProfileStatus profile_end(Profile *p,unsigned i,uint64_t t){(void)p;(void)i;(void)t;return P_ARGUMENT;}',
'totals.c':'ProfileStatus profile_accumulate(Bucket *b,uint64_t i,uint64_t e){(void)b;(void)i;(void)e;return P_ARGUMENT;}',
'report.c':'ProfileStatus profile_report(const Profile *p,ProfileReport *o){(void)p;(void)o;return P_ARGUMENT;}',
'overhead.c':'ProfileStatus profile_difference(uint64_t b,uint64_t i,double *o){(void)b;(void)i;(void)o;return P_ARGUMENT;}'}
for name,code in stubs14.items():put(14,'learner/src/'+name,'#include "profile.h"\n/* TODO: implement the public contract. */\n'+code)
warm14=[('int w01(uint64_t inclusive,uint64_t child,uint64_t *out)','if (!out || child>inclusive) return 0;*out=inclusive-child;return 1;','(void)inclusive;(void)child;(void)out;'),('int w02(uint64_t old,uint64_t *out)','if (!out || old==UINT64_MAX) return 0;*out=old+1;return 1;','(void)old;(void)out;'),('int w03(uint64_t part,uint64_t whole,double *out)','if (!out || !whole) return 0;*out=(double)part/(double)whole;return 1;','(void)part;(void)whole;(void)out;')]
for k,(sig,body,unused) in enumerate(warm14,1):
    put(14,f'instructor/src/w{k:02}.c','#include "profile.h"\n'+sig+'\n{ '+body+' }')
    put(14,f'learner/src/w{k:02}.c','#include "profile.h"\n/* TODO */\n'+sig+'\n{ '+unused+'return 0; }')
for n in [13,14]:
    put(n,'support/kernel.h',r'''
#ifndef TIMING_KERNEL_H
#define TIMING_KERNEL_H
#include "geolab_types.h"
uint64_t work_fold(const GeoPoint *points,size_t n);
#endif
''')
    put(n,'support/kernel.c',r'''
#include "kernel.h"
/* Separate translation unit and no LTO: calls remain observable to the
   supplied driver, which checks/prints results outside the timed region. */
uint64_t work_fold(const GeoPoint *points,size_t n)
{
    uint64_t sum=0;for (size_t k=0;k<n;++k) sum+=points[k].id;return sum;
}
''')
    put(n,'support/geolab_types.h',(root/'week-05/support/geolab_types.h').read_text(encoding='utf-8'))
    for name in ['inventory.py','starters.py']:put(n,'tests/'+name,(root/'week-12/tests'/name).read_text(encoding='utf-8'))
    put(n,'tests/snippets.py',(root/'week-12/tests/snippets.py').read_text(encoding='utf-8').replace('week-12',f'week-{n:02}').replace('evidence', 'interval' if n==13 else 'nested'))
put(14,'support/timing.h',(root/'week-13/include/timing.h').read_text(encoding='utf-8'))
put(14,'support/clock.c',(root/'week-13/instructor/src/clock.c').read_text(encoding='utf-8'))
base=(root/'week-11/Makefile').read_text(encoding='utf-8')
start=base.index('LAB =');end=base.index('.PHONY:',start)
for n in [13,14]:
    modules='clock.c sample.c summary.c rate.c' if n==13 else 'events.c totals.c report.c overhead.c'
    support='support/counter.c support/kernel.c' if n==13 else 'support/clock.c support/kernel.c'
    header='timing.h' if n==13 else 'profile.h'
    make=base[:start]+f'LAB = $(addprefix $(SRC)/,{modules})\nSUPPORT = {support}\nHEADERS = include/{header} $(wildcard support/*.h)\nINC = -Iinclude -Isupport\n'+base[end:]
    make=make.replace('STRICT = -std=c11','STRICT = -D_POSIX_C_SOURCE=200809L -std=c11')
    first=make.index('$(BUILD)/probe.o:');last=make.index('starters:',first);make=make[:first]+make[last:]
    make=make.replace(' test inspect probe',' test inspect').replace(' test probe',' test')
    make=make.replace('all: $(BUILD)/playground $(BUILD)/warmups','all: $(BUILD)/playground $(BUILD)/bench $(BUILD)/warmups')
    first=make.index('$(BUILD)/contracts:')
    make=make[:first]+'''$(BUILD)/bench: support/bench.c $(LAB) $(SUPPORT) $(HEADERS) | $(BUILD)
\t$(CC) $(FLAGS) $(LINK) $(INC) $< $(LAB) $(SUPPORT) -lm -o $@
'''+make[first:]
    if n==13:
        make=make.replace('\t$(MAKE) starters','\t$(MAKE) PACKAGE=instructor CC=gcc MODE=debug no-counter\n\t$(MAKE) PACKAGE=instructor CC=clang MODE=debug no-counter\n\t$(MAKE) starters')
        make+='''\n.PHONY: no-counter
no-counter: $(BUILD)/no-counter
\t$(BUILD)/no-counter
$(BUILD)/no-counter: tests/contracts.c $(LAB) $(SUPPORT) $(HEADERS) | $(BUILD)
\t$(CC) $(FLAGS) $(LINK) -DTIMING_NO_TSC $(INC) $< $(LAB) $(SUPPORT) -lm -o $@
'''
    put(n,'Makefile',make)
    inspect=(root/'week-11/tools/inspect.py').read_text(encoding='utf-8')
    first=inspect.index('sources=');last=inspect.index('records=[]',first)
    inspect=inspect[:first]+f"sources=[f'{{package}}/src/{{name}}.c' for name in {modules.split()}]+['support/kernel.c']\n".replace(".c.c'",".c'")+inspect[last:]
    # module values already carry .c suffix; use exact filenames.
    inspect=inspect.replace("/src/{name}.c'","/src/{name}'").replace("'-Isupport/geolab'","'-Isupport'").replace("flags=['-std=c11'","flags=['-D_POSIX_C_SOURCE=200809L','-std=c11'")
    if n==13:inspect=inspect.replace("+['support/kernel.c']","+['support/kernel.c','support/counter.c']")
    put(n,'tools/inspect.py',inspect)
print('created timing/profiling libraries, learner scaffolds and build tooling')

#include "timing.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
typedef struct { unsigned reads,calls,fail_read,fail_work;uint64_t now; } State;
static TimeStatus fake(void *ctx,ClockStamp *out) {State *s=ctx;++s->reads;if(s->reads==s->fail_read)return T_CLOCK;*out=(ClockStamp){s->now++,s->reads%2};return T_OK;}
static int work(void *ctx,uint64_t *out) {State *s=ctx;++s->calls;*out=17;return s->calls!=s->fail_work;}
static TimeStatus reversed(void *ctx,ClockStamp *out) {
    unsigned *reads=ctx;*out=(ClockStamp){*reads==0?10:9,0};++*reads;return T_OK;
}
int main(void) {
    uint64_t value=77;struct timespec t={1,2};assert(timing_ns(&t,&value)==T_OK && value==1000000002);
    t.tv_nsec=-1;assert(timing_ns(&t,&value)==T_ARGUMENT && value==1000000002);
    t.tv_nsec=1000000000;assert(timing_ns(&t,&value)==T_ARGUMENT);t.tv_nsec=0;t.tv_sec=-1;assert(timing_ns(&t,&value)==T_ARGUMENT);
    t.tv_sec=(time_t)18446744074ULL;assert(timing_ns(&t,&value)==T_OVERFLOW);
    t.tv_sec=(time_t)18446744073ULL;t.tv_nsec=709551615;assert(timing_ns(&t,&value)==T_OK && value==UINT64_MAX);
    ++t.tv_nsec;assert(timing_ns(&t,&value)==T_OVERFLOW && value==UINT64_MAX);
    assert(timing_elapsed(9,8,&value)==T_ORDER && value==UINT64_MAX);assert(timing_elapsed(9,9,&value)==T_OK && value==0);
    assert(timing_ns(NULL,&value)==T_ARGUMENT && timing_elapsed(0,1,NULL)==T_ARGUMENT);
    State s={0};ClockSource c={fake,&s};Work w={work,&s};TimeSample sample={0};
    assert(timing_measure(&c,&w,&sample)==T_OK && sample.elapsed==1 && sample.checksum==17 && sample.aux_changed);
    TimeSample saved=sample;s.fail_read=s.reads+1;assert(timing_measure(&c,&w,&sample)==T_CLOCK && memcmp(&saved,&sample,sizeof sample)==0 && s.calls==1);
    s.fail_read=0;s.fail_work=s.calls+1;assert(timing_measure(&c,&w,&sample)==T_WORK && s.reads==4);
    s=(State){0};s.fail_read=2;assert(timing_measure(&c,&w,&sample)==T_CLOCK && s.calls==1 && memcmp(&saved,&sample,sizeof sample)==0);
    unsigned reversed_reads=0;ClockSource reverse={reversed,&reversed_reads};s=(State){0};
    assert(timing_measure(&reverse,&w,&sample)==T_ORDER && s.calls==1 && reversed_reads==2 && memcmp(&saved,&sample,sizeof sample)==0);
    assert(timing_measure(NULL,&w,&sample)==T_ARGUMENT && timing_measure(&c,NULL,&sample)==T_ARGUMENT);
    ClockSource invalid={NULL,NULL};assert(timing_measure(&invalid,&w,&sample)==T_ARGUMENT);
    s=(State){0};TimeSample array[4];memset(array,0x5a,sizeof array);TimeSample original[4];memcpy(original,array,sizeof array);
    s.fail_read=6;assert(timing_collect(&c,&w,4,array)==T_CLOCK && memcmp(array,original,sizeof array)==0 && s.calls==3);
    assert(timing_collect(&c,&w,0,array)==T_ARGUMENT && timing_collect(&c,&w,65,array)==T_ARGUMENT);
    TimeSample raw[4]={{UINT64_MAX,0,0,0,0},{0,0,0,0,0},{9,0,0,0,1},{2,0,0,0,0}};TimeSummary summary;
    assert(timing_summary(raw,4,&summary)==T_OK && summary.minimum==0 && summary.median==2 && summary.maximum==UINT64_MAX && summary.zeros==1 && summary.aux_changes==1 && raw[0].elapsed==UINT64_MAX);
    TimeSummary prior=summary;assert(timing_summary(raw,0,&summary)==T_ARGUMENT && memcmp(&prior,&summary,sizeof summary)==0);
    assert(timing_summary(NULL,1,&summary)==T_ARGUMENT && timing_summary(raw,65,&summary)==T_ARGUMENT);
    double rate=99;assert(timing_rate(0,1,&rate)==T_ARGUMENT && rate==99);assert(timing_rate(UINT64_MAX,UINT64_MAX,&rate)==T_OK && fabs(rate-1e9)<1);
    ClockStamp a,b;assert(timing_monotonic(NULL,&a)==T_OK && timing_monotonic(NULL,&b)==T_OK && b.value>=a.value);
    CounterInfo info;assert(timing_counter_info(&info)==T_OK);
    if(info.available)assert(timing_counter_read(&info,&a)==T_OK);else assert(timing_counter_read(&info,&a)==T_UNSUPPORTED);
    assert(timing_monotonic(NULL,NULL)==T_ARGUMENT && timing_counter_info(NULL)==T_ARGUMENT);
    for(uint64_t sec=0;sec<10000;++sec) {t.tv_sec=(time_t)sec;t.tv_nsec=(long)(sec%1000);assert(timing_ns(&t,&value)==T_OK && value==sec*1000000000+sec%1000);}
    puts("PASS timing contracts, callback effects, boundaries and 10000 conversions");return 0;
}

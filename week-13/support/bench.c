#include "timing.h"
#include "kernel.h"
#include <inttypes.h>
#include <stdio.h>
static GeoPoint points[512];
static int work(void *ctx,uint64_t *out) {
    (void)ctx;uint64_t sum=0;for(unsigned i=0;i<32;++i)sum+=work_fold(points,512);*out=sum;return sum==4202496;
}
static int empty(void *ctx,uint64_t *out) {(void)ctx;*out=0;return 1;}
static int emit(const char *label,ClockSource clock,Work task) {
    TimeSample s[9];TimeSummary summary;
    if(timing_collect(&clock,&task,9,s)!=T_OK || timing_summary(s,9,&summary)!=T_OK)return 0;
    for(size_t i=0;i<9;++i)printf("sample,%s,%zu,%" PRIu64 ",%" PRIu64 ",%d\n",label,i,s[i].elapsed,s[i].checksum,s[i].aux_changed);
    printf("summary,%s,%" PRIu64 ",%" PRIu64 ",%" PRIu64 ",%zu,%zu\n",label,summary.minimum,summary.median,summary.maximum,summary.zeros,summary.aux_changes);return 1;
}
int main(void) {
    for(size_t i=0;i<512;++i)points[i].id=(uint32_t)(i+1);
    Work task={work,NULL},nothing={empty,NULL};ClockSource ns={timing_monotonic,NULL};uint64_t checksum;
    struct timespec resolution;
    if(!work(NULL,&checksum) || clock_getres(CLOCK_MONOTONIC,&resolution)!=0)return 1;
    printf("resolution,ns,%ld,%ld\n",(long)resolution.tv_sec,resolution.tv_nsec);
    if(!emit("ns",ns,task) || !emit("empty-ns",ns,nothing))return 1;
    CounterInfo info;if(timing_counter_info(&info)!=T_OK)return 1;
    printf("counter,%d,%d\n",info.available,info.invariant);
    if(info.available) {
        ClockSource ticks={timing_counter_read,&info};ClockStamp a,b,c,d;uint64_t nt,ct;double hz;
        if(!emit("ticks",ticks,task) || !emit("empty-ticks",ticks,nothing))return 1;
        if(timing_monotonic(NULL,&a)!=T_OK || timing_counter_read(&info,&b)!=T_OK || !work(NULL,&checksum) ||
           timing_counter_read(&info,&c)!=T_OK || timing_monotonic(NULL,&d)!=T_OK)return 1;
        if(timing_elapsed(a.value,d.value,&nt)==T_OK && timing_elapsed(b.value,c.value,&ct)==T_OK &&
           b.aux==c.aux && timing_rate(ct,nt,&hz)==T_OK)
            printf("calibration,%" PRIu64 ",%" PRIu64 ",%.3f\n",nt,ct,hz);
        else puts("calibration,unavailable");
    }
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}

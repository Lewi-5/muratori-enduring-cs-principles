#include "timing.h"
#include <inttypes.h>
#include <stdio.h>
typedef struct { size_t pos; } Fake;
static TimeStatus read_fake(void *ctx,ClockStamp *out) {
    static const uint64_t values[]={100,110,200,240,300,330,400,420};
    Fake *f=ctx;if(f->pos>=8)return T_CLOCK;*out=(ClockStamp){values[f->pos++],0};return T_OK;
}
static int work(void *ctx,uint64_t *out) { unsigned *calls=ctx; ++*calls;*out=42;return 1; }
int main(void) {
    Fake f={0};unsigned calls=0;ClockSource clock={read_fake,&f};Work task={work,&calls};
    TimeSample samples[4];TimeSummary s;
    if(timing_collect(&clock,&task,4,samples)!=T_OK || timing_summary(samples,4,&s)!=T_OK)return 1;
    printf("samples=4 min=%" PRIu64 " median=%" PRIu64 " max=%" PRIu64 " zeros=%zu\n",s.minimum,s.median,s.maximum,s.zeros);
    printf("calls=%u checksum=%" PRIu64 "\n",calls,samples[3].checksum);
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}

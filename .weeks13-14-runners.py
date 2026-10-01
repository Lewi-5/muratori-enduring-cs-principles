exec(open('.weeks13-14-core.py',encoding='utf-8').read().split("put(13,'include/timing.h'")[0])
put(13,'support/playground.c',r'''
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
    return ferror(stdout)?1:0;
}
''')
put(13,'fixtures/playground.txt','samples=4 min=10 median=20 max=40 zeros=0\ncalls=4 checksum=42')
put(13,'support/bench.c',r'''
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
        if(!emit("ticks",ticks,task))return 1;
        if(timing_monotonic(NULL,&a)!=T_OK || timing_counter_read(&info,&b)!=T_OK || !work(NULL,&checksum) ||
           timing_counter_read(&info,&c)!=T_OK || timing_monotonic(NULL,&d)!=T_OK)return 1;
        if(timing_elapsed(a.value,d.value,&nt)==T_OK && timing_elapsed(b.value,c.value,&ct)==T_OK &&
           b.aux==c.aux && timing_rate(ct,nt,&hz)==T_OK)
            printf("calibration,%" PRIu64 ",%" PRIu64 ",%.3f\n",nt,ct,hz);
        else puts("calibration,unavailable");
    }
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}
''')
put(14,'support/playground.c',r'''
#include "profile.h"
#include <inttypes.h>
#include <stdio.h>
int main(void) {
    Profile p={0};ProfileReport r;
    if(profile_begin(&p,0,0)!=P_OK || profile_begin(&p,1,10)!=P_OK || profile_begin(&p,1,20)!=P_OK ||
       profile_end(&p,1,30)!=P_OK || profile_end(&p,1,40)!=P_OK || profile_end(&p,0,100)!=P_OK || profile_report(&p,&r)!=P_OK)return 1;
    for(unsigned i=0;i<PROFILE_IDS;++i)if(r.totals[i].hits)
        printf("id=%u inclusive=%" PRIu64 " exclusive=%" PRIu64 " hits=%" PRIu64 "\n",i,r.totals[i].inclusive,r.totals[i].exclusive,r.totals[i].hits);
    printf("covered=%" PRIu64 " inclusive_sum=%" PRIu64 " hits=%" PRIu64 " used=%u\n",r.covered,r.inclusive_sum,r.hits,r.used);
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}
''')
put(14,'fixtures/playground.txt','id=0 inclusive=100 exclusive=70 hits=1\nid=1 inclusive=40 exclusive=30 hits=2\ncovered=100 inclusive_sum=140 hits=3 used=2')
put(14,'support/bench.c',r'''
#include "profile.h"
#include "timing.h"
#include "kernel.h"
#include <inttypes.h>
#include <stdio.h>
static GeoPoint points[512];
static int stamp(uint64_t *out) { ClockStamp s;if(timing_monotonic(NULL,&s)!=T_OK)return 0;*out=s.value;return 1; }
static int run(int enabled,uint64_t *elapsed,uint64_t *checksum,ProfileReport *report) {
    Profile p={0};uint64_t a,b,t,sum=0;
    if(!stamp(&a))return 0;
    if(enabled && (!stamp(&t) || profile_begin(&p,0,t)!=P_OK))return 0;
    for(unsigned i=0;i<32;++i) {
        if(enabled && (!stamp(&t) || profile_begin(&p,1,t)!=P_OK))return 0;
        sum+=work_fold(points,512);
        if(enabled && (!stamp(&t) || profile_end(&p,1,t)!=P_OK))return 0;
    }
    if(enabled && (!stamp(&t) || profile_end(&p,0,t)!=P_OK))return 0;
    if(!stamp(&b) || timing_elapsed(a,b,elapsed)!=T_OK || sum!=4202496)return 0;
    *checksum=sum;return !enabled || profile_report(&p,report)==P_OK;
}
int main(void) {
    for(size_t i=0;i<512;++i)points[i].id=(uint32_t)(i+1);
    uint64_t base,measured,sum;ProfileReport report;double change;
    if(!run(0,&base,&sum,&report))return 1;
    for(unsigned i=0;i<9;++i) {
        if(i%2==0) {if(!run(0,&base,&sum,&report) || !run(1,&measured,&sum,&report))return 1;}
        else {if(!run(1,&measured,&sum,&report) || !run(0,&base,&sum,&report))return 1;}
        printf("pair,%u,%" PRIu64 ",%" PRIu64 ",",i,base,measured);
        if(profile_difference(base,measured,&change)==P_OK)printf("%.6f",change);else printf("NA");
        printf(",%" PRIu64 ",%" PRIu64 ",%" PRIu64 "\n",sum,report.covered,report.hits);
    }
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}
''')
put(13,'tests/contracts.c',r'''
#include "timing.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
typedef struct { unsigned reads,calls,fail_read,fail_work;uint64_t now; } State;
static TimeStatus fake(void *ctx,ClockStamp *out) {State *s=ctx;++s->reads;if(s->reads==s->fail_read)return T_CLOCK;*out=(ClockStamp){s->now++,s->reads%2};return T_OK;}
static int work(void *ctx,uint64_t *out) {State *s=ctx;++s->calls;*out=17;return s->calls!=s->fail_work;}
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
    s=(State){0};TimeSample array[4];memset(array,0x5a,sizeof array);TimeSample original[4];memcpy(original,array,sizeof array);
    s.fail_read=6;assert(timing_collect(&c,&w,4,array)==T_CLOCK && memcmp(array,original,sizeof array)==0 && s.calls==3);
    assert(timing_collect(&c,&w,0,array)==T_ARGUMENT && timing_collect(&c,&w,65,array)==T_ARGUMENT);
    TimeSample raw[4]={{UINT64_MAX,0,0,0,0},{0,0,0,0,0},{9,0,0,0,1},{2,0,0,0,0}};TimeSummary summary;
    assert(timing_summary(raw,4,&summary)==T_OK && summary.minimum==0 && summary.median==2 && summary.maximum==UINT64_MAX && summary.zeros==1 && summary.aux_changes==1 && raw[0].elapsed==UINT64_MAX);
    double rate=99;assert(timing_rate(0,1,&rate)==T_ARGUMENT && rate==99);assert(timing_rate(UINT64_MAX,UINT64_MAX,&rate)==T_OK && fabs(rate-1e9)<1);
    ClockStamp a,b;assert(timing_monotonic(NULL,&a)==T_OK && timing_monotonic(NULL,&b)==T_OK && b.value>=a.value);
    CounterInfo info;assert(timing_counter_info(&info)==T_OK);
    if(info.available)assert(timing_counter_read(&info,&a)==T_OK);else assert(timing_counter_read(&info,&a)==T_UNSUPPORTED);
    for(uint64_t sec=0;sec<10000;++sec) {t.tv_sec=(time_t)sec;t.tv_nsec=(long)(sec%1000);assert(timing_ns(&t,&value)==T_OK && value==sec*1000000000+sec%1000);}
    puts("PASS timing contracts, callback effects, boundaries and 10000 conversions");return 0;
}
''')
put(14,'tests/contracts.c',r'''
#include "profile.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
int main(void) {
    Profile p={0},saved;ProfileReport report={0},original=report;
    assert(profile_end(&p,0,0)==P_NEST);assert(profile_begin(&p,16,0)==P_ARGUMENT);
    assert(profile_begin(&p,0,0)==P_OK);saved=p;
    assert(profile_end(&p,1,1)==P_NEST && memcmp(&saved,&p,sizeof p)==0);
    assert(profile_report(&p,&report)==P_ACTIVE && memcmp(&original,&report,sizeof report)==0);
    assert(profile_begin(&p,1,10)==P_OK && profile_begin(&p,1,20)==P_OK);
    assert(profile_end(&p,1,30)==P_OK && profile_end(&p,1,40)==P_OK && profile_end(&p,0,100)==P_OK);
    assert(profile_report(&p,&report)==P_OK && report.covered==100 && report.inclusive_sum==140 && report.hits==3);
    assert(report.totals[0].exclusive==70 && report.totals[1].exclusive==30 && report.totals[1].inclusive==40);
    saved=p;assert(profile_begin(&p,0,99)==P_ORDER && memcmp(&saved,&p,sizeof p)==0);
    p=(Profile){0};for(unsigned i=0;i<32;++i)assert(profile_begin(&p,i%16,i)==P_OK);
    saved=p;assert(profile_begin(&p,0,32)==P_CAPACITY && memcmp(&saved,&p,sizeof p)==0);
    for(unsigned i=32;i>0;--i)assert(profile_end(&p,(i-1)%16,64-i)==P_OK);
    Bucket bucket={UINT64_MAX,0,0},before=bucket;assert(profile_accumulate(&bucket,1,0)==P_OVERFLOW && memcmp(&bucket,&before,sizeof bucket)==0);
    bucket=(Bucket){0,0,UINT64_MAX};before=bucket;assert(profile_accumulate(&bucket,0,0)==P_OVERFLOW && memcmp(&bucket,&before,sizeof bucket)==0);
    assert(profile_accumulate(&bucket,0,1)==P_ARGUMENT);
    p=(Profile){0};assert(profile_begin(&p,0,0)==P_OK && profile_begin(&p,1,0)==P_OK && profile_end(&p,1,UINT64_MAX)==P_OK && profile_end(&p,0,UINT64_MAX)==P_OK);
    original=report;assert(profile_report(&p,&report)==P_OVERFLOW && memcmp(&original,&report,sizeof report)==0);
    double difference=7;assert(profile_difference(0,1,&difference)==P_ARGUMENT && difference==7);assert(profile_difference(100,50,&difference)==P_OK && fabs(difference+0.5)<1e-12);
    for(uint64_t a=0;a<100;++a)for(uint64_t b=0;b<100;++b) {
        p=(Profile){0};uint64_t end=a+b+9;
        assert(profile_begin(&p,0,0)==P_OK && profile_begin(&p,1,3)==P_OK && profile_begin(&p,1,3+a)==P_OK);
        assert(profile_end(&p,1,3+a+b)==P_OK && profile_end(&p,1,6+a+b)==P_OK && profile_end(&p,0,end)==P_OK);
        assert(profile_report(&p,&report)==P_OK && report.covered==end && report.totals[0].exclusive==6 && report.totals[1].inclusive==a+2*b+3 && report.totals[1].exclusive==a+b+3);
    }
    puts("PASS profiling contracts, recursion, overflow and 10000 interval trees");return 0;
}
''')
for n in [13,14]:
    body=(r'''uint64_t v=99;assert(w01(1,2,&v) && v==1000000002);assert(!w01(UINT64_MAX,0,&v));assert(w02(9,9,&v) && v==0);assert(!w02(9,8,&v));assert(w03(UINT64_MAX,2,&v) && v==UINT64_MAX/2+1);for(uint64_t a=0;a<256;++a)for(uint64_t b=1;b<256;++b)assert(w03(a,b,&v) && v==a/b+(a%b!=0));''' if n==13 else r'''uint64_t v=99;double ratio;assert(!w01(1,2,&v) && v==99);assert(!w02(UINT64_MAX,&v));assert(w03(200,100,&ratio) && ratio==2);assert(!w03(1,0,&ratio));for(uint64_t a=0;a<256;++a)for(uint64_t b=0;b<=a;++b)assert(w01(a,b,&v) && v==a-b);''')
    put(n,'tests/warmups.c','#include "'+('timing.h' if n==13 else 'profile.h')+'"\n#include <assert.h>\n#include <stdio.h>\nint main(void) { '+body+' puts("PASS warm-up boundaries and bounded exhaustive cases");return 0; }')
    put(n,'tests/check.py',r'''
from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parents[1];build=Path(sys.argv[1]).resolve()
r=subprocess.run([str(build/'playground')],capture_output=True,text=True)
assert r.returncode==0 and r.stdout==(root/'fixtures/playground.txt').read_text(),r
r=subprocess.run([str(build/'bench')],capture_output=True,text=True);assert r.returncode==0 and not r.stderr,r
lines=r.stdout.splitlines()
if root.name=='week-13':
    samples=[s.split(',') for s in lines if s.startswith('sample,')]
    assert len(samples) in (18,27)
    for s in samples: assert int(s[3])>=0 and int(s[4])==(0 if s[1]=='empty-ns' else 4202496) and s[5] in ('0','1')
else:
    assert len(lines)==9
    for line in lines:
        s=line.split(',');assert s[0]=='pair' and int(s[2])>=0 and int(s[3])>=0 and int(s[5])==4202496 and int(s[7])==33
with open('/dev/full','w') as full:
    r=subprocess.run([str(build/'bench')],stdout=full,stderr=subprocess.PIPE);assert r.returncode!=0
print('PASS exact playground, real measurement structure/checksums and output failure')
''')

#include "profile.h"
#include "timing.h"
#include "kernel.h"
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
static GeoPoint points[512];
static int stamp(uint64_t *out) { ClockStamp s;if(timing_monotonic(NULL,&s)!=T_OK)return 0;*out=s.value;return 1; }
static int run(int enabled,uint64_t *elapsed,uint64_t *checksum,ProfileReport *report) {
    Profile p={0};uint64_t a,b,t,sum=0;
    if(!stamp(&a))return 0;
    if(enabled && (!stamp(&t) || profile_begin(&p,0,t)!=P_OK))return 0;
    for(unsigned i=0;i<32;++i) {
        if(enabled==1 && (!stamp(&t) || profile_begin(&p,1,t)!=P_OK))return 0;
        sum+=work_fold(points,512);
        if(enabled==1 && (!stamp(&t) || profile_end(&p,1,t)!=P_OK))return 0;
    }
    if(enabled && (!stamp(&t) || profile_end(&p,0,t)!=P_OK))return 0;
    if(!stamp(&b) || timing_elapsed(a,b,elapsed)!=T_OK || sum!=4202496)return 0;
    *checksum=sum;return !enabled || profile_report(&p,report)==P_OK;
}
int main(int argc,char **argv) {
    int enabled=1;
    if(argc==2 && strcmp(argv[1],"outer")==0)enabled=2;
    else if(argc!=1)return 1;
    for(size_t i=0;i<512;++i)points[i].id=(uint32_t)(i+1);
    uint64_t base,measured,sum;ProfileReport report;double change;
    if(!run(0,&base,&sum,&report))return 1;
    for(unsigned i=0;i<9;++i) {
        if(i%2==0) {if(!run(0,&base,&sum,&report) || !run(enabled,&measured,&sum,&report))return 1;}
        else {if(!run(enabled,&measured,&sum,&report) || !run(0,&base,&sum,&report))return 1;}
        printf("pair,%u,%" PRIu64 ",%" PRIu64 ",",i,base,measured);
        if(profile_difference(base,measured,&change)==P_OK)printf("%.6f",change);else printf("NA");
        printf(",%" PRIu64 ",%" PRIu64 ",%" PRIu64 "\n",sum,report.covered,report.hits);
    }
    return fflush(stdout)!=0 || ferror(stdout)?1:0;
}

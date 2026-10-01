#include "profile.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
int main(void) {
    Profile p={0},saved;ProfileReport report={0},original=report;
    assert(profile_end(&p,0,0)==P_NEST);assert(profile_begin(&p,16,0)==P_ARGUMENT);
    assert(profile_report(&p,&report)==P_OK && report.covered==0 && report.hits==0 && report.used==0);
    assert(profile_begin(&p,0,0)==P_OK);saved=p;
    assert(profile_end(&p,1,1)==P_NEST && memcmp(&saved,&p,sizeof p)==0);
    assert(profile_report(&p,&report)==P_ACTIVE && memcmp(&original,&report,sizeof report)==0);
    assert(profile_begin(&p,1,10)==P_OK && profile_begin(&p,1,20)==P_OK);
    saved=p;assert(profile_end(&p,1,19)==P_ORDER && memcmp(&saved,&p,sizeof p)==0);
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
    bucket=(Bucket){0,UINT64_MAX,0};before=bucket;
    assert(profile_accumulate(&bucket,1,1)==P_OVERFLOW && memcmp(&before,&bucket,sizeof bucket)==0);
    Profile other={0};p=(Profile){0};
    assert(profile_begin(&p,0,10)==P_OK && profile_begin(&other,1,0)==P_OK);
    assert(profile_end(&p,0,10)==P_OK && profile_end(&other,1,20)==P_OK);
    assert(profile_report(&p,&report)==P_OK && report.covered==0 && report.hits==1);
    assert(profile_report(&other,&report)==P_OK && report.covered==20 && report.hits==1);
    assert(profile_begin(NULL,0,0)==P_ARGUMENT && profile_end(NULL,0,0)==P_ARGUMENT);
    assert(profile_report(NULL,&report)==P_ARGUMENT && profile_report(&p,NULL)==P_ARGUMENT);
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

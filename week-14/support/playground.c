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

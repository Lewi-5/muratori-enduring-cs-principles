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

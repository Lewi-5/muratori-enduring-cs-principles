#include "profile.h"
ProfileStatus profile_difference(uint64_t base,uint64_t measured,double *fraction)
{
    if (!fraction || !base) return P_ARGUMENT;
    *fraction=((double)measured-(double)base)/(double)base;return P_OK;
}

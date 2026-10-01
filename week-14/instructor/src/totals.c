#include "profile.h"
ProfileStatus profile_accumulate(Bucket *bucket,uint64_t inclusive,uint64_t exclusive)
{
    if (!bucket || exclusive>inclusive) return P_ARGUMENT;
    if (bucket->inclusive>UINT64_MAX-inclusive || bucket->exclusive>UINT64_MAX-exclusive || bucket->hits==UINT64_MAX) return P_OVERFLOW;
    Bucket next=*bucket;next.inclusive+=inclusive;next.exclusive+=exclusive;++next.hits;*bucket=next;return P_OK;
}

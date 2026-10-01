#include "lab.h"
int fold_ids(const GeoPoint *points, size_t n, uint64_t *out)
{
    if (!out || (!points && n)) return 0;
    uint64_t sum=0;
    for (size_t k=0; k<n; ++k) sum+=points[k].id;
    *out=sum;
    return 1;
}

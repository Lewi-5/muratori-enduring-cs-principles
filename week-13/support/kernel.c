#include "kernel.h"
/* Separate translation unit and no LTO: calls remain observable to the
   supplied driver, which checks/prints results outside the timed region. */
uint64_t work_fold(const GeoPoint *points,size_t n)
{
    uint64_t sum=0;for (size_t k=0;k<n;++k) sum+=points[k].id;return sum;
}

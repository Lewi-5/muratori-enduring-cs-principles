#include "geolab.h"
/* Supplied modern comparison subjects. Unsigned arithmetic is intentional. */
uint64_t checkpoint_local(uint64_t value)
{
    uint64_t doubled=value*UINT64_C(2);
    return doubled+UINT64_C(1);
}
int checkpoint_distance(double lat,double lon,double *out)
{
    return geo_distance_km(0.0,0.0,lat,lon,out);
}

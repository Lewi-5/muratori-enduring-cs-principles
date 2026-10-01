#include "lab.h"
#include <math.h>
int distance_to_origin(double lat, double lon, double *out)
{
    return geo_distance_km(0.0,0.0,lat,lon,out);
}
int compare_hit_values(uint64_t id_a, double da, uint64_t id_b, double db, int *out)
{
    if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
    QueryHit a={id_a,da}, b={id_b,db};
    int order=query_hit_compare(&a,&b);
    *out=order;
    return 1;
}

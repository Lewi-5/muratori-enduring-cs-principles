/* geo.c: week 3's validated haversine (E01.C). TODO: paste your week-3 code; keep helpers static.

   geo_distance_km must be the haversine with the intermediate clamped to [0, 1]:
       a = sin^2(dlat/2) + cos(lat1) cos(lat2) sin^2(dlon/2),  distance = 2 asin(sqrt(a)) * GEO_EARTH_RADIUS_KM
   with degrees converted by multiplying by (GEO_PI / 180.0). */
#include <math.h>
#include <stddef.h>
#include "geo_consts.h"
#include "geolab.h"

int geo_valid_position(double lat_deg, double lon_deg)
{
    (void)lat_deg;
    (void)lon_deg;
    return 0; /* TODO: finite, latitude in [-90, 90], longitude in [-180, 180] */
}

int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    (void)lat1;
    (void)lon1;
    (void)lat2;
    (void)lon2;
    (void)out;
    return 0; /* TODO */
}

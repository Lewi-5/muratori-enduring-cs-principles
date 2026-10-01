/* geo.c: week 3's validated haversine distance. Reference solution. */
#include <math.h>
#include <stddef.h>
#include "geo_consts.h"
#include "geolab.h"

static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }

static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }

int geo_valid_position(double lat_deg, double lon_deg)
{
    return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
           lon_deg <= 180.0;
}

/* a = hav(dlat) + cos(lat1) cos(lat2) hav(dlon), clamped to [0, 1] because rounding can push it one ulp past 1 at
   antipodes (week 3 E05); distance = 2 asin(sqrt(a)) R. Nothing is written for invalid input. */
int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
    double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
    double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
    double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
    *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
    return 1;
}

/* E06: the scalar reference processor. Reference solution. */
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "geolab_types.h"
#include "platform.h"
#include "reference_distance.h"

typedef struct {
    size_t points;
    size_t within;
    double sum_km;
    double min_km;
    double max_km;
} ProcessResult;

/* A position is valid when both coordinates are finite and in range (the week-1 contract). */
static int valid_position(double lat_deg, double lon_deg)
{
    return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
           lon_deg <= 180.0;
}

/* Haversine distance on the model sphere (week 3): a = hav(dlat) + cos lat1 cos lat2 hav(dlon), clamped to
   [0, 1] so a rounding above 1 can never reach a square root as NaN; distance = 2 asin(sqrt(a)) R.
   Rejects (returns 0, *out unchanged) non-finite or out-of-range input. */
int haversine_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    if (out == NULL || !valid_position(lat1, lon1) || !valid_position(lat2, lon2)) return 0;
    double p1 = lat1 * (GEO_PI / 180.0), p2 = lat2 * (GEO_PI / 180.0);
    double dphi = (lat2 - lat1) * (GEO_PI / 180.0), dlam = (lon2 - lon1) * (GEO_PI / 180.0);
    double s1 = sin(dphi / 2.0), s2 = sin(dlam / 2.0);
    double a = s1 * s1 + cos(p1) * cos(p2) * s2 * s2;
    if (a < 0.0) a = 0.0;
    if (a > 1.0) a = 1.0;
    *out = 2.0 * asin(sqrt(a)) * GEO_EARTH_RADIUS_KM;
    return 1;
}

/* Scalar reference processor. Rejects (returns 0, *out unchanged) when: out is NULL; points is NULL with a
   nonzero count; the center is not finite or out of range; radius_km is not finite or outside [0, 100000]; or
   ANY point is not finite or out of range (all points are validated before anything is written).
   Otherwise: points = count; within = number of points with distance <= radius_km (inclusive); sum_km, min_km,
   max_km cover ALL points; the sum is accumulated left to right in a double. An empty dataset succeeds with
   every field zero (min and max are meaningless when points is 0). */
int process_points(const GeoPoint *points, size_t count, double center_lat, double center_lon, double radius_km,
                   ProcessResult *out)
{
    if (out == NULL || (points == NULL && count > 0)) return 0;
    if (!valid_position(center_lat, center_lon)) return 0;
    if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > 100000.0) return 0;
    for (size_t i = 0; i < count; ++i) {
        if (!valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
    }
    ProcessResult r = {0, 0, 0.0, 0.0, 0.0};
    for (size_t i = 0; i < count; ++i) {
        double d = 0.0;
        if (!haversine_km(center_lat, center_lon, points[i].lat_deg, points[i].lon_deg, &d)) return 0; /* cannot happen */
        if (d <= radius_km) ++r.within;
        r.sum_km += d;
        if (i == 0 || d < r.min_km) r.min_km = d;
        if (i == 0 || d > r.max_km) r.max_km = d;
        ++r.points;
    }
    *out = r;
    return 1;
}

int main(void)
{
    static const GeoPoint data[12] = {
        {1, 0.0, -2.0}, {2, 0.0, -1.0}, {3, 0.0, 0.0}, {4, 0.0, 1.0}, {5, 0.0, 2.0}, {6, 0.0, 3.0}, {7, 0.0, 10.0},
        {8, 90.0, 0.0}, {9, -90.0, 0.0}, {10, 0.0, 180.0}, {11, 0.0, -180.0}, {12, 45.0, 45.0}};
    double radius = GEO_EARTH_RADIUS_KM * geo_deg_to_rad(2.5);
    ProcessResult r;
    if (!process_points(data, 12, 0.0, 0.0, radius, &r)) return 1;
    printf("points=%zu within=%zu sum_km=%.6f min_km=%.6f max_km=%.6f\n", r.points, r.within, r.sum_km, r.min_km, r.max_km);
    double worst = 0.0;
    size_t within_ref = 0;
    for (size_t i = 0; i < 12; ++i) {
        double mine = 0.0;
        if (!haversine_km(0.0, 0.0, data[i].lat_deg, data[i].lon_deg, &mine)) return 1;
        double ref = reference_distance_km(0.0, 0.0, data[i].lat_deg, data[i].lon_deg);
        double diff = fabs(mine - ref);
        if (diff > worst) worst = diff;
        if (ref <= radius) ++within_ref;
    }
    printf("reference_max_abs_diff_km=%.3e within_equal=%d\n", worst, within_ref == r.within);
    return 0;
}

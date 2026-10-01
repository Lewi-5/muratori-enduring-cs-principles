/* E06: the scalar reference processor. Learner scaffold: fill in the TODO bodies. */
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

/* ---- your week-3 haversine (paste it, or use the instructor's after a genuine attempt) ---- */
int haversine_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    /* TODO: validate finite and in range (lat in [-90, 90], lon in [-180, 180]); clamp the intermediate quantity to
       [0, 1]; return 1 and *out = distance in km, or 0 leaving *out unchanged. */
    (void)lat1;
    (void)lon1;
    (void)lat2;
    (void)lon2;
    (void)out;
    return 0;
}

/* ---- the exercise. Contract: see learner/exercises.md (E06.C). ---- */
int process_points(const GeoPoint *points, size_t count, double center_lat, double center_lon, double radius_km,
                   ProcessResult *out)
{
    /* TODO: validate everything (including every point) before writing *out; accumulate the sum left to right. */
    (void)points;
    (void)count;
    (void)center_lat;
    (void)center_lon;
    (void)radius_km;
    (void)out;
    return 0;
}

/* ---- supplied driver ---- */
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

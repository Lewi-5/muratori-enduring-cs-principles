/* geomath_demo.c: a caller of the library through its header only. */
#include <stdio.h>
#include "geomath.h"

typedef struct { const char *name; double distance_km, expected_km; } Row;

int main(void)
{
    const double R = GEO_EARTH_RADIUS_KM, pi = GEO_PI;
    const double km_per_deg = R * (pi / 180.0);
    double d_identical, d_poles, d_pole_eq, d_pole_same, d_anti_neg, d_anti_pos, d_one_deg, d_one_m;
    int ok = geo_distance_km(45.0, -73.5, 45.0, -73.5, &d_identical)
        && geo_distance_km(90.0, 0.0, -90.0, 0.0, &d_poles)
        && geo_distance_km(90.0, 0.0, 0.0, 0.0, &d_pole_eq)
        && geo_distance_km(90.0, 0.0, 90.0, 120.0, &d_pole_same)
        && geo_distance_km(10.0, -180.0, 20.0, 10.0, &d_anti_neg)
        && geo_distance_km_vector(10.0, 180.0, 20.0, 10.0, &d_anti_pos)   /* reference formulation for this case */
        && geo_distance_km(0.0, 0.0, 0.0, 1.0, &d_one_deg)
        && geo_distance_km(0.0, 0.0, 0.0, 1e-5, &d_one_m);
    if (!ok) return 1;
    /* pole_all_longitudes: (90,0) and (90,120) name the same point, so their distance is 0.
       antimeridian_equivalence: lon -180 and lon +180 name the same meridian; the reference for
       (10,-180)->(20,10) is the other formulation applied to (10,180)->(20,10). */
    const Row rows[] = {
        {"identical", d_identical, 0.0},
        {"pole_to_pole", d_poles, R * pi},
        {"pole_to_equator", d_pole_eq, R * (pi / 2.0)},
        {"pole_all_longitudes", d_pole_same, 0.0},
        {"antimeridian_equivalence", d_anti_neg, d_anti_pos},
        {"one_degree_equator", d_one_deg, km_per_deg},
        {"one_metre_equator", d_one_m, 1e-5 * km_per_deg},
    };
    int all_ok = 1;
    for (size_t i = 0; i < sizeof rows / sizeof rows[0]; ++i) {
        double err = rows[i].distance_km - rows[i].expected_km;
        if (err < 0.0) err = -err;
        int ok_row = 0;
        if (!approx_equal(rows[i].distance_km, rows[i].expected_km, 1e-12, 1e-9, &ok_row)) return 1;
        printf("case=%s distance_km=%.9f expected_km=%.9f abs_error=%.3e ok=%d\n",
               rows[i].name, rows[i].distance_km, rows[i].expected_km, err, ok_row);
        all_ok = all_ok && ok_row;
    }
    return !all_ok;
}

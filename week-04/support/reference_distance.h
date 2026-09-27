#ifndef WEEK04_REFERENCE_DISTANCE_H
#define WEEK04_REFERENCE_DISTANCE_H
/* Supplied for the E06 driver: a plain unit-vector distance, central angle atan2(|u x v|, u . v), with ordinary
   libm sin/cos. It is deliberately a different method from the haversine you write, and it contains no exercise
   answer. Inputs must already be finite and in range. It is a reference for differential testing, not an
   accuracy claim: it shares the sphere model and the radius constant with the code under test. */
#include <math.h>
#define GEO_PI 3.14159265358979323846
#define GEO_EARTH_RADIUS_KM 6371.0088

static inline double geo_deg_to_rad(double d) { return d * (GEO_PI / 180.0); }

static inline double reference_distance_km(double lat1, double lon1, double lat2, double lon2)
{
    double p1 = geo_deg_to_rad(lat1), l1 = geo_deg_to_rad(lon1);
    double p2 = geo_deg_to_rad(lat2), l2 = geo_deg_to_rad(lon2);
    double ux = cos(p1) * cos(l1), uy = cos(p1) * sin(l1), uz = sin(p1);
    double vx = cos(p2) * cos(l2), vy = cos(p2) * sin(l2), vz = sin(p2);
    double cx = uy * vz - uz * vy, cy = uz * vx - ux * vz, cz = ux * vy - uy * vx;
    double cross = sqrt(cx * cx + cy * cy + cz * cz);
    double dot = ux * vx + uy * vy + uz * vz;
    return atan2(cross, dot) * GEO_EARTH_RADIUS_KM;
}
#endif

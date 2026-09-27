/* S02 reference: nearly antipodal sweep. For k = 1..12 let the pair be (0, 0) and (0, lon2) with
   lon2 = 180 - 10^-k. Both formulations are evaluated as central angles in radians (before scaling by R) and
   compared with a long double reference computed from the *actual* double lon2, because 180 - 10^-k is not
   representable and delta = 180 - lon2 is exact (Sterbenz). Output lines are measurements, not asserted values. */
#include <float.h>
#include <math.h>
#include <stdio.h>
#include "geomath.h"

static double haversine_angle(double lat1, double lon1, double lat2, double lon2)
{
    double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0), sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
    double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
    a = a < 0.0 ? 0.0 : (a > 1.0 ? 1.0 : a);
    return 2.0 * asin(sqrt(a));
}

static double vector_angle(double lat1, double lon1, double lat2, double lon2)
{
    Vec3 u, v;
    latlon_to_unit(lat1, lon1, &u); latlon_to_unit(lat2, lon2, &v);
    Vec3 c = vec3_cross(u, v);
    return atan2(sqrt(vec3_dot(c, c)), vec3_dot(u, v));
}

int main(void)
{
    const long double LPI = 3.14159265358979323846264338327950288L;
    for (int k = 1; k <= 12; ++k) {
        double delta_nominal = pow(10.0, -k), lon2 = 180.0 - delta_nominal;
        double delta = 180.0 - lon2;                                   /* exact */
        long double delta_rad = (long double)delta * LPI / 180.0L;
        long double truth = LPI - delta_rad;                           /* central angle for lon2, in radians */
        double h = haversine_angle(0, 0, 0, lon2), v = vector_angle(0, 0, 0, lon2);
        double herr = (double)fabsl((long double)h - truth), verr = (double)fabsl((long double)v - truth);
        /* amplification of the final inverse function at the true argument (derivative magnitude):
           haversine: c = 2 asin(s), s = cos(delta/2) => dc/ds = 2 / sin(delta/2) ;  vector: c = atan2(y, x), x = -cos(delta), y = sin(delta) => dc/dy = |x| / (x^2 + y^2) = cos(delta) */
        double amp_h = (double)(2.0L / sinl(delta_rad / 2.0L)), amp_v = (double)cosl(delta_rad);
        printf("k=%d delta_deg=%.6e true_angle_rad=%.17Lg haversine_err_rad=%.3e vector_err_rad=%.3e amp_haversine=%.3e amp_vector=%.3e\n",
               k, delta, truth, herr, verr, amp_h, amp_v);
    }
    return 0;
}

/* geomath.c: assemble your E02-E06 solutions here (copy them; there is no shared learner library).
   Public functions are the ones declared in geomath.h. Every other function or object must be static.
   No printing, no exit, no writable globals. The stubs below compile cleanly and fail the tests. */
#include <math.h>
#include <stddef.h>
#include "geomath.h"

/* TODO: replace each stub with your solution from the exercise named in its comment. */

int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal) /* E02 */
{
    (void)a; (void)b; (void)rel_tol; (void)abs_tol; (void)equal; return 0;
}

double deg_to_rad(double degrees) { (void)degrees; return 0.0; } /* E03 */
double rad_to_deg(double radians) { (void)radians; return 0.0; }
int wrap_lon_deg(double lon, double *out) { (void)lon; (void)out; return 0; }
int lon_delta_deg(double from, double to, double *out) { (void)from; (void)to; (void)out; return 0; }
int sin_deg(double degrees, double *out) { (void)degrees; (void)out; return 0; }
int cos_deg(double degrees, double *out) { (void)degrees; (void)out; return 0; }

double vec3_dot(Vec3 a, Vec3 b) { (void)a; (void)b; return 0.0; } /* E04 */
Vec3 vec3_cross(Vec3 a, Vec3 b) { (void)a; (void)b; Vec3 r = {0.0, 0.0, 0.0}; return r; }
int vec3_length(Vec3 v, double *out) { (void)v; (void)out; return 0; }
int vec3_normalize(Vec3 v, Vec3 *out) { (void)v; (void)out; return 0; }
int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out) { (void)lat_deg; (void)lon_deg; (void)out; return 0; }
int unit_to_latlon(Vec3 v, double *lat_deg, double *lon_deg) { (void)v; (void)lat_deg; (void)lon_deg; return 0; }

int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out) /* E05 */
{
    (void)lat1; (void)lon1; (void)lat2; (void)lon2; (void)out; return 0;
}

int geo_distance_km_vector(double lat1, double lon1, double lat2, double lon2, double *out)
{
    (void)lat1; (void)lon1; (void)lat2; (void)lon2; (void)out; return 0;
}

int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out) /* E06 */
{
    (void)p0; (void)p1; (void)q0; (void)q1; (void)out; return 0;
}

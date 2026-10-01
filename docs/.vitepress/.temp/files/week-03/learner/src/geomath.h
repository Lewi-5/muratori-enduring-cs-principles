#ifndef GEOMATH_H
#define GEOMATH_H
/* geomath: a small spherical-geometry library.
   TODO (E07.C): write the contract of every function as a comment. For each one state what it accepts,
   what it rejects, what it returns for NaN, infinity and overflow, and that a rejected call leaves its
   outputs unchanged. State that the library never prints, exits, or reads errno. Then make every helper
   in geomath.c static: only the names declared here may be visible to the linker. */
#include "geo_consts.h"

typedef enum { SEG_NONE, SEG_POINT, SEG_OVERLAP } SegKind;
typedef struct { SegKind kind; Vec2 a; Vec2 b; } SegResult;

/* Angles (E03). */
double deg_to_rad(double degrees);
double rad_to_deg(double radians);
int wrap_lon_deg(double lon, double *out);
int lon_delta_deg(double from, double to, double *out);
int sin_deg(double degrees, double *out);
int cos_deg(double degrees, double *out);

/* Vectors (E04). */
double vec3_dot(Vec3 a, Vec3 b);
Vec3 vec3_cross(Vec3 a, Vec3 b);
int vec3_length(Vec3 v, double *out);
int vec3_normalize(Vec3 v, Vec3 *out);
int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out);
/* unit_to_latlon: longitude is 0 only when the original v.x and v.y are both exactly zero;
   otherwise their original values determine longitude, even if normalization rounds them to zero. */
int unit_to_latlon(Vec3 v, double *lat_deg, double *lon_deg);

/* Distance (E05): the haversine path and the unit-vector path. */
int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out);
int geo_distance_km_vector(double lat1, double lon1, double lat2, double lon2, double *out);

/* Segments (E06). */
int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out);

/* Comparison (E02). */
int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal);
#endif

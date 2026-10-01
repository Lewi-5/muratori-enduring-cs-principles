#ifndef GEOMATH_H
#define GEOMATH_H
/* geomath: a small spherical-geometry library. Public API only; every helper in geomath.c is static.
   The library never prints, exits, or reads errno. Every function that reports a status returns 1 on
   success and 0 on rejection, and a rejected call leaves its output object(s) unchanged.
   Angles are degrees unless a name says otherwise. All doubles are binary64 on the reference platform. */
#include "geo_consts.h"

typedef enum { SEG_NONE, SEG_POINT, SEG_OVERLAP } SegKind;
typedef struct { SegKind kind; Vec2 a; Vec2 b; } SegResult;

/* Angles. Non-finite input is rejected; deg_to_rad and rad_to_deg are total (NaN in, NaN out). */
double deg_to_rad(double degrees);
double rad_to_deg(double radians);
/* wrap_lon_deg: any finite lon -> [-180, 180) (half-open: +180 maps to -180). */
int wrap_lon_deg(double lon, double *out);
/* lon_delta_deg: from and to must lie in [-180, 180]; result is wrap(to - from) in [-180, 180). */
int lon_delta_deg(double from, double to, double *out);
/* sin_deg/cos_deg: exact 0, +-1 at every multiple of 90; exactly odd/even; never -0.0. */
int sin_deg(double degrees, double *out);
int cos_deg(double degrees, double *out);

/* Vectors. */
double vec3_dot(Vec3 a, Vec3 b);
Vec3 vec3_cross(Vec3 a, Vec3 b);
/* vec3_length: finite input; rejected only when the length itself exceeds DBL_MAX (up to rounding). */
int vec3_length(Vec3 v, double *out);
/* vec3_normalize: succeeds for every finite nonzero vector; rejects zero and non-finite input. */
int vec3_normalize(Vec3 v, Vec3 *out);
/* latlon_to_unit: lat in [-90, 90], lon in [-180, 180], both finite. */
int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out);
/* unit_to_latlon: any finite nonzero vector; longitude is 0 only if original x and y are exactly zero.
   Otherwise original x and y determine longitude even if normalization underflows them. lat in [-90,90], lon in [-180,180). */
int unit_to_latlon(Vec3 v, double *lat_deg, double *lon_deg);

/* Great-circle distance on a sphere of radius GEO_EARTH_RADIUS_KM (a model constant). Both reject
   non-finite input, latitude outside [-90, 90] and longitude outside [-180, 180]. Results lie in [0, pi R]. */
int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out);         /* haversine */
int geo_distance_km_vector(double lat1, double lon1, double lat2, double lon2, double *out);  /* atan2(|u x v|, u.v) */

/* Closed planar segments. Every coordinate must be finite with |c| <= 2^25, else rejected. Results are exactly
   classified for integer-valued input. See segment_intersect in geomath.c for the degenerate-case policy. */
int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out);

/* approx_equal: tolerances must be finite and nonnegative, else rejected. NaN never equals anything;
   a == b (including infinities and +-0) is equal; |a-b| <= max(abs_tol, rel_tol*max(|a|,|b|)) otherwise. */
int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal);
#endif

#ifndef GEOLAB_H
#define GEOLAB_H
/* geolab contract version 1 (checkpoint 1): the public data types and functions. Supplied; the definitions live in
   csv.c, geo.c and query.c. Library functions never print and never exit: they return a status. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "geolab_types.h" /* GeoPoint, ParseStatus, GEOLAB_MAX_ROWS, GEOLAB_MAX_LINE, GEOLAB_HEADER */

/* ---- csv.c: the week-4 CSV v1 format ---- */

/* Where and why a load failed: 1-based line (0 when no line is responsible) and the status. */
typedef struct { size_t line; ParseStatus status; } LoadError;

/* Write the header and count generated rows to out. Returns 1, or 0 if out is NULL, count > GEOLAB_MAX_ROWS or a
   write fails. The bytes are a pure function of (seed, count) (week 4). */
int generate_csv(uint64_t seed, size_t count, FILE *out);

/* Generate into path in binary mode; on failure after opening, the partial file is removed. Returns 1 or 0. */
int write_csv_file(const char *path, uint64_t seed, size_t count);

/* Parse one line without its newline (week 4's canonical grammar and ordered statuses). *out is unchanged unless
   PARSE_OK is returned. */
ParseStatus parse_record(const char *line, GeoPoint *out);

/* Load a CSV v1 file. Success: returns 1, *points is the array (NULL for zero rows; the caller frees it), *count
   the row count, *err = {0, PARSE_OK}. Failure: returns 0, nothing stays allocated, *points and *count unchanged,
   *err set. A NULL argument returns 0 and changes nothing. */
int load_points(const char *path, GeoPoint **points, size_t *count, LoadError *err);

/* ---- geo.c: week 3's validated haversine ---- */

/* 1 if both coordinates are finite, latitude in [-90, 90] and longitude in [-180, 180]. */
int geo_valid_position(double lat_deg, double lon_deg);

/* Great-circle distance on the model sphere by the haversine formula, with the intermediate clamped to [0, 1].
   Returns 1 and writes *out, or 0 (nothing written) for a NULL out or an invalid position. */
int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out);

/* ---- query.c ---- */

typedef struct { uint64_t id; double distance_km; } QueryHit;

#define GEOLAB_MAX_RADIUS_KM 100000.0

/* Select every point whose haversine distance from (lat, lon) is <= radius_km (inclusive), ordered by the unrounded
   distance ascending and then by identifier ascending.
   Validation first: hits and nhits non-NULL; points non-NULL when count > 0; the center a valid position; radius_km
   finite and in [0, GEOLAB_MAX_RADIUS_KM]; every point a valid position. Returns 0 on any validation or allocation
   failure, with no allocation left behind and *hits and *nhits unchanged.
   Success: returns 1; *hits is an array of exactly *nhits elements that the caller frees (NULL when *nhits is 0). */
int query_points(const GeoPoint *points, size_t count, double lat, double lon, double radius_km, QueryHit **hits,
                 size_t *nhits);

/* The qsort comparator used by query_points: returns -1, 0 or 1 by distance, then identifier. Exposed so that the
   contract tests can check it is a total order on the fields that are printed. */
int query_hit_compare(const void *a, const void *b);
#endif

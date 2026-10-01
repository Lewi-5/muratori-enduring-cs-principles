/* query.c: the deterministic point query (E02). Reference solution. */
#include <math.h>
#include <stdint.h>
#include <stdlib.h>
#include "geolab.h"

/* A total order on (distance, id): -1, 0 or 1, never a narrowed difference. No NaN can reach it (every distance
   comes from validated input and the clamped haversine), so the < and > comparisons are a total order on the
   distances that occur. Two hits compare equal only when distance and identifier are both equal, and then they
   print identical lines, so qsort's lack of stability (C11 7.22.5.2) cannot change the output. */
int query_hit_compare(const void *a, const void *b)
{
    const QueryHit *x = a, *y = b;
    if (x->distance_km < y->distance_km) return -1;
    if (x->distance_km > y->distance_km) return 1;
    if (x->id < y->id) return -1;
    if (x->id > y->id) return 1;
    return 0;
}

int query_points(const GeoPoint *points, size_t count, double lat, double lon, double radius_km, QueryHit **hits,
                 size_t *nhits)
{
    /* 1. Validate everything before allocating or writing anything. */
    if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
    if (!geo_valid_position(lat, lon)) return 0;
    if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
    for (size_t i = 0; i < count; ++i) {
        if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
    }
    if (count == 0) {
        *hits = NULL;
        *nhits = 0;
        return 1;
    }
    /* 2. Compute each distance exactly once. The temporary holds every distance so that selection and the final
          array use the same unrounded values; its size is checked before multiplying. */
    if (count > SIZE_MAX / sizeof(double)) return 0;
    double *dist = malloc(count * sizeof(double));
    if (dist == NULL) return 0;
    size_t selected = 0;
    for (size_t i = 0; i < count; ++i) {
        double d = 0.0;
        if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
            free(dist);
            return 0;
        }
        dist[i] = d;
        if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
    }
    /* 3. Allocate exactly the needed array (NULL for zero hits); selected <= count, and the product is checked. */
    QueryHit *out = NULL;
    if (selected > 0) {
        if (selected > SIZE_MAX / sizeof(QueryHit)) {
            free(dist);
            return 0;
        }
        out = malloc(selected * sizeof(QueryHit));
        if (out == NULL) {
            free(dist);
            return 0;
        }
        size_t k = 0;
        for (size_t i = 0; i < count; ++i) {
            if (dist[i] <= radius_km) {
                out[k].id = points[i].id;
                out[k].distance_km = dist[i];
                ++k;
            }
        }
        /* 4. Sort by the unrounded distance, then identifier. */
        qsort(out, selected, sizeof *out, query_hit_compare);
    }
    free(dist);
    /* 5. Commit. */
    *hits = out;
    *nhits = selected;
    return 1;
}

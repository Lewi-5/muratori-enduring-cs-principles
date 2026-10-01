/* query.c: the deterministic point query (E02.C). The contract is in geolab.h. */
#include <math.h>
#include <stdint.h>
#include <stdlib.h>
#include "geolab.h"

/* TODO: return -1, 0 or 1 by distance_km, then by id. Never return a (narrowed) difference. */
int query_hit_compare(const void *a, const void *b)
{
    (void)a;
    (void)b;
    return 0;
}

/* TODO, in this order:
   1. validate everything (hits/nhits non-NULL, points non-NULL when count > 0, the center, the radius in
      [0, GEOLAB_MAX_RADIUS_KM], every point) before allocating or writing anything;
   2. compute each distance exactly once with geo_distance_km;
   3. allocate exactly the needed QueryHit array (check the size before multiplying; NULL for zero hits);
   4. qsort it with query_hit_compare;
   5. commit *hits and *nhits. On any failure free what you allocated and leave both outputs unchanged. */
int query_points(const GeoPoint *points, size_t count, double lat, double lon, double radius_km, QueryHit **hits,
                 size_t *nhits)
{
    (void)points;
    (void)count;
    (void)lat;
    (void)lon;
    (void)radius_km;
    (void)hits;
    (void)nhits;
    return 0;
}

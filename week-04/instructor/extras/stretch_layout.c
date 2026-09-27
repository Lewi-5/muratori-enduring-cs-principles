/* S01(a): array-of-structs versus separate coordinate arrays. The two processors perform the same operations in
   the same order, so the results are required to be bitwise identical. No timing and no speed or cache claim is
   made here: what would have to be measured is discussed in the answer key and deferred to weeks 5 and 23. */
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define main ex06_main
#include "../src/ex06.c"
#undef main

/* Same contract as process_points, over separate latitude and longitude arrays (no identifiers stored). */
static int process_points_soa(const double *lat, const double *lon, size_t count, double center_lat, double center_lon,
                              double radius_km, ProcessResult *out)
{
    if (out == NULL || ((lat == NULL || lon == NULL) && count > 0)) return 0;
    if (!valid_position(center_lat, center_lon)) return 0;
    if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > 100000.0) return 0;
    for (size_t i = 0; i < count; ++i) {
        if (!valid_position(lat[i], lon[i])) return 0;
    }
    ProcessResult r = {0, 0, 0.0, 0.0, 0.0};
    for (size_t i = 0; i < count; ++i) {
        double d = 0.0;
        if (!haversine_km(center_lat, center_lon, lat[i], lon[i], &d)) return 0;
        if (d <= radius_km) ++r.within;
        r.sum_km += d;
        if (i == 0 || d < r.min_km) r.min_km = d;
        if (i == 0 || d > r.max_km) r.max_km = d;
        ++r.points;
    }
    *out = r;
    return 1;
}

int main(void)
{
    enum { N = 10000 };
    GeoPoint *aos = malloc(N * sizeof *aos);
    double *lat = malloc(N * sizeof *lat), *lon = malloc(N * sizeof *lon);
    if (aos == NULL || lat == NULL || lon == NULL) return 1;
    uint64_t s = 20260921;
    for (int i = 0; i < N; ++i) {
        s = s * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        uint32_t a = (uint32_t)(s >> 32);
        s = s * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
        uint32_t b = (uint32_t)(s >> 32);
        aos[i].id = (uint64_t)i + 1;
        aos[i].lat_deg = lat[i] = (double)((int64_t)(a % 180000001u) - 90000000) / 1e6;
        aos[i].lon_deg = lon[i] = (double)((int64_t)(b % 360000001u) - 180000000) / 1e6;
    }
    ProcessResult ra, rs;
    memset(&ra, 0, sizeof ra);
    memset(&rs, 0, sizeof rs);
    if (!process_points(aos, N, 37.75, -122.5, 8000.0, &ra) || !process_points_soa(lat, lon, N, 37.75, -122.5, 8000.0, &rs)) return 1;
    /* ProcessResult has no padding on this platform (size_t, size_t, three doubles); compare field by field anyway */
    int equal = ra.points == rs.points && ra.within == rs.within && memcmp(&ra.sum_km, &rs.sum_km, sizeof(double)) == 0 &&
                memcmp(&ra.min_km, &rs.min_km, sizeof(double)) == 0 && memcmp(&ra.max_km, &rs.max_km, sizeof(double)) == 0;
    printf("soa_bitwise_equal=%d layout_identical=%d sum_km=%.17g\n", equal, equal, ra.sum_km);
    printf("storage_bytes_per_point aos=%zu soa_lat_lon=%zu soa_with_ids=%zu (sizeof, this platform; gated observation)\n",
           sizeof(GeoPoint), 2 * sizeof(double), 2 * sizeof(double) + sizeof(uint64_t));
    printf("allocations aos=1 soa=2 (lat, lon) or 3 with an id array\n");
    printf("query_reads fields=lat,lon (ids are needed only to name results)\n");
    free(aos);
    free(lat);
    free(lon);
    return equal ? 0 : 1;
}

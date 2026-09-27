#include <inttypes.h>
#include <math.h>
#include <stdio.h>

typedef struct { uint64_t id; double lat_deg; double lon_deg; } GeoPoint;

int valid_point(GeoPoint point)
{
    return isfinite(point.lat_deg) && isfinite(point.lon_deg)
        && point.lat_deg >= -90.0 && point.lat_deg <= 90.0
        && point.lon_deg >= -180.0 && point.lon_deg <= 180.0;
}

int main(void)
{
    GeoPoint point = {UINT64_C(42), 45.5, -73.5};
    if (!valid_point(point)) return 1;
    printf("id=%" PRIu64 " lat=%.1f lon=%.1f\n", point.id, point.lat_deg, point.lon_deg);
    return 0;
}

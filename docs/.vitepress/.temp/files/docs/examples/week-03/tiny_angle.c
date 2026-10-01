#include <math.h>
#include <stdio.h>

int main(void)
{
    const double radius_km = 6371.0;
    double angle = 1e-8; /* radians: two points about 6 cm apart on the equator */
    double c = cos(angle);
    double via_cosine = acos(c) * radius_km * 1e5;          /* centimetres */
    double s = sin(angle / 2);
    double via_haversine = 2 * asin(s) * radius_km * 1e5;   /* centimetres */
    printf("cos(1e-8) == 1.0 ? %s\n", c == 1.0 ? "yes" : "no");
    printf("law of cosines: %.3f cm\n", via_cosine);
    printf("haversine:      %.3f cm\n", via_haversine);
    return 0;
}

/* S01: bytes read and written per point by each bench variant, derived rather than guessed.
   Build and run (from week-05):
     gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -O2 -Iinstructor/geolab/include -Isupport \
         instructor/extras/bytes_per_point.c -o build/bytes_per_point && ./build/bytes_per_point build/data/d1m.csv 1000000

   CSV bytes per row are derived from the generator's distribution (week 4): latitude microdegrees are uniform over
   the 180,000,001 integers in [-90e6, 90e6], longitude over the 360,000,001 integers in [-180e6, 180e6]. A field is
   "-" (negative values only) + integer digits + "." + 6 digits. The expected size of an n-row file is
   19 (header and newline) + sum of the digit counts of 1..n + n * (3 + E[lat length] + E[lon length]),
   where the 3 counts two commas and a newline. The program compares this with the actual file size. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include "geolab.h"

/* Digits of 1..n, exactly. */
static uint64_t digit_sum(uint64_t n)
{
    uint64_t total = 0, lo = 1, width = 1;
    while (lo <= n) {
        uint64_t hi = lo * 10 - 1;
        if (hi > n) hi = n;
        total += (hi - lo + 1) * width;
        lo *= 10;
        ++width;
    }
    return total;
}

int main(int argc, char **argv)
{
    if (argc != 3) {
        fprintf(stderr, "usage: bytes_per_point FILE ROWS\n");
        return 2;
    }
    uint64_t n = strtoull(argv[2], NULL, 10);
    /* Latitude: |v| <= 9,999,999 has 1 integer digit (19,999,999 values), else 2 (160,000,002 values);
       90,000,000 values are negative. Longitude: 1 digit 19,999,999 values; 2 digits 180,000,000; 3 digits
       160,000,002; 180,000,000 negative. Every field has 8 fixed characters counting one integer digit. */
    const double lat_values = 180000001.0, lon_values = 360000001.0;
    double e_lat = 8.0 + 160000002.0 / lat_values + 90000000.0 / lat_values;
    double e_lon = 8.0 + (180000000.0 + 2.0 * 160000002.0) / lon_values + 180000000.0 / lon_values;
    double expected = 19.0 + (double)digit_sum(n) + (double)n * (3.0 + e_lat + e_lon);
    struct stat st;
    if (stat(argv[1], &st) != 0) {
        perror(argv[1]);
        return 1;
    }
    printf("E[lat field]=%.6f E[lon field]=%.6f bytes\n", e_lat, e_lon);
    printf("expected_file_bytes=%.1f actual_file_bytes=%lld relative_difference=%.2e\n", expected,
           (long long)st.st_size, ((double)st.st_size - expected) / expected);
    printf("parse: reads %.3f CSV bytes per row and writes sizeof(GeoPoint)=%zu bytes per row (reference ABI)\n",
           (double)st.st_size / (double)n, sizeof(GeoPoint));
    printf("distance: reads 16 of the %zu bytes of each GeoPoint (lat_deg, lon_deg); writes nothing per point\n", sizeof(GeoPoint));
    printf("query: reads 16 bytes per point; writes sizeof(QueryHit)=%zu bytes per hit (plus 8 bytes per point for the\n"
           "       reference's temporary distance array: one write and one read of a double)\n", sizeof(QueryHit));
    return 0;
}

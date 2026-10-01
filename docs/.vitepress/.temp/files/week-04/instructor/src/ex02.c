/* E02: formatting fixed-point text from integers. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

/* Write value (whole microdegrees) as [-]I.FFFFFF using integer arithmetic only. limit must be 90000000 or
   180000000 and |value| <= limit. Needs strlen(text) + 1 bytes. A rejection (return 0) leaves out untouched.
   Maximum text: "-180.000000" is 11 characters, so 12 bytes. Overflow contract: the magnitude is computed in
   int64_t, so INT32_MIN is never negated in int32_t (that would be undefined behavior). */
int format_udeg(int32_t value, int32_t limit, char *out, size_t out_size)
{
    if (out == NULL || (limit != 90000000 && limit != 180000000)) return 0;
    int64_t wide = value;
    int64_t magnitude = wide < 0 ? -wide : wide; /* exact: |INT32_MIN| = 2^31 fits in int64_t */
    if (magnitude > limit) return 0;
    char text[16]; /* 11 characters + NUL at most */
    size_t n = 0;
    if (wide < 0) text[n++] = '-';
    int64_t whole = magnitude / 1000000, frac = magnitude % 1000000;
    char digits[4];
    int nd = 0;
    do { digits[nd++] = (char)('0' + whole % 10); whole /= 10; } while (whole > 0); /* at most 3 digits */
    while (nd > 0) text[n++] = digits[--nd];
    text[n++] = '.';
    for (int64_t scale = 100000; scale > 0; scale /= 10) text[n++] = (char)('0' + frac / scale % 10);
    text[n] = '\0';
    if (out_size < n + 1) return 0;
    memcpy(out, text, n + 1);
    return 1;
}

/* Write "ID,LAT,LON\n" with a NUL terminator; latitude limit 90000000, longitude limit 180000000. The longest
   record is 20 + 1 + 10 + 1 + 11 + 1 = 44 characters, so 45 bytes. Rejection leaves out untouched. */
int format_record(uint64_t id, int32_t lat_udeg, int32_t lon_udeg, char *out, size_t out_size)
{
    if (out == NULL) return 0;
    char text[64];
    size_t n = 0;
    char digits[20];
    int nd = 0;
    uint64_t rest = id;
    do { digits[nd++] = (char)('0' + rest % 10); rest /= 10; } while (rest > 0); /* at most 20 digits */
    while (nd > 0) text[n++] = digits[--nd];
    text[n++] = ',';
    char field[16];
    if (!format_udeg(lat_udeg, 90000000, field, sizeof field)) return 0;
    size_t len = strlen(field);
    memcpy(text + n, field, len);
    n += len;
    text[n++] = ',';
    if (!format_udeg(lon_udeg, 180000000, field, sizeof field)) return 0;
    len = strlen(field);
    memcpy(text + n, field, len);
    n += len;
    text[n++] = '\n';
    text[n] = '\0';
    if (out_size < n + 1) return 0;
    memcpy(out, text, n + 1);
    return 1;
}

int main(void)
{
    static const struct { uint64_t id; int32_t lat, lon; } records[] = {
        {1, 0, 0}, {7, -5, 10}, {42, 45123456, -122654321}, {0, 999999, -1000000},
        {UINT64_MAX, -90000000, -180000000}, {123456789, 90000000, 180000000}};
    for (size_t i = 0; i < sizeof records / sizeof records[0]; ++i) {
        char buf[64];
        if (!format_record(records[i].id, records[i].lat, records[i].lon, buf, sizeof buf)) return 1;
        printf("line=%s", buf); /* the record already ends with a newline */
    }
    return 0;
}

/* E04: parsing one record. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

/* Identifier: "0" or [1-9][0-9]{0,19}, at most UINT64_MAX. Returns 1 and sets *value, or 0.
   Overflow contract: v * 10 + d must not exceed UINT64_MAX. That holds exactly when
   v <= (UINT64_MAX - d) / 10 (integer division). Testing only v > UINT64_MAX / 10 is not enough: it lets
   v == UINT64_MAX / 10 through with a digit above 5, which wraps (that is the identifier 18446744073709551616). */
static int parse_id(const char *s, size_t n, uint64_t *value)
{
    if (n == 0 || n > 20) return 0;
    if (s[0] == '0' && n > 1) return 0; /* no leading zeros */
    uint64_t v = 0;
    for (size_t i = 0; i < n; ++i) {
        if (s[i] < '0' || s[i] > '9') return 0; /* a comparison on char: isdigit(char) would be undefined for negatives */
        unsigned d = (unsigned)(s[i] - '0');
        if (v > (UINT64_MAX - d) / 10) return 0;
        v = v * 10 + d;
    }
    *value = v;
    return 1;
}

/* One coordinate field: [-]I.FFFFFF with I = "0" or a nonzero digit followed by at most max_int_digits - 1
   digits, and exactly six fraction digits. Result: 0 valid, 1 grammar error, 2 magnitude above limit_udeg.
   The digit counts are bounded before accumulating, so micro <= 999999999 and int64_t cannot overflow. */
static int parse_udeg(const char *s, size_t n, size_t max_int_digits, int64_t limit_udeg, int64_t *micro, int *negative)
{
    size_t i = 0;
    int neg = 0;
    if (i < n && s[i] == '-') { neg = 1; ++i; }
    size_t start = i;
    while (i < n && s[i] >= '0' && s[i] <= '9') ++i;
    size_t int_digits = i - start;
    if (int_digits == 0 || int_digits > max_int_digits) return 1;
    if (s[start] == '0' && int_digits > 1) return 1;
    if (i >= n || s[i] != '.') return 1;
    ++i;
    if (n - i != 6) return 1; /* exactly six fraction digits, nothing after */
    int64_t whole = 0, frac = 0;
    for (size_t k = start; k < start + int_digits; ++k) whole = whole * 10 + (s[k] - '0');
    for (size_t k = i; k < n; ++k) {
        if (s[k] < '0' || s[k] > '9') return 1;
        frac = frac * 10 + (s[k] - '0');
    }
    int64_t m = whole * 1000000 + frac;
    if (neg && m == 0) return 1; /* "-0.000000" is not canonical */
    if (m > limit_udeg) return 2;
    *micro = m;
    *negative = neg;
    return 0;
}

/* Parse one line (without its newline). Statuses are returned in this order of precedence: empty line, field
   count (exactly two commas), identifier, latitude grammar, latitude range, longitude grammar, longitude range.
   *out is written only on PARSE_OK. NULL line or out is PARSE_INVALID_ARGUMENT. */
ParseStatus parse_record(const char *line, GeoPoint *out)
{
    if (line == NULL || out == NULL) return PARSE_INVALID_ARGUMENT;
    if (line[0] == '\0') return PARSE_EMPTY;
    size_t commas = 0, first = 0, second = 0, len = 0;
    for (; line[len] != '\0'; ++len) {
        if (line[len] == ',') {
            if (commas == 0) first = len;
            else if (commas == 1) second = len;
            ++commas;
        }
    }
    if (commas != 2) return PARSE_FIELD_COUNT;
    uint64_t id = 0;
    if (!parse_id(line, first, &id)) return PARSE_BAD_ID;
    int64_t lat_micro = 0, lon_micro = 0;
    int lat_neg = 0, lon_neg = 0;
    int r = parse_udeg(line + first + 1, second - first - 1, 2, 90000000, &lat_micro, &lat_neg);
    if (r == 1) return PARSE_BAD_LAT;
    if (r == 2) return PARSE_LAT_RANGE;
    r = parse_udeg(line + second + 1, len - second - 1, 3, 180000000, &lon_micro, &lon_neg);
    if (r == 1) return PARSE_BAD_LON;
    if (r == 2) return PARSE_LON_RANGE;
    /* micro and 1e6 are exactly representable, and IEEE division is correctly rounded, so each result is the
       double nearest the decimal text; negation is exact. */
    double lat = (double)lat_micro / 1000000.0, lon = (double)lon_micro / 1000000.0;
    out->id = id;
    out->lat_deg = lat_neg ? -lat : lat;
    out->lon_deg = lon_neg ? -lon : lon;
    return PARSE_OK;
}

int main(void)
{
    static const char *const lines[] = {
        "1,0.000000,0.000000", "18446744073709551615,90.000000,180.000000", "7,-33.868800,151.209300",
        "01,1.000000,1.000000", "5,91.000000,0.000000", "5,1.5,2.000000", "3,0.000000", "9,-0.000000,0.000000",
        "10,45.000000,181.000000", "18446744073709551616,0.000000,0.000000", ""};
    for (size_t i = 0; i < sizeof lines / sizeof lines[0]; ++i) {
        GeoPoint p = {0, 0.0, 0.0};
        ParseStatus s = parse_record(lines[i], &p);
        printf("line=\"%s\" status=%s", lines[i], parse_status_name(s));
        if (s == PARSE_OK) printf(" id=%" PRIu64 " lat=%.6f lon=%.6f", p.id, p.lat_deg, p.lon_deg);
        printf("\n");
    }
    return 0;
}

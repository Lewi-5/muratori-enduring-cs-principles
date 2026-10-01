/* csv.c: the week-4 CSV v1 generator, formatter, parser and loader, assembled into one translation unit.
   Reference solution. Only the four functions declared in geolab.h have external linkage; every helper is static
   (internal linkage, week 2 E09), so `make symbols` shows exactly the public interface. The code is week 4's
   reference unchanged apart from linkage: checkpoint 1 promises that `generate` stays byte-identical. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "geolab.h"

/* ---- generator (week 4 E01-E03) ---- */

static uint32_t lcg_next(uint64_t *state)
{
    *state = *state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407); /* unsigned: wraps mod 2^64 */
    return (uint32_t)(*state >> 32); /* the high bits: the low bits of a power-of-two LCG have short periods */
}

/* Rejection sampling: draw until r >= threshold = 2^32 mod bound, so every residue has the same number of
   accepted raw values. bound > 0 always holds for the two constant bounds used below. */
static uint32_t lcg_below(uint64_t *state, uint32_t bound)
{
    uint32_t threshold = (uint32_t)(UINT32_C(0) - bound) % bound;
    uint32_t r = lcg_next(state);
    while (r < threshold) r = lcg_next(state);
    return r % bound;
}

/* Canonical fixed-point text of a microdegree value with |value| <= limit, integer arithmetic only. The caller
   guarantees the range, so the magnitude (computed in int64_t, never by negating INT32_MIN) has at most three
   integer digits; text needs at most 12 bytes ("-180.000000" plus the terminator). */
static size_t format_udeg(int32_t value, char *text)
{
    int64_t wide = value;
    int64_t magnitude = wide < 0 ? -wide : wide;
    size_t n = 0;
    if (wide < 0) text[n++] = '-';
    int64_t whole = magnitude / 1000000, frac = magnitude % 1000000;
    char digits[4];
    int nd = 0;
    do { digits[nd++] = (char)('0' + whole % 10); whole /= 10; } while (whole > 0);
    while (nd > 0) text[n++] = digits[--nd];
    text[n++] = '.';
    for (int64_t scale = 100000; scale > 0; scale /= 10) text[n++] = (char)('0' + frac / scale % 10);
    return n;
}

/* "ID,LAT,LON\n" into line (at least 64 bytes; the longest record is 44 characters). Returns the length. */
static size_t format_record(uint64_t id, int32_t lat_udeg, int32_t lon_udeg, char *line)
{
    size_t n = 0;
    char digits[20];
    int nd = 0;
    uint64_t rest = id;
    do { digits[nd++] = (char)('0' + rest % 10); rest /= 10; } while (rest > 0);
    while (nd > 0) line[n++] = digits[--nd];
    line[n++] = ',';
    n += format_udeg(lat_udeg, line + n);
    line[n++] = ',';
    n += format_udeg(lon_udeg, line + n);
    line[n++] = '\n';
    line[n] = '\0';
    return n;
}

int generate_csv(uint64_t seed, size_t count, FILE *out)
{
    if (out == NULL || count > GEOLAB_MAX_ROWS) return 0;
    if (fputs(GEOLAB_HEADER "\n", out) == EOF) return 0;
    uint64_t state = seed;
    for (size_t i = 1; i <= count; ++i) {
        uint32_t r = lcg_below(&state, 180000001u); /* latitude first, in its own statement */
        int32_t lat_udeg = (int32_t)((int64_t)r - 90000000);
        r = lcg_below(&state, 360000001u);           /* then longitude */
        int32_t lon_udeg = (int32_t)((int64_t)r - 180000000);
        char line[64];
        format_record((uint64_t)i, lat_udeg, lon_udeg, line);
        if (fputs(line, out) == EOF) return 0;
    }
    return ferror(out) == 0;
}

/* Week 4 removed the partial file after any failure following a successful fopen. Week 5 adds one check: remove
   only a regular file (POSIX stat). A path such as /dev/full opens successfully and then fails every write; removing
   it would delete a device node when run with enough privilege. A pre-existing regular file was already truncated
   by "wb", so removing its partial replacement loses nothing more (the week-4 limitation still stands). */
int write_csv_file(const char *path, uint64_t seed, size_t count)
{
    if (path == NULL || count > GEOLAB_MAX_ROWS) return 0;
    FILE *f = fopen(path, "wb");
    if (f == NULL) return 0; /* nothing was created, so nothing is removed (the path may be a directory) */
    int ok = generate_csv(seed, count, f);
    if (fflush(f) != 0) ok = 0;
    if (fclose(f) != 0) ok = 0;
    if (!ok) {
        struct stat st;
        if (stat(path, &st) == 0 && S_ISREG(st.st_mode)) remove(path);
        return 0;
    }
    return 1;
}

/* ---- parser (week 4 E04) ---- */

static int parse_id_digits(const char *s, size_t n, uint64_t *value)
{
    if (n == 0 || n > 20) return 0;
    if (s[0] == '0' && n > 1) return 0;
    uint64_t v = 0;
    for (size_t i = 0; i < n; ++i) {
        if (s[i] < '0' || s[i] > '9') return 0;
        unsigned d = (unsigned)(s[i] - '0');
        if (v > (UINT64_MAX - d) / 10) return 0; /* v * 10 + d would exceed UINT64_MAX */
        v = v * 10 + d;
    }
    *value = v;
    return 1;
}

/* 0 = valid, 1 = grammar error, 2 = range error. */
static int parse_udeg_field(const char *s, size_t n, size_t max_int_digits, int64_t limit_udeg, int64_t *micro, int *negative)
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
    if (n - i != 6) return 1;
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
    if (!parse_id_digits(line, first, &id)) return PARSE_BAD_ID;
    int64_t lat_micro = 0, lon_micro = 0;
    int lat_neg = 0, lon_neg = 0;
    int r = parse_udeg_field(line + first + 1, second - first - 1, 2, 90000000, &lat_micro, &lat_neg);
    if (r == 1) return PARSE_BAD_LAT;
    if (r == 2) return PARSE_LAT_RANGE;
    r = parse_udeg_field(line + second + 1, len - second - 1, 3, 180000000, &lon_micro, &lon_neg);
    if (r == 1) return PARSE_BAD_LON;
    if (r == 2) return PARSE_LON_RANGE;
    double lat = (double)lat_micro / 1000000.0, lon = (double)lon_micro / 1000000.0; /* correctly rounded (F.5) */
    out->id = id;
    out->lat_deg = lat_neg ? -lat : lat;
    out->lon_deg = lon_neg ? -lon : lon;
    return PARSE_OK;
}

/* ---- loader (week 4 E05) ---- */

static ParseStatus append_row(GeoPoint **rows, size_t *n, size_t *cap, const GeoPoint *p)
{
    const size_t max_rows = GEOLAB_MAX_ROWS;
    if (*n == max_rows) return PARSE_TOO_MANY_ROWS;
    if (*n == *cap) {
        size_t new_cap;
        if (*cap == 0) new_cap = max_rows < 1024 ? max_rows : 1024;
        else new_cap = *cap > max_rows / 2 ? max_rows : *cap * 2;
        if (new_cap > SIZE_MAX / sizeof(GeoPoint)) return PARSE_OUT_OF_MEMORY;
        GeoPoint *grown = *cap == 0 ? malloc(new_cap * sizeof(GeoPoint)) : realloc(*rows, new_cap * sizeof(GeoPoint));
        if (grown == NULL) return PARSE_OUT_OF_MEMORY; /* *rows is still the valid old block */
        *rows = grown;
        *cap = new_cap;
    }
    (*rows)[(*n)++] = *p;
    return PARSE_OK;
}

static ParseStatus handle_line(char *buf, size_t len, size_t line_no, GeoPoint **rows, size_t *n, size_t *cap)
{
    buf[len] = '\0';
    if (line_no == 1) {
        return len == strlen(GEOLAB_HEADER) && memcmp(buf, GEOLAB_HEADER, len) == 0 ? PARSE_OK : PARSE_BAD_HEADER;
    }
    GeoPoint p;
    ParseStatus s = parse_record(buf, &p);
    if (s != PARSE_OK) return s;
    return append_row(rows, n, cap, &p);
}

int load_points(const char *path, GeoPoint **points, size_t *count, LoadError *err)
{
    if (path == NULL || points == NULL || count == NULL || err == NULL) return 0;
    FILE *f = fopen(path, "rb");
    if (f == NULL) {
        err->line = 0;
        err->status = PARSE_OPEN_ERROR;
        return 0;
    }
    GeoPoint *rows = NULL;
    size_t n = 0, cap = 0, len = 0, line_no = 1, fail_line = 0;
    char buf[GEOLAB_MAX_LINE + 1];
    ParseStatus status = PARSE_OK;
    for (;;) {
        int c = fgetc(f);
        if (c == EOF) {
            if (ferror(f)) status = PARSE_IO_ERROR;
            else if (len > 0) status = handle_line(buf, len, line_no, &rows, &n, &cap);
            else if (line_no == 1) status = PARSE_MISSING_HEADER;
            if (status != PARSE_OK) fail_line = line_no;
            break;
        }
        if (c == '\n') {
            status = handle_line(buf, len, line_no, &rows, &n, &cap);
            if (status != PARSE_OK) { fail_line = line_no; break; }
            ++line_no;
            len = 0;
        } else if (c == '\0') {
            status = PARSE_NUL_BYTE;
            fail_line = line_no;
            break;
        } else if (len == GEOLAB_MAX_LINE) {
            status = PARSE_LINE_TOO_LONG;
            fail_line = line_no;
            break;
        } else {
            buf[len++] = (char)c;
        }
    }
    if (fclose(f) != 0 && status == PARSE_OK) {
        status = PARSE_IO_ERROR;
        fail_line = 0;
    }
    if (status != PARSE_OK) {
        free(rows);
        err->line = fail_line;
        err->status = status;
        return 0;
    }
    *points = rows;
    *count = n;
    err->line = 0;
    err->status = PARSE_OK;
    return 1;
}

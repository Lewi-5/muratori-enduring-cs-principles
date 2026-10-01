/* E05: the loader. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

typedef struct { size_t line; ParseStatus status; } LoadError;

/* ---- copy of the E04 parser (the helpers are static and used, so -Werror is satisfied) ---- */
static int parse_id_digits(const char *s, size_t n, uint64_t *value)
{
    if (n == 0 || n > 20) return 0;
    if (s[0] == '0' && n > 1) return 0;
    uint64_t v = 0;
    for (size_t i = 0; i < n; ++i) {
        if (s[i] < '0' || s[i] > '9') return 0;
        unsigned d = (unsigned)(s[i] - '0');
        if (v > (UINT64_MAX - d) / 10) return 0;
        v = v * 10 + d;
    }
    *value = v;
    return 1;
}

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
    if (neg && m == 0) return 1;
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
    double lat = (double)lat_micro / 1000000.0, lon = (double)lon_micro / 1000000.0;
    out->id = id;
    out->lat_deg = lat_neg ? -lat : lat;
    out->lon_deg = lon_neg ? -lon : lon;
    return PARSE_OK;
}

/* ---- the loader ---- */

/* Append one accepted row, growing the array if needed. Capacity starts at min(1024, GEOLAB_MAX_ROWS) and
   doubles, clamped to GEOLAB_MAX_ROWS; because n < GEOLAB_MAX_ROWS here, growth is always possible. The doubling
   cannot overflow (cap <= max_rows / 2 in the doubling branch) and the byte count is checked against SIZE_MAX
   before realloc. The result of realloc goes to a temporary: assigning it to *rows directly would lose (leak) the
   old block if it returned NULL. */
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

/* Handle one complete line (no newline) that is buf[0..len). Line 1 must be the header exactly. */
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

/* Load a CSV v1 file. Success: returns 1, *points is the array (NULL for zero rows; the caller frees it), *count
   the row count, *err = {0, PARSE_OK}. Failure: returns 0, nothing stays allocated, *points and *count are
   unchanged, *err holds the 1-based line (0 when no line is responsible: open failure, failing fclose) and the
   status. A NULL argument returns 0 and changes nothing. The first offending byte or line decides the status. */
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
    char buf[GEOLAB_MAX_LINE + 1]; /* +1 for the terminator handle_line adds */
    ParseStatus status = PARSE_OK;
    for (;;) {
        int c = fgetc(f); /* int: EOF must be distinguishable from every byte value */
        if (c == EOF) {
            if (ferror(f)) status = PARSE_IO_ERROR;
            else if (len > 0) status = handle_line(buf, len, line_no, &rows, &n, &cap); /* final line, no newline */
            else if (line_no == 1) status = PARSE_MISSING_HEADER; /* zero-byte file */
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
            status = PARSE_LINE_TOO_LONG; /* never split a long line silently */
            fail_line = line_no;
            break;
        } else {
            buf[len++] = (char)c;
        }
    }
    if (fclose(f) != 0 && status == PARSE_OK) { /* buffered-read close failures still matter */
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

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: ex05 FILE\n");
        return 2;
    }
    GeoPoint *points = NULL;
    size_t count = 0;
    LoadError err = {0, PARSE_OK};
    if (!load_points(argv[1], &points, &count, &err)) {
        printf("error line=%zu status=%s\n", err.line, parse_status_name(err.status));
        return 1;
    }
    if (count == 0) printf("rows=0\n");
    else printf("rows=%zu first_id=%" PRIu64 " last_id=%" PRIu64 "\n", count, points[0].id, points[count - 1].id);
    free(points);
    return 0;
}

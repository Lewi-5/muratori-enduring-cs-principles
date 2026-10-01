/* E03: the generator. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

/* ---- helpers copied from E01 and E02 (kept non-static so an unused copy never trips -Werror) ---- */
uint32_t lcg_next(uint64_t *state)
{
    *state = *state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
    return (uint32_t)(*state >> 32);
}

int lcg_below(uint64_t *state, uint32_t bound, uint32_t *out)
{
    if (state == NULL || out == NULL || bound == 0) return 0;
    uint32_t threshold = (uint32_t)(UINT32_C(0) - bound) % bound;
    uint32_t r = lcg_next(state);
    while (r < threshold) r = lcg_next(state);
    *out = r % bound;
    return 1;
}

int format_udeg(int32_t value, int32_t limit, char *out, size_t out_size)
{
    if (out == NULL || (limit != 90000000 && limit != 180000000)) return 0;
    int64_t wide = value;
    int64_t magnitude = wide < 0 ? -wide : wide;
    if (magnitude > limit) return 0;
    char text[16];
    size_t n = 0;
    if (wide < 0) text[n++] = '-';
    int64_t whole = magnitude / 1000000, frac = magnitude % 1000000;
    char digits[4];
    int nd = 0;
    do { digits[nd++] = (char)('0' + whole % 10); whole /= 10; } while (whole > 0);
    while (nd > 0) text[n++] = digits[--nd];
    text[n++] = '.';
    for (int64_t scale = 100000; scale > 0; scale /= 10) text[n++] = (char)('0' + frac / scale % 10);
    text[n] = '\0';
    if (out_size < n + 1) return 0;
    memcpy(out, text, n + 1);
    return 1;
}

int format_record(uint64_t id, int32_t lat_udeg, int32_t lon_udeg, char *out, size_t out_size)
{
    if (out == NULL) return 0;
    char text[64];
    size_t n = 0;
    char digits[20];
    int nd = 0;
    uint64_t rest = id;
    do { digits[nd++] = (char)('0' + rest % 10); rest /= 10; } while (rest > 0);
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

/* Write the header and count rows to out. Returns 0, having written nothing, if out is NULL or count exceeds
   GEOLAB_MAX_ROWS; returns 0 if any write fails (fputs result and, at the end, ferror). Row i (1-based) has
   id i, then latitude and longitude each drawn into its own variable, in that order: the order of draws is
   part of the format, and separate statements keep it independent of unspecified evaluation order. */
int generate_csv(uint64_t seed, size_t count, FILE *out)
{
    if (out == NULL || count > GEOLAB_MAX_ROWS) return 0;
    if (fputs(GEOLAB_HEADER "\n", out) == EOF) return 0;
    uint64_t state = seed;
    for (size_t i = 1; i <= count; ++i) {
        uint32_t r = 0;
        if (!lcg_below(&state, 180000001u, &r)) return 0;
        int32_t lat_udeg = (int32_t)((int64_t)r - 90000000);
        if (!lcg_below(&state, 360000001u, &r)) return 0;
        int32_t lon_udeg = (int32_t)((int64_t)r - 180000000);
        char line[64];
        if (!format_record((uint64_t)i, lat_udeg, lon_udeg, line, sizeof line)) return 0;
        if (fputs(line, out) == EOF) return 0;
    }
    return ferror(out) == 0;
}

/* Generate into path (binary mode, so no newline translation on any platform). On any failure after the file
   was opened: close it, remove the partial file, return 0. If fopen itself fails nothing is removed: the path
   may name something that already exists (a directory, for instance) and this function did not create it.
   Limitation (stated, not fixed): fopen "wb" truncates an existing file, so a failure loses its old contents;
   writing a temporary file and renaming it would avoid that and is outside this week. */
int write_csv_file(const char *path, uint64_t seed, size_t count)
{
    if (path == NULL || count > GEOLAB_MAX_ROWS) return 0;
    FILE *f = fopen(path, "wb");
    if (f == NULL) return 0;
    int ok = generate_csv(seed, count, f);
    if (fflush(f) != 0) ok = 0;
    if (fclose(f) != 0) ok = 0; /* always close exactly once, and check it: buffered data may fail here */
    if (!ok) {
        remove(path); /* best effort; the failure is already being reported */
        return 0;
    }
    return 1;
}

/* ---- supplied plumbing: option parsing (not part of the exercise) ---- */
static int parse_u64(const char *s, uint64_t *out)
{
    if (*s == '\0') return 0;
    uint64_t v = 0;
    for (; *s != '\0'; ++s) {
        if (*s < '0' || *s > '9') return 0; /* no sign, no space, no locale */
        unsigned d = (unsigned)(*s - '0');
        if (v > (UINT64_MAX - d) / 10) return 0;
        v = v * 10 + d;
    }
    *out = v;
    return 1;
}

static int usage(const char *why)
{
    fprintf(stderr, "error: %s\nusage: generate --count N --seed S --out FILE\n", why);
    return 2;
}

int main(int argc, char **argv)
{
    uint64_t count = 0, seed = 0;
    const char *path = NULL;
    int have_count = 0, have_seed = 0;
    for (int i = 1; i < argc; i += 2) {
        if (i + 1 >= argc) return usage("option without a value");
        if (strcmp(argv[i], "--count") == 0) {
            if (have_count) return usage("duplicate --count");
            if (!parse_u64(argv[i + 1], &count) || count > GEOLAB_MAX_ROWS) return usage("bad --count");
            have_count = 1;
        } else if (strcmp(argv[i], "--seed") == 0) {
            if (have_seed) return usage("duplicate --seed");
            if (!parse_u64(argv[i + 1], &seed)) return usage("bad --seed");
            have_seed = 1;
        } else if (strcmp(argv[i], "--out") == 0) {
            if (path != NULL) return usage("duplicate --out");
            path = argv[i + 1];
        } else {
            return usage("unknown option");
        }
    }
    if (!have_count || !have_seed || path == NULL) return usage("missing option");
    if (!write_csv_file(path, seed, (size_t)count)) {
        fprintf(stderr, "error: could not write %s\n", path);
        return 1;
    }
    printf("generated count=%" PRIu64 " seed=%" PRIu64 " out=%s\n", count, seed, path);
    return 0;
}

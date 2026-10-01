/* E03: the generator. Learner scaffold: fill in the TODO bodies. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

/* ---- copy your own E01 and E02 solutions here (non-static, so an unused copy never trips -Werror) ---- */
uint32_t lcg_next(uint64_t *state)
{
    /* TODO: paste your E01 lcg_next. */
    (void)state;
    return 0;
}

int lcg_below(uint64_t *state, uint32_t bound, uint32_t *out)
{
    /* TODO: paste your E01 lcg_below. */
    (void)state;
    (void)bound;
    (void)out;
    return 0;
}

int format_udeg(int32_t value, int32_t limit, char *out, size_t out_size)
{
    /* TODO: paste your E02 format_udeg. */
    (void)value;
    (void)limit;
    (void)out;
    (void)out_size;
    return 0;
}

int format_record(uint64_t id, int32_t lat_udeg, int32_t lon_udeg, char *out, size_t out_size)
{
    /* TODO: paste your E02 format_record. */
    (void)id;
    (void)lat_udeg;
    (void)lon_udeg;
    (void)out;
    (void)out_size;
    return 0;
}

/* ---- the exercise. Contract: see learner/exercises.md (E03.C). ---- */
int generate_csv(uint64_t seed, size_t count, FILE *out)
{
    /* TODO: reject NULL and count > GEOLAB_MAX_ROWS having written nothing; write the header and the rows; check
       every write and ferror. Draw latitude and longitude in separate statements, latitude first. */
    (void)seed;
    (void)count;
    (void)out;
    return 0;
}

int write_csv_file(const char *path, uint64_t seed, size_t count)
{
    /* TODO: binary write mode; generate; flush; check fclose; on failure after opening, remove the partial file. */
    (void)path;
    (void)seed;
    (void)count;
    return 0;
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

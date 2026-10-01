#ifndef GEOLAB_BENCH_H
#define GEOLAB_BENCH_H
/* geolab bench (contract version 1): the measurement kernel and its summary statistics. */
#include <stddef.h>
#include <stdint.h>
#include "geolab.h"

#define BENCH_MAX_REPEAT 1000u
#define BENCH_MAX_WARMUP 100u
#define BENCH_DEFAULT_WARMUP 3u
#define BENCH_SHORT_FACTOR UINT64_C(1000) /* a sample shorter than this many clock resolutions is "short" */

typedef enum { BENCH_PARSE, BENCH_DISTANCE, BENCH_QUERY } BenchVariant;

typedef struct { size_t n; uint64_t min_ns, median_ns, max_ns; } NsSummary;

/* What one repetition computed. parse: count = rows, value = sum of identifiers modulo 2^64. distance:
   count = points, value = the bits of the left-to-right double sum of all distances. query: count = hits,
   value = h where h starts at 14695981039346656037 and h = h * 1099511628211 + id for each identifier in output
   order, modulo 2^64. Checksums are evidence that repetitions computed the same observable result, not a proof
   that every operation ran or that two results are equal. */
typedef struct { uint64_t count; uint64_t value; } BenchChecksum;

typedef struct {
    BenchVariant variant;
    const char *path;          /* parse: the file loaded in every repetition */
    const GeoPoint *points;    /* distance, query: loaded once by the caller, outside every timed region */
    size_t count;
    double lat, lon, radius_km; /* the center for distance and query; the radius for query */
    unsigned warmup, repeat;   /* repeat in [1, BENCH_MAX_REPEAT], warmup in [0, BENCH_MAX_WARMUP] */
} BenchSpec;

typedef struct {
    NsSummary summary;
    size_t points;              /* points per repetition */
    uint64_t resolution_ns;     /* clock_getres of CLOCK_MONOTONIC */
    unsigned short_samples;     /* samples < BENCH_SHORT_FACTOR * resolution_ns */
    BenchChecksum checksum;     /* of the first timed repetition; every other repetition matched it */
} BenchResult;

typedef enum {
    BENCH_OK = 0,
    BENCH_INVALID,              /* NULL pointer, bad variant, repeat/warmup out of range, invalid center or radius */
    BENCH_EMPTY,                /* zero points: nanoseconds per point would be undefined */
    BENCH_LOAD_ERROR,           /* parse variant: load_points failed (the LoadError is reported) */
    BENCH_OUT_OF_MEMORY,
    BENCH_CLOCK_ERROR,          /* a clock reading failed or went backwards */
    BENCH_CHECKSUM_MISMATCH     /* some repetition computed a different checksum from the first */
} BenchStatus;

/* Order statistics of n samples: copies samples into scratch (n elements), sorts the copy, and writes the minimum,
   the maximum and the median (for even n, lo + (hi - lo) / 2 of the two middle values, rounded down). Returns 0,
   writing nothing, when n == 0 or a pointer is NULL. samples is not modified. */
int summarize_ns(const uint64_t *samples, size_t n, uint64_t *scratch, NsSummary *out);

/* Run spec->warmup untimed and spec->repeat timed repetitions of the variant. Writes *out only on BENCH_OK.
   On BENCH_LOAD_ERROR, *load_err (if non-NULL) receives the loader's error. */
BenchStatus bench_measure(const BenchSpec *spec, BenchResult *out, LoadError *load_err);

/* Format a checksum as one token for the bench line: "COUNT:VALUE", where VALUE is the decimal identifier sum
   (parse), the double sum in "%a" form (distance) or the hash as 16 lowercase hexadecimal digits (query).
   Returns 1, or 0 (nothing written) for a NULL buffer, a bad variant or a buffer that is too small. */
int bench_format_checksum(BenchVariant variant, BenchChecksum c, char *out, size_t size);
#endif

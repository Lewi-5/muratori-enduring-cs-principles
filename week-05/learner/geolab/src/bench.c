/* bench.c: summary statistics and the measurement kernel (E04.C). bench_format_checksum and the bench subcommand
   (option handling, loading outside the timed region, and printing) are supplied plumbing; summarize_ns and
   bench_measure are yours. Contracts are in bench.h. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bench.h"
#include "cli.h"
#include "envinfo.h"
#include "monotonic.h"

/* ---- E04.C: order statistics ---- */

/* TODO: copy samples into scratch, sort the copy (qsort with a comparator that returns -1, 0 or 1; never a
   subtraction of uint64_t), and write n, min, max and the median. For even n the median is lo + (hi - lo) / 2 of
   the two middle values: prove to yourself that it cannot overflow, and why (lo + hi) / 2 can. */
int summarize_ns(const uint64_t *samples, size_t n, uint64_t *scratch, NsSummary *out)
{
    (void)samples;
    (void)n;
    (void)scratch;
    (void)out;
    return 0;
}

/* ---- supplied: the checksum as one token ---- */

int bench_format_checksum(BenchVariant variant, BenchChecksum c, char *out, size_t size)
{
    char text[96];
    int n;
    if (out == NULL) return 0;
    if (variant == BENCH_PARSE) {
        n = snprintf(text, sizeof text, "%llu:%llu", (unsigned long long)c.count, (unsigned long long)c.value);
    } else if (variant == BENCH_DISTANCE) {
        double sum;
        memcpy(&sum, &c.value, sizeof sum); /* the bits were stored with memcpy; this is not a type pun */
        n = snprintf(text, sizeof text, "%llu:%a", (unsigned long long)c.count, sum);
    } else if (variant == BENCH_QUERY) {
        n = snprintf(text, sizeof text, "%llu:%016llx", (unsigned long long)c.count, (unsigned long long)c.value);
    } else {
        return 0;
    }
    if (n < 0 || (size_t)n >= sizeof text || (size_t)n + 1 > size) return 0;
    memcpy(out, text, (size_t)n + 1);
    return 1;
}

/* ---- E04.C: the measurement kernel ---- */

/* TODO. Validate the spec first (see bench.h: repeat, warmup, variant, the center, the radius for query, every
   point for distance and query; zero points is BENCH_EMPTY). Get the clock resolution with mono_resolution_ns and
   allocate the sample and scratch arrays. Then run spec->warmup untimed and spec->repeat timed repetitions. In each
   repetition, bracket exactly the specified region with two mono_now_ns readings:
     parse:    load_points(spec->path, ...) including its allocations and fclose; checksum and free() afterwards;
     distance: the left-to-right loop of geo_distance_km calls and the double sum; the checksum is the sum's bits
               (memcpy the double into the uint64_t), computed after the second reading;
     query:    query_points as one operation; the hash and free() after the second reading.
   Compare every repetition's checksum with the first: any difference is BENCH_CHECKSUM_MISMATCH. A failed clock
   reading, or a second reading below the first, is BENCH_CLOCK_ERROR. Count short samples (a sample below
   BENCH_SHORT_FACTOR * resolution, tested without a product that can wrap). Summarize with summarize_ns. Write *out
   only on BENCH_OK and free both arrays on every path. For a parse load failure, copy the LoadError to *load_err. */
BenchStatus bench_measure(const BenchSpec *spec, BenchResult *out, LoadError *load_err)
{
    (void)spec;
    (void)out;
    (void)load_err;
    return BENCH_INVALID;
}

/* ---- the bench subcommand ---- */

static const char *variant_name(BenchVariant v)
{
    return v == BENCH_PARSE ? "parse" : v == BENCH_DISTANCE ? "distance" : "query";
}

int cmd_bench(int argc, char **argv)
{
    static const char *const names[] = {"--input", "--variant", "--repeat", "--warmup", "--lat", "--lon", "--radius-km"};
    const char *v[7];
    char why[160];
    if (!cli_scan(argc, argv, 2, names, 7, v, why, sizeof why)) return cli_usage("bench", why);
    if (v[0] == NULL || v[1] == NULL || v[2] == NULL) return cli_usage("bench", "missing option");
    BenchSpec spec;
    memset(&spec, 0, sizeof spec);
    if (strcmp(v[1], "parse") == 0) spec.variant = BENCH_PARSE;
    else if (strcmp(v[1], "distance") == 0) spec.variant = BENCH_DISTANCE;
    else if (strcmp(v[1], "query") == 0) spec.variant = BENCH_QUERY;
    else return cli_usage("bench", "bad --variant");
    uint64_t repeat = 0, warmup = BENCH_DEFAULT_WARMUP;
    if (!parse_cli_u64(v[2], BENCH_MAX_REPEAT, &repeat) || repeat == 0) return cli_usage("bench", "bad --repeat");
    if (v[3] != NULL && !parse_cli_u64(v[3], BENCH_MAX_WARMUP, &warmup)) return cli_usage("bench", "bad --warmup");
    double lat = 0.0, lon = 0.0, radius = 1000.0; /* defaults, recorded in CHECKPOINT-1.md */
    if (v[4] != NULL && !parse_cli_decimal(v[4], 1, GEOLAB_LAT_LIMIT_MICRO, &lat)) return cli_usage("bench", "bad --lat");
    if (v[5] != NULL && !parse_cli_decimal(v[5], 1, GEOLAB_LON_LIMIT_MICRO, &lon)) return cli_usage("bench", "bad --lon");
    if (v[6] != NULL && !parse_cli_decimal(v[6], 0, GEOLAB_RADIUS_LIMIT_MICRO, &radius))
        return cli_usage("bench", "bad --radius-km");
    spec.path = v[0];
    spec.lat = lat;
    spec.lon = lon;
    spec.radius_km = radius;
    spec.repeat = (unsigned)repeat;
    spec.warmup = (unsigned)warmup;

    /* distance and query: load once, outside every timed region. */
    GeoPoint *points = NULL;
    LoadError err = {0, PARSE_OK};
    if (spec.variant != BENCH_PARSE) {
        size_t count = 0;
        if (!load_points(v[0], &points, &count, &err)) {
            fprintf(stderr, "geolab: %s at line %zu in %s\n", parse_status_name(err.status), err.line, v[0]);
            return GEOLAB_EXIT_DATA;
        }
        spec.points = points;
        spec.count = count;
    }
    BenchResult r;
    BenchStatus s = bench_measure(&spec, &r, &err);
    free(points);
    switch (s) {
    case BENCH_OK: break;
    case BENCH_EMPTY: fprintf(stderr, "geolab: empty benchmark input\n"); return GEOLAB_EXIT_DATA;
    case BENCH_LOAD_ERROR:
        fprintf(stderr, "geolab: %s at line %zu in %s\n", parse_status_name(err.status), err.line, v[0]);
        return GEOLAB_EXIT_DATA;
    case BENCH_CHECKSUM_MISMATCH: fprintf(stderr, "geolab: checksum mismatch between repetitions\n"); return GEOLAB_EXIT_DATA;
    case BENCH_CLOCK_ERROR: fprintf(stderr, "geolab: clock error\n"); return GEOLAB_EXIT_DATA;
    case BENCH_OUT_OF_MEMORY: fprintf(stderr, "geolab: out of memory\n"); return GEOLAB_EXIT_DATA;
    case BENCH_INVALID: default: fprintf(stderr, "geolab: invalid benchmark input\n"); return GEOLAB_EXIT_DATA;
    }
    char checksum[96];
    if (!bench_format_checksum(spec.variant, r.checksum, checksum, sizeof checksum)) {
        fprintf(stderr, "geolab: internal error formatting the checksum\n");
        return GEOLAB_EXIT_DATA;
    }
    /* Everything is measured and checked before the first byte is printed. */
    int wrote = envinfo_print(stdout);
    wrote = wrote && printf("bench variant=%s points=%zu warmup=%u repeat=%u resolution_ns=%llu min_ns=%llu "
                            "median_ns=%llu max_ns=%llu median_ns_per_point=%.3f short_samples=%u checksum=%s\n",
                            variant_name(spec.variant), r.points, spec.warmup, spec.repeat,
                            (unsigned long long)r.resolution_ns, (unsigned long long)r.summary.min_ns,
                            (unsigned long long)r.summary.median_ns, (unsigned long long)r.summary.max_ns,
                            (double)r.summary.median_ns / (double)r.points, r.short_samples, checksum) > 0;
    if (fflush(stdout) != 0 || ferror(stdout)) wrote = 0;
    if (!wrote) {
        fprintf(stderr, "geolab: output error\n");
        return GEOLAB_EXIT_DATA;
    }
    return GEOLAB_EXIT_OK;
}

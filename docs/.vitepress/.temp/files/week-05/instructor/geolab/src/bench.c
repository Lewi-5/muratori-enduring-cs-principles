/* bench.c: summary statistics, the measurement kernel and the bench subcommand (E04). Reference solution. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bench.h"
#include "cli.h"
#include "envinfo.h"
#include "monotonic.h"

/* ---- order statistics ---- */

static int compare_u64(const void *a, const void *b)
{
    uint64_t x = *(const uint64_t *)a, y = *(const uint64_t *)b;
    return (x > y) - (x < y); /* -1, 0 or 1; a subtraction of uint64_t would wrap */
}

/* The median of an even count is lo + (hi - lo) / 2 with lo <= hi after sorting: hi - lo cannot wrap, and
   lo + (hi - lo) / 2 <= lo + (hi - lo) = hi <= UINT64_MAX, so no step can overflow. (lo + hi) / 2 overflows for
   lo = hi = UINT64_MAX. The result is floor((lo + hi) / 2): integer halves are rounded down, as specified. */
int summarize_ns(const uint64_t *samples, size_t n, uint64_t *scratch, NsSummary *out)
{
    if (samples == NULL || scratch == NULL || out == NULL || n == 0) return 0;
    memmove(scratch, samples, n * sizeof *scratch); /* n elements were allocated, so n * 8 cannot overflow */
    qsort(scratch, n, sizeof *scratch, compare_u64);
    NsSummary s;
    s.n = n;
    s.min_ns = scratch[0];
    s.max_ns = scratch[n - 1];
    if (n % 2 == 1) {
        s.median_ns = scratch[n / 2];
    } else {
        uint64_t lo = scratch[n / 2 - 1], hi = scratch[n / 2];
        s.median_ns = lo + (hi - lo) / 2;
    }
    *out = s;
    return 1;
}

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

/* ---- one repetition ---- */

/* Run the variant once. On success writes the checksum and, through *elapsed_ns, the time between the two clock
   readings. What lies between the readings:
     parse:    load_points, including its allocations, reads and fclose; the checksum and free() come after.
     distance: the left-to-right loop of geo_distance_km calls and the double sum; the checksum encoding after.
     query:    query_points (distances, selection, allocation, qsort) as one operation; hashing and free() after.
   Nothing inside a timed region prints. The checksum is consumed (compared and printed), so the work that produced
   it cannot be discarded as unused; that is evidence, not proof, that every intended operation ran (week 30). */
static BenchStatus run_once(const BenchSpec *spec, BenchChecksum *sum, uint64_t *elapsed_ns, LoadError *load_err)
{
    uint64_t t0 = 0, t1 = 0;
    BenchChecksum c = {0, 0};
    if (spec->variant == BENCH_PARSE) {
        GeoPoint *points = NULL;
        size_t count = 0;
        LoadError err = {0, PARSE_OK};
        if (!mono_now_ns(&t0)) return BENCH_CLOCK_ERROR;
        int ok = load_points(spec->path, &points, &count, &err);
        if (!mono_now_ns(&t1)) {
            free(points); /* NULL unless ok */
            return BENCH_CLOCK_ERROR;
        }
        if (!ok) {
            if (load_err != NULL) *load_err = err;
            return BENCH_LOAD_ERROR;
        }
        c.count = count;
        for (size_t i = 0; i < count; ++i) c.value += points[i].id; /* unsigned: wraps modulo 2^64 by definition */
        free(points);
    } else if (spec->variant == BENCH_DISTANCE) {
        double total = 0.0;
        if (!mono_now_ns(&t0)) return BENCH_CLOCK_ERROR;
        for (size_t i = 0; i < spec->count; ++i) {
            double d = 0.0;
            if (!geo_distance_km(spec->lat, spec->lon, spec->points[i].lat_deg, spec->points[i].lon_deg, &d))
                return BENCH_INVALID; /* unreachable: positions were validated before timing */
            total += d;
        }
        if (!mono_now_ns(&t1)) return BENCH_CLOCK_ERROR;
        c.count = spec->count;
        memcpy(&c.value, &total, sizeof total);
    } else {
        QueryHit *hits = NULL;
        size_t nhits = 0;
        if (!mono_now_ns(&t0)) return BENCH_CLOCK_ERROR;
        int ok = query_points(spec->points, spec->count, spec->lat, spec->lon, spec->radius_km, &hits, &nhits);
        if (!mono_now_ns(&t1)) {
            if (ok) free(hits);
            return BENCH_CLOCK_ERROR;
        }
        if (!ok) return BENCH_OUT_OF_MEMORY; /* inputs were validated, so allocation is the remaining cause */
        uint64_t h = UINT64_C(14695981039346656037);
        for (size_t i = 0; i < nhits; ++i) h = h * UINT64_C(1099511628211) + hits[i].id;
        c.count = nhits;
        c.value = h;
        free(hits);
    }
    if (t1 < t0) return BENCH_CLOCK_ERROR; /* CLOCK_MONOTONIC must not go backwards; if it did, say so */
    *sum = c;
    *elapsed_ns = t1 - t0;
    return BENCH_OK;
}

BenchStatus bench_measure(const BenchSpec *spec, BenchResult *out, LoadError *load_err)
{
    if (spec == NULL || out == NULL) return BENCH_INVALID;
    if (spec->repeat < 1 || spec->repeat > BENCH_MAX_REPEAT || spec->warmup > BENCH_MAX_WARMUP) return BENCH_INVALID;
    if (spec->variant == BENCH_PARSE) {
        if (spec->path == NULL) return BENCH_INVALID;
    } else if (spec->variant == BENCH_DISTANCE || spec->variant == BENCH_QUERY) {
        if (spec->points == NULL && spec->count > 0) return BENCH_INVALID;
        if (!geo_valid_position(spec->lat, spec->lon)) return BENCH_INVALID;
        if (spec->variant == BENCH_QUERY &&
            (!isfinite(spec->radius_km) || spec->radius_km < 0.0 || spec->radius_km > GEOLAB_MAX_RADIUS_KM))
            return BENCH_INVALID;
        if (spec->count == 0) return BENCH_EMPTY;
        for (size_t i = 0; i < spec->count; ++i) {
            if (!geo_valid_position(spec->points[i].lat_deg, spec->points[i].lon_deg)) return BENCH_INVALID;
        }
    } else {
        return BENCH_INVALID;
    }
    uint64_t resolution = 0;
    if (!mono_resolution_ns(&resolution)) return BENCH_CLOCK_ERROR;
    uint64_t *samples = malloc(spec->repeat * sizeof *samples); /* repeat <= 1000: the product is small */
    uint64_t *scratch = malloc(spec->repeat * sizeof *scratch);
    if (samples == NULL || scratch == NULL) {
        free(samples);
        free(scratch);
        return BENCH_OUT_OF_MEMORY;
    }
    BenchStatus status = BENCH_OK;
    BenchChecksum first = {0, 0};
    unsigned total = spec->warmup + spec->repeat;
    for (unsigned r = 0; r < total && status == BENCH_OK; ++r) {
        BenchChecksum c;
        uint64_t elapsed = 0;
        status = run_once(spec, &c, &elapsed, load_err);
        if (status != BENCH_OK) break;
        if (r == 0) first = c;
        else if (c.count != first.count || c.value != first.value) status = BENCH_CHECKSUM_MISMATCH;
        if (r >= spec->warmup) samples[r - spec->warmup] = elapsed; /* warm-up repetitions are checked, not kept */
    }
    if (status == BENCH_OK && spec->variant == BENCH_PARSE && first.count == 0) status = BENCH_EMPTY;
    BenchResult result;
    if (status == BENCH_OK && !summarize_ns(samples, spec->repeat, scratch, &result.summary)) status = BENCH_INVALID;
    if (status == BENCH_OK) {
        unsigned short_samples = 0;
        for (unsigned i = 0; i < spec->repeat; ++i) {
            /* sample < 1000 * resolution, without forming a product that could wrap */
            if (resolution > UINT64_MAX / BENCH_SHORT_FACTOR || samples[i] < resolution * BENCH_SHORT_FACTOR) ++short_samples;
        }
        result.points = (size_t)first.count;
        if (spec->variant == BENCH_QUERY || spec->variant == BENCH_DISTANCE) result.points = spec->count;
        result.resolution_ns = resolution;
        result.short_samples = short_samples;
        result.checksum = first;
        *out = result;
    }
    free(samples);
    free(scratch);
    return status;
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

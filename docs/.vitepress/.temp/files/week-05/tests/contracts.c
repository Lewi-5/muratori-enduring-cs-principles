/* Week-5 C contract suites. One suite per module: compile with -DMODULE_CLI, -DMODULE_QUERY or -DMODULE_BENCH and
   -DSOURCE="path/to/module.c". The module source is #included here (so fault-injection macros apply to it alone)
   and the executable is linked with every OTHER geolab object except main.o. Files from the oracle are read from
   ORACLE_DIR. Run through tests/check.py. */
#include <assert.h>
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "platform.h"

#ifndef ORACLE_DIR
#error "ORACLE_DIR is required"
#endif
#ifndef TEST_TMPDIR
#error "TEST_TMPDIR is required"
#endif

/* ---- fault injection, applied to the included module only ---- */
long fail_malloc_at = -1; /* fail the n-th malloc call (0-based) after arming; -1 = never */
long malloc_calls = 0;
void *test_malloc(size_t n);
void arm_malloc(long at);
void *test_malloc(size_t n)
{
    long k = malloc_calls++;
    if (fail_malloc_at >= 0 && k == fail_malloc_at) return NULL;
    return malloc(n);
}
void arm_malloc(long at) { fail_malloc_at = at; malloc_calls = 0; }

#if defined(MODULE_BENCH)
/* The perturbation hook (E04): inside bench.c every call to geo_distance_km goes through this wrapper. When armed,
   calls number [perturb_from, perturb_to) return a distance changed in its last bit, which models a repetition
   that computed something different. */
#include "geolab.h"
static long perturb_from = -1, perturb_to = -1, distance_calls = 0;
int perturbed_distance(double a, double b, double c, double d, double *out);
int perturbed_distance(double a, double b, double c, double d, double *out)
{
    long k = distance_calls++;
    int ok = geo_distance_km(a, b, c, d, out);
    if (ok && k >= perturb_from && k < perturb_to) *out = nextafter(*out, INFINITY);
    return ok;
}
#define geo_distance_km perturbed_distance
#endif

#define malloc test_malloc
#include SOURCE
#undef malloc
#if defined(MODULE_BENCH)
#undef geo_distance_km
#endif

FILE *open_oracle(const char *name)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/%s", ORACLE_DIR, name);
    FILE *f = fopen(path, "r");
    if (f == NULL) {
        fprintf(stderr, "cannot open %s\n", path);
        exit(2);
    }
    return f;
}

GeoPoint *load_oracle_csv(const char *name, size_t *count)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/%s", ORACLE_DIR, name);
    GeoPoint *p = NULL;
    LoadError err;
    if (!load_points(path, &p, count, &err)) {
        fprintf(stderr, "load %s failed: %s line %zu\n", path, parse_status_name(err.status), err.line);
        exit(2);
    }
    return p;
}

/* ======================================================================================================== CLI (E01) */
#if defined(MODULE_CLI)
#include "cli.h"
static void check_decimal(const char *text, int allow_sign, int64_t limit, int accept, double want)
{
    double out = 12345.678; /* sentinel */
    int ok = parse_cli_decimal(text, allow_sign, limit, &out);
    if (ok != accept) {
        fprintf(stderr, "parse_cli_decimal(\"%s\", %d, %" PRId64 ") returned %d, expected %d\n", text, allow_sign, limit, ok, accept);
        exit(1);
    }
    if (!accept) {
        assert(out == 12345.678); /* unchanged on rejection */
        return;
    }
#if GEO_IEC559
    /* Annex F: the result is the correctly rounded value, which the oracle computed with exact rationals. */
    if (memcmp(&out, &want, sizeof out) != 0) {
        fprintf(stderr, "parse_cli_decimal(\"%s\") = %a, expected %a\n", text, out, want);
        exit(1);
    }
#else
    (void)want;
    assert(fabs(out - want) <= fabs(want) * DBL_EPSILON);
#endif
}

int main(void)
{
    /* The plan's named boundaries, then the oracle's generated corpus. */
    static const struct { const char *t; int sign; int64_t lim; int ok; double v; } cases[] = {
        {"90", 1, 90000000, 1, 90.0}, {"90.000000", 1, 90000000, 1, 90.0}, {"90.000001", 1, 90000000, 0, 0},
        {"-90", 1, 90000000, 1, -90.0}, {"-180", 1, 180000000, 1, -180.0}, {"180.000001", 1, 180000000, 0, 0},
        {"0.5", 1, 90000000, 1, 0.5}, {".5", 1, 90000000, 0, 0}, {"5.", 1, 90000000, 0, 0}, {"1e2", 1, 90000000, 0, 0},
        {"+1", 1, 90000000, 0, 0}, {"01", 1, 90000000, 0, 0}, {"00", 1, 90000000, 0, 0}, {"1.1234567", 1, 90000000, 0, 0},
        {"12345678901234567890", 1, 180000000, 0, 0}, {"12345678901234567890", 0, INT64_C(1000000000000000), 0, 0},
        {"-0.0", 1, 90000000, 1, 0.0}, {"-0", 1, 90000000, 1, 0.0}, {"", 1, 90000000, 0, 0}, {"-", 1, 90000000, 0, 0},
        {"nan", 1, 90000000, 0, 0}, {"inf", 1, 90000000, 0, 0}, {" 1", 1, 90000000, 0, 0}, {"1 ", 1, 90000000, 0, 0},
        {"0x10", 1, 90000000, 0, 0}, {"-1", 0, 100000000000, 0, 0}, {"100000", 0, 100000000000, 1, 100000.0},
        {"100000.000001", 0, 100000000000, 0, 0}, {"0", 0, 0, 1, 0.0}, {"0.000001", 0, 0, 0, 0},
        {"-33.8688", 1, 90000000, 1, -33.8688}, {"0.1", 0, 100000000000, 1, 0.1}, {"1..2", 1, 90000000, 0, 0},
        {"1.-2", 1, 90000000, 0, 0}, {"--1", 1, 90000000, 0, 0}, {"999999999999999", 0, INT64_C(1000000000000000), 0, 0},
        {"1000000000", 0, INT64_C(1000000000000000), 1, 1e9}, {"1000000000.000001", 0, INT64_C(1000000000000000), 0, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i)
        check_decimal(cases[i].t, cases[i].sign, cases[i].lim, cases[i].ok, cases[i].v);
    /* -0.0 must come back as +0.0 */
    double z = -1.0;
    assert(parse_cli_decimal("-0.000", 1, 90000000, &z) == 1 && z == 0.0 && !signbit(z));
    /* invalid arguments leave the output unchanged */
    double s = 7.0;
    assert(parse_cli_decimal(NULL, 1, 90000000, &s) == 0 && s == 7.0);
    assert(parse_cli_decimal("1", 1, 90000000, NULL) == 0);
    assert(parse_cli_decimal("1", 1, -1, &s) == 0 && s == 7.0);
    assert(parse_cli_decimal("1", 1, INT64_C(1000000000000001), &s) == 0 && s == 7.0);
    assert(parse_cli_decimal("1", 1, INT64_MAX, &s) == 0 && s == 7.0);

    FILE *f = open_oracle("cli_cases.txt");
    char text[256], hex[64];
    int sign;
    long long lim;
    size_t n = 0;
    while (fscanf(f, "%255s %d %lld %63s", text, &sign, &lim, hex) == 4) {
        const char *t = strcmp(text, "<empty>") == 0 ? "" : text;
        if (strcmp(hex, "REJECT") == 0) check_decimal(t, sign, (int64_t)lim, 0, 0.0);
        else check_decimal(t, sign, (int64_t)lim, 1, strtod(hex, NULL)); /* the harness may use strtod: "%a" text */
        ++n;
    }
    fclose(f);
    assert(n > 1000);

    /* supplied plumbing still behaves */
    uint64_t u = 9;
    assert(parse_cli_u64("18446744073709551615", UINT64_MAX, &u) == 1 && u == UINT64_MAX);
    assert(parse_cli_u64("18446744073709551616", UINT64_MAX, &u) == 0 && u == UINT64_MAX);
    printf("gated checks %s\n", GEO_IEC559 ? "ran (Annex F exact comparison)" : "skipped (tolerance comparison)");
    printf("cli contract passed (%zu oracle cases)\n", n);
    return 0;
}
#endif

/* ====================================================================================================== query (E02) */
#if defined(MODULE_QUERY)
static void expect_rejected(const GeoPoint *p, size_t count, double lat, double lon, double r)
{
    QueryHit sentinel_hit = {99, 99.0};
    QueryHit *hits = &sentinel_hit;
    size_t nhits = 4242;
    assert(query_points(p, count, lat, lon, r, &hits, &nhits) == 0);
    assert(hits == &sentinel_hit && nhits == 4242); /* outputs unchanged */
}

/* The result must be exactly the points with distance <= r, sorted by (distance, id) using the same distances. */
static void check_query(const GeoPoint *p, size_t count, double lat, double lon, double r, FILE *printed)
{
    QueryHit *hits = NULL;
    size_t nhits = 99;
    assert(query_points(p, count, lat, lon, r, &hits, &nhits) == 1);
    size_t expect = 0;
    for (size_t i = 0; i < count; ++i) {
        double d = 0.0;
        assert(geo_distance_km(lat, lon, p[i].lat_deg, p[i].lon_deg, &d));
        if (d <= r) ++expect;
    }
    assert(nhits == expect);
    assert((nhits == 0) == (hits == NULL));
    for (size_t k = 0; k < nhits; ++k) {
        if (k > 0) {
            int ordered = hits[k - 1].distance_km < hits[k].distance_km ||
                          (hits[k - 1].distance_km == hits[k].distance_km && hits[k - 1].id <= hits[k].id);
            assert(ordered);
        }
        assert(hits[k].distance_km <= r);
        if (printed != NULL) fprintf(printed, "%a %.6f\n", hits[k].distance_km, hits[k].distance_km);
    }
    /* each hit's distance is the value geo_distance_km gives for some point with that id */
    for (size_t k = 0; k < nhits && k < 2000; ++k) {
        int found = 0;
        for (size_t i = 0; i < count && !found; ++i) {
            if (p[i].id != hits[k].id) continue;
            double d = 0.0;
            assert(geo_distance_km(lat, lon, p[i].lat_deg, p[i].lon_deg, &d));
            found = memcmp(&d, &hits[k].distance_km, sizeof d) == 0;
        }
        assert(found);
    }
    free(hits);
}

int main(void)
{
    size_t n1k = 0, n100k = 0;
    GeoPoint *d1k = load_oracle_csv("d1k.csv", &n1k);
    GeoPoint *d100k = load_oracle_csv("d100k.csv", &n100k);
    assert(n1k == 1000 && n100k == 100000);
    char path[1024];
    snprintf(path, sizeof path, "%s/printed_values.txt", TEST_TMPDIR);
    FILE *printed = fopen(path, "w");
    assert(printed != NULL);
    static const double centers[][2] = {{0, 0}, {90, 0}, {-90, 0}, {10, 179.5}, {0, -180}, {-33.8688, 151.2093}};
    static const double radii[] = {0.0, 250.0, 2500.0, 20016.0};
    for (size_t c = 0; c < sizeof centers / sizeof centers[0]; ++c)
        for (size_t r = 0; r < sizeof radii / sizeof radii[0]; ++r) {
            check_query(d1k, n1k, centers[c][0], centers[c][1], radii[r], printed);
            if (r != 3) check_query(d100k, n100k, centers[c][0], centers[c][1], radii[r], c == 0 ? printed : NULL);
        }
    fclose(printed);

    /* exact tie: identical coordinates, different identifiers -> identifier order, whatever the input order */
    GeoPoint tie[] = {{7, 1.0, 1.0}, {3, 1.0, 1.0}, {9, -2.0, 0.5}, {5, 1.0, 1.0}};
    QueryHit *h = NULL;
    size_t nh = 0;
    assert(query_points(tie, 4, 0.0, 0.0, 500.0, &h, &nh) == 1 && nh == 4);
    assert(h[0].id == 3 && h[1].id == 5 && h[2].id == 7 && h[3].id == 9);
    assert(h[0].distance_km == h[1].distance_km && h[1].distance_km == h[2].distance_km);
    free(h);
    /* printed tie in reverse identifier order: equal at six decimals, but id 2 is nearer and must stay first */
    GeoPoint pt[] = {{1, 0.0, 1.0}, {2, 0.600366, 0.79974}};
    assert(query_points(pt, 2, 0.0, 0.0, 112.0, &h, &nh) == 1 && nh == 2);
    char a[64], b[64];
    snprintf(a, sizeof a, "%.6f", h[0].distance_km);
    snprintf(b, sizeof b, "%.6f", h[1].distance_km);
    assert(strcmp(a, b) == 0 && h[0].id == 2 && h[1].id == 1 && h[0].distance_km < h[1].distance_km);
    free(h);
    /* inclusive boundary, through the C API: radius equal to a computed distance includes it; the next double below
       excludes it (the six-decimal command line could not express that radius) */
    double d = 0.0;
    assert(geo_distance_km(0.0, 0.0, d1k[17].lat_deg, d1k[17].lon_deg, &d) && d > 0.0);
    assert(query_points(&d1k[17], 1, 0.0, 0.0, d, &h, &nh) == 1 && nh == 1 && h[0].id == d1k[17].id);
    free(h);
    assert(query_points(&d1k[17], 1, 0.0, 0.0, nextafter(d, 0.0), &h, &nh) == 1 && nh == 0 && h == NULL);
    /* radius 0 at an existing point */
    GeoPoint same[] = {{4, 12.5, -45.25}, {5, 12.5, -45.250001}};
    assert(query_points(same, 2, 12.5, -45.25, 0.0, &h, &nh) == 1 && nh == 1 && h[0].id == 4 && h[0].distance_km == 0.0);
    free(h);
    /* empty input and an empty result */
    h = (QueryHit *)&nh;
    assert(query_points(NULL, 0, 0.0, 0.0, 10.0, &h, &nh) == 1 && nh == 0 && h == NULL);
    assert(query_points(tie, 4, -60.0, 100.0, 10.0, &h, &nh) == 1 && nh == 0 && h == NULL);
    /* rejections leave outputs unchanged */
    GeoPoint bad[] = {{1, 0.0, 0.0}, {2, 91.0, 0.0}};
    expect_rejected(bad, 2, 0.0, 0.0, 100.0);
    GeoPoint badnan[] = {{1, NAN, 0.0}};
    expect_rejected(badnan, 1, 0.0, 0.0, 100.0);
    expect_rejected(NULL, 3, 0.0, 0.0, 100.0);
    expect_rejected(NULL, 0, 95.0, 0.0, 10.0);  /* an empty dataset still has its center and radius validated */
    expect_rejected(NULL, 0, 0.0, 0.0, -1.0);
    expect_rejected(tie, 4, 90.000001, 0.0, 100.0);
    expect_rejected(tie, 4, 0.0, -180.000001, 100.0);
    expect_rejected(tie, 4, NAN, 0.0, 100.0);
    expect_rejected(tie, 4, 0.0, 0.0, -1.0);
    expect_rejected(tie, 4, 0.0, 0.0, 100000.000001);
    expect_rejected(tie, 4, 0.0, 0.0, INFINITY);
    expect_rejected(tie, 4, 0.0, 0.0, NAN);
    assert(query_points(tie, 4, 0.0, 0.0, 1.0, NULL, &nh) == 0);
    assert(query_points(tie, 4, 0.0, 0.0, 1.0, &h, NULL) == 0);
    assert(query_points(tie, 4, 0.0, 0.0, 100000.0, &h, &nh) == 1 && nh == 4);
    free(h);
    /* allocation failure at every allocation the query makes: rejected, outputs unchanged, nothing leaked
       (the sanitizer build checks the leak) */
    for (long k = 0; k < 4; ++k) {
        arm_malloc(k);
        QueryHit sentinel = {1, 1.0};
        QueryHit *hh = &sentinel;
        size_t nn = 77;
        int ok = query_points(tie, 4, 0.0, 0.0, 500.0, &hh, &nn);
        long used = malloc_calls;
        arm_malloc(-1);
        if (k < used) assert(ok == 0 && hh == &sentinel && nn == 77);
        else if (ok) free(hh);
    }
    /* the comparator: -1/0/1, antisymmetric, and zero only for equal (distance, id) */
    QueryHit x = {1, 2.0}, y = {2, 2.0}, z = {1, 3.0};
    assert(query_hit_compare(&x, &y) == -1 && query_hit_compare(&y, &x) == 1 && query_hit_compare(&x, &x) == 0);
    assert(query_hit_compare(&y, &z) == -1 && query_hit_compare(&z, &y) == 1);
    QueryHit big = {UINT64_MAX, 1e300}, small = {0, -1e300};
    assert(query_hit_compare(&big, &small) == 1 && query_hit_compare(&small, &big) == -1);
    free(d1k);
    free(d100k);
    printf("gated checks %s\n", GEO_IEC559 ? "ran" : "skipped");
    printf("query contract passed\n");
    return 0;
}
#endif

/* ====================================================================================================== bench (E04) */
#if defined(MODULE_BENCH)
static void check_summary(const uint64_t *v, size_t n, uint64_t mn, uint64_t med, uint64_t mx)
{
    uint64_t copy[16], scratch[16];
    memcpy(copy, v, n * sizeof *v);
    NsSummary s;
    assert(summarize_ns(v, n, scratch, &s) == 1);
    assert(s.n == n && s.min_ns == mn && s.median_ns == med && s.max_ns == mx);
    assert(memcmp(copy, v, n * sizeof *v) == 0); /* samples are not modified */
}

static BenchSpec spec_for(BenchVariant v, const GeoPoint *p, size_t n)
{
    BenchSpec s;
    memset(&s, 0, sizeof s);
    s.variant = v;
    s.points = p;
    s.count = n;
    s.lat = 10.0;
    s.lon = 20.0;
    s.radius_km = 3000.0;
    s.warmup = 2;
    s.repeat = 5;
    return s;
}

int main(void)
{
    /* order statistics, hand-computed */
    const uint64_t one[] = {42};
    check_summary(one, 1, 42, 42, 42);
    const uint64_t odd[] = {50, 10, 40, 20, 30};
    check_summary(odd, 5, 10, 30, 50);
    const uint64_t even[] = {4, 1, 3, 2};
    check_summary(even, 4, 1, 2, 4); /* (2 + 3) / 2 = 2.5, rounded down */
    const uint64_t even2[] = {10, 13};
    check_summary(even2, 2, 10, 11, 13);
    const uint64_t huge[] = {UINT64_MAX, UINT64_MAX};
    check_summary(huge, 2, UINT64_MAX, UINT64_MAX, UINT64_MAX); /* (lo + hi) / 2 would wrap to UINT64_MAX / 2 */
    const uint64_t huge2[] = {UINT64_MAX - 1, UINT64_MAX, 0, 7};
    check_summary(huge2, 4, 0, UINT64_MAX / 2 + 3, UINT64_MAX); /* middle values 7 and UINT64_MAX - 1 */
    const uint64_t dup[] = {5, 5, 5, 1, 9, 5};
    check_summary(dup, 6, 1, 5, 9);
    NsSummary keep = {77, 1, 2, 3};
    uint64_t scratch[4];
    assert(summarize_ns(odd, 0, scratch, &keep) == 0 && keep.n == 77 && keep.median_ns == 2);
    assert(summarize_ns(NULL, 3, scratch, &keep) == 0 && keep.n == 77);
    assert(summarize_ns(odd, 3, NULL, &keep) == 0 && keep.n == 77);
    assert(summarize_ns(odd, 3, scratch, NULL) == 0);

    size_t n = 0;
    GeoPoint *pts = load_oracle_csv("d1k.csv", &n);
    /* distance: the checksum is the bits of the left-to-right sum, reproduced here independently */
    double total = 0.0;
    for (size_t i = 0; i < n; ++i) {
        double d = 0.0;
        assert(geo_distance_km(10.0, 20.0, pts[i].lat_deg, pts[i].lon_deg, &d));
        total += d;
    }
    uint64_t bits;
    memcpy(&bits, &total, sizeof bits);
    BenchSpec s = spec_for(BENCH_DISTANCE, pts, n);
    BenchResult r;
    assert(bench_measure(&s, &r, NULL) == BENCH_OK);
    assert(r.checksum.count == n && r.checksum.value == bits && r.points == n && r.summary.n == 5);
    assert(r.summary.min_ns <= r.summary.median_ns && r.summary.median_ns <= r.summary.max_ns && r.short_samples <= 5);
    assert(r.resolution_ns > 0);
    /* query: count and order-sensitive hash of the identifiers in output order */
    QueryHit *hits = NULL;
    size_t nhits = 0;
    assert(query_points(pts, n, 10.0, 20.0, 3000.0, &hits, &nhits));
    uint64_t hsh = UINT64_C(14695981039346656037);
    for (size_t i = 0; i < nhits; ++i) hsh = hsh * UINT64_C(1099511628211) + hits[i].id;
    free(hits);
    s = spec_for(BENCH_QUERY, pts, n);
    assert(bench_measure(&s, &r, NULL) == BENCH_OK && r.checksum.count == nhits && r.checksum.value == hsh);
    char text[96];
    assert(bench_format_checksum(BENCH_QUERY, r.checksum, text, sizeof text));
    char want[96];
    snprintf(want, sizeof want, "%zu:%016" PRIx64, nhits, hsh);
    assert(strcmp(text, want) == 0);
    assert(bench_format_checksum(BENCH_QUERY, r.checksum, text, strlen(want)) == 0); /* one byte too small */
    /* parse: rows and identifier sum */
    char path[1024];
    snprintf(path, sizeof path, "%s/d1k.csv", ORACLE_DIR);
    s = spec_for(BENCH_PARSE, NULL, 0);
    s.path = path;
    assert(bench_measure(&s, &r, NULL) == BENCH_OK && r.checksum.count == 1000 && r.checksum.value == 500500 && r.points == 1000);
    /* a missing file: the loader's error comes back */
    LoadError le = {5, PARSE_OK};
    s.path = TEST_TMPDIR "/does-not-exist.csv";
    assert(bench_measure(&s, &r, &le) == BENCH_LOAD_ERROR && le.status == PARSE_OPEN_ERROR && le.line == 0);
    /* header-only input: zero points is an error for every variant */
    snprintf(path, sizeof path, "%s/header_only.csv", ORACLE_DIR);
    s.path = path;
    BenchResult untouched;
    memset(&untouched, 0xAB, sizeof untouched);
    memcpy(&r, &untouched, sizeof r);
    assert(bench_measure(&s, &r, NULL) == BENCH_EMPTY && memcmp(&r, &untouched, sizeof r) == 0);
    s = spec_for(BENCH_DISTANCE, NULL, 0);
    assert(bench_measure(&s, &r, NULL) == BENCH_EMPTY);
    /* the perturbation hook: the second repetition computes a different sum -> mismatch, output unchanged */
    s = spec_for(BENCH_DISTANCE, pts, n);
    perturb_from = (long)n;
    perturb_to = 2 * (long)n;
    distance_calls = 0;
    memcpy(&r, &untouched, sizeof r);
    assert(bench_measure(&s, &r, NULL) == BENCH_CHECKSUM_MISMATCH && memcmp(&r, &untouched, sizeof r) == 0);
    /* ... and in a later timed repetition (after the warm-up) */
    perturb_from = 5 * (long)n;
    perturb_to = 6 * (long)n;
    distance_calls = 0;
    assert(bench_measure(&s, &r, NULL) == BENCH_CHECKSUM_MISMATCH);
    perturb_from = perturb_to = -1;
    /* invalid specifications */
    BenchSpec bad = spec_for(BENCH_DISTANCE, pts, n);
    bad.repeat = 0;
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad.repeat = BENCH_MAX_REPEAT + 1;
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for(BENCH_DISTANCE, pts, n);
    bad.warmup = BENCH_MAX_WARMUP + 1;
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for(BENCH_QUERY, pts, n);
    bad.radius_km = -1.0;
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for(BENCH_DISTANCE, pts, n);
    bad.lat = 95.0;
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for(BENCH_DISTANCE, NULL, 3);
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for((BenchVariant)7, pts, n);
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    bad = spec_for(BENCH_PARSE, NULL, 0);
    assert(bench_measure(&bad, &r, NULL) == BENCH_INVALID);
    assert(bench_measure(NULL, &r, NULL) == BENCH_INVALID);
    s = spec_for(BENCH_DISTANCE, pts, n);
    assert(bench_measure(&s, NULL, NULL) == BENCH_INVALID);
    GeoPoint badpts[] = {{1, 0.0, 0.0}, {2, 0.0, 200.0}};
    s = spec_for(BENCH_DISTANCE, badpts, 2);
    assert(bench_measure(&s, &r, NULL) == BENCH_INVALID);
    /* allocation failure: the first two allocations are the sample arrays */
    s = spec_for(BENCH_DISTANCE, pts, n);
    for (long k = 0; k < 2; ++k) {
        arm_malloc(k);
        memcpy(&r, &untouched, sizeof r);
        BenchStatus st = bench_measure(&s, &r, NULL);
        arm_malloc(-1);
        assert(st == BENCH_OUT_OF_MEMORY && memcmp(&r, &untouched, sizeof r) == 0);
    }
    /* the distance checksum formats as COUNT:%a */
    BenchChecksum c = {3, 0};
    double three = 3.5;
    memcpy(&c.value, &three, sizeof three);
    assert(bench_format_checksum(BENCH_DISTANCE, c, text, sizeof text) && strcmp(text, "3:0x1.cp+1") == 0);
    c.value = 12;
    assert(bench_format_checksum(BENCH_PARSE, c, text, sizeof text) && strcmp(text, "3:12") == 0);
    assert(bench_format_checksum((BenchVariant)9, c, text, sizeof text) == 0);
    free(pts);
    printf("bench contract passed\n");
    return 0;
}
#endif

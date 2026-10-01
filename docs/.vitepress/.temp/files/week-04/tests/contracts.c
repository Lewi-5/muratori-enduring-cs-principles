/* C contract suites. Each exercise source is included with its main renamed. Expected values come from three
   places only: exactly representable selected results (including integer arithmetic and special IEEE cases), files written by the
   independent Python oracle in tests/check.py (ORACLE_DIR), and stated bounds from tests/tolerances.h. Nothing
   asserts a libm result bit-for-bit. Library failures are injected by wrapping functions in THIS translation
   unit only (macros defined around the #include of the exercise source), never in the learner executables. */
#if EXERCISE == 3 || EXERCISE == 5
#define _POSIX_C_SOURCE 200809L /* only for stat() in the tests; the exercise builds themselves are plain C11 */
#endif
#include <assert.h>
#include <float.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if EXERCISE == 3 || EXERCISE == 5
#include <sys/stat.h>
#endif
#include "platform.h"
#include "tolerances.h"
#include "geolab_types.h"

#if !defined(TEST_TMPDIR) || !defined(ORACLE_DIR) || !defined(FIXTURE_DIR)
#error "compile with -DTEST_TMPDIR=... -DORACLE_DIR=... -DFIXTURE_DIR=... (see tests/check.py)"
#endif

/* ------------------------------------------------------------------------------------------------------ */
/* Fault-injection wrappers, active only around the included source                                        */
/* ------------------------------------------------------------------------------------------------------ */
#if EXERCISE == 3
static int fail_close_next, fail_flush_next;
static int remove_calls;
static char removed_path[512];
static int test_fflush(FILE *f)
{
    int status = fflush(f);
    return fail_flush_next ? EOF : status;
}
static int test_fclose(FILE *f)
{
    int status = fclose(f); /* always release the real stream */
    return fail_close_next ? EOF : status;
}
static int test_remove(const char *path)
{
    ++remove_calls;
    snprintf(removed_path, sizeof removed_path, "%s", path);
    return remove(path);
}
#define fclose test_fclose
#define fflush test_fflush
#define remove test_remove
#elif EXERCISE == 5
static long live_blocks;      /* blocks obtained through the wrapped allocators and not yet freed */
static int alloc_calls, fail_alloc_at; /* fail the k-th allocation call (1-based); 0 = never */
static size_t alloc_sizes[16];
static int read_calls, fail_read_at;   /* make the k-th fgetc fail: return EOF with the error flag set */
static int read_error_flag;
static int fail_close_next, close_calls;
static void *test_malloc(size_t n)
{
    ++alloc_calls;
    if (alloc_calls <= 16) alloc_sizes[alloc_calls - 1] = n;
    if (fail_alloc_at == alloc_calls) return NULL;
    void *p = malloc(n);
    if (p != NULL) ++live_blocks;
    return p;
}
static void *test_realloc(void *old, size_t n)
{
    ++alloc_calls;
    if (alloc_calls <= 16) alloc_sizes[alloc_calls - 1] = n;
    if (fail_alloc_at == alloc_calls) return NULL; /* the old block stays valid, as for a real failure */
    void *p = realloc(old, n);
    if (p != NULL && old == NULL) ++live_blocks;
    return p;
}
static void test_free(void *p)
{
    if (p != NULL) --live_blocks;
    free(p);
}
static int test_fgetc(FILE *f)
{
    ++read_calls;
    if (fail_read_at != 0 && read_calls == fail_read_at) {
        read_error_flag = 1;
        return EOF;
    }
    return fgetc(f);
}
static int test_ferror(FILE *f) { return read_error_flag || ferror(f); }
static int test_fclose(FILE *f)
{
    ++close_calls;
    int status = fclose(f);
    return fail_close_next ? EOF : status;
}
#define malloc test_malloc
#define realloc test_realloc
#define free test_free
#define fgetc test_fgetc
#define ferror test_ferror
#define fclose test_fclose
#endif

#define main exercise_main
#include SOURCE
#undef main

#if EXERCISE == 3
#undef fclose
#undef fflush
#undef remove
#elif EXERCISE == 5
#undef malloc
#undef realloc
#undef free
#undef fgetc
#undef ferror
#undef fclose
#endif

/* ------------------------------------------------------------------------------------------------------ */
/* Helpers                                                                                                 */
/* ------------------------------------------------------------------------------------------------------ */
#if EXERCISE == 1 || (EXERCISE == 3 && GEOLAB_MAX_ROWS > 1000) || EXERCISE == 4 || (EXERCISE == 5 && GEOLAB_MAX_ROWS > 4096) || EXERCISE == 7
static FILE *open_oracle(const char *name)
{
    char path[600];
    snprintf(path, sizeof path, "%s/%s", ORACLE_DIR, name);
    FILE *f = fopen(path, "rb");
    if (f == NULL) fprintf(stderr, "missing oracle file %s\n", path);
    assert(f != NULL);
    return f;
}
#endif

#if EXERCISE == 3
static char *read_stream(FILE *f, size_t *len)
{
    size_t cap = 4096, n = 0;
    char *buf = malloc(cap);
    assert(buf != NULL);
    int c;
    while ((c = fgetc(f)) != EOF) {
        if (n + 1 >= cap) {
            cap *= 2;
            buf = realloc(buf, cap);
            assert(buf != NULL);
        }
        buf[n++] = (char)c;
    }
    buf[n] = '\0';
    *len = n;
    return buf;
}

#if GEOLAB_MAX_ROWS > 1000
static char *read_file(const char *path, size_t *len)
{
    FILE *f = fopen(path, "rb");
    if (f == NULL) return NULL;
    char *buf = read_stream(f, len);
    fclose(f);
    return buf;
}
#endif
#endif

/* ================================================================== E01 */
#if EXERCISE == 1
static void check_oracle_streams(void)
{
    static const uint64_t seeds[] = {0, 1, UINT64_MAX};
    static const uint32_t bounds[] = {1, 3, 7, 3000000000u, UINT32_MAX};
    for (int si = 0; si < 3; ++si) {
        char name[64];
        snprintf(name, sizeof name, "lcg_%d.txt", si);
        FILE *f = open_oracle(name);
        uint64_t st = seeds[si];
        for (int i = 0; i < 1000; ++i) {
            unsigned want = 0;
            assert(fscanf(f, "%x", &want) == 1);
            uint32_t got = lcg_next(&st);
            assert(got == want);
        }
        fclose(f);
        for (int bi = 0; bi < 5; ++bi) {
            snprintf(name, sizeof name, "below_%d_%" PRIu32 ".txt", si, bounds[bi]);
            f = open_oracle(name);
            uint64_t want_state = 0;
            assert(fscanf(f, "%" SCNx64, &want_state) == 1);
            st = seeds[si];
            for (int i = 0; i < 200; ++i) {
                uint32_t want = 0, got = 0;
                assert(fscanf(f, "%" SCNu32, &want) == 1);
                assert(lcg_below(&st, bounds[bi], &got) == 1);
                assert(got == want && got < bounds[bi]);
            }
            assert(st == want_state); /* the same number of raw draws was consumed, including rejected ones */
            fclose(f);
        }
    }
}

/* Draws that land exactly on the rejection threshold (from the oracle): threshold - 1 is rejected and one more draw
   is consumed; threshold and threshold + 1 are accepted. This is what separates "r < threshold" from "r <= threshold". */
static void check_threshold_edges(void)
{
    FILE *f = open_oracle("edge_below.txt");
    uint32_t bound = 0, want = 0;
    uint64_t s_prev = 0, s_final = 0;
    int cases = 0;
    while (fscanf(f, "%" SCNu32 " %" SCNu64 " %" SCNu32 " %" SCNu64, &bound, &s_prev, &want, &s_final) == 4) {
        uint32_t got = 0;
        uint64_t st = s_prev;
        assert(lcg_below(&st, bound, &got) == 1 && got == want && st == s_final);
        ++cases;
    }
    fclose(f);
    assert(cases >= 15);
}

static void check_rejections(void)
{
    uint64_t st = 12345;
    uint32_t out = 777;
    assert(!lcg_below(&st, 0, &out) && st == 12345 && out == 777); /* bound 0: nothing changes */
    assert(!lcg_below(NULL, 5, &out) && !lcg_below(&st, 5, NULL) && st == 12345 && out == 777);
    assert(lcg_below(&st, 1, &out) && out == 0 && st != 12345); /* bound 1 still consumes exactly one draw */
    uint64_t one = 12345;
    (void)lcg_next(&one);
    assert(st == one);
}

static void check_distribution(void)
{
    uint64_t st = 2024;
    long counts[3] = {0, 0, 0};
    for (int i = 0; i < 30000; ++i) {
        uint32_t v = 99;
        assert(lcg_below(&st, 3, &v) && v < 3);
        ++counts[v];
    }
    for (int k = 0; k < 3; ++k) assert(labs(counts[k] - 10000) <= 500); /* within 5% of the mean */
    /* bound 3e9 rejects about 30% of raw draws: count raw draws consumed per accepted value */
    st = 99;
    long raw = 0;
    for (int i = 0; i < 100000; ++i) {
        uint64_t before = st, probe = st, after;
        uint32_t v = 0;
        assert(lcg_below(&st, 3000000000u, &v) && v < 3000000000u);
        after = st;
        long steps = 0;
        while (probe != after) {
            (void)lcg_next(&probe);
            ++steps;
            assert(steps < 10000 && probe != before); /* the retry loop stopped after finitely many draws */
        }
        raw += steps;
    }
    double per_value = (double)raw / 100000.0; /* expected 1 / (1 - 1294967296/2^32) = 1.4316 */
    assert(per_value > 1.40 && per_value < 1.46);
}
#endif

/* ================================================================== E02 */
#if EXERCISE == 2
static void check_udeg_exact(void)
{
    char buf[32];
    struct { int32_t v, limit; const char *text; } cases[] = {
        {0, 90000000, "0.000000"},          {1, 90000000, "0.000001"},          {-1, 90000000, "-0.000001"},
        {999999, 90000000, "0.999999"},     {1000000, 90000000, "1.000000"},    {-1000000, 90000000, "-1.000000"},
        {90000000, 90000000, "90.000000"},  {-90000000, 90000000, "-90.000000"}, {180000000, 180000000, "180.000000"},
        {-180000000, 180000000, "-180.000000"}, {-500000, 90000000, "-0.500000"}, {123456789, 180000000, "123.456789"},
        {5, 180000000, "0.000005"},         {10000000, 90000000, "10.000000"}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        memset(buf, 'Z', sizeof buf);
        assert(format_udeg(cases[i].v, cases[i].limit, buf, sizeof buf) == 1);
        assert(strcmp(buf, cases[i].text) == 0);
    }
}

static void check_udeg_rejections(void)
{
    char buf[32];
    memset(buf, 'Z', sizeof buf);
    const int32_t bad_values[][2] = {{90000001, 90000000}, {-90000001, 90000000}, {180000001, 180000000},
                                     {-180000001, 180000000}, {INT32_MIN, 180000000}, {INT32_MAX, 180000000},
                                     {INT32_MIN, 90000000}, {0, 0}, {0, 1}, {0, 90000001}, {0, 180000001},
                                     {0, -90000000}, {0, INT32_MAX}, {0, INT32_MIN}, {5, 100000000}};
    for (size_t i = 0; i < sizeof bad_values / sizeof bad_values[0]; ++i) {
        assert(format_udeg(bad_values[i][0], bad_values[i][1], buf, sizeof buf) == 0);
        for (size_t k = 0; k < sizeof buf; ++k) assert(buf[k] == 'Z'); /* rejected: nothing written */
    }
    assert(format_udeg(0, 90000000, NULL, 32) == 0);
}

static void check_udeg_buffer_boundary(void)
{
    char buf[32];
    /* "-180.000000" is 11 characters and needs 12 bytes */
    for (size_t size = 0; size <= 12; ++size) {
        memset(buf, 'Z', sizeof buf);
        int ok = format_udeg(-180000000, 180000000, buf, size);
        assert(ok == (size >= 12));
        if (!ok) assert(buf[0] == 'Z' && buf[11] == 'Z');
        else assert(strcmp(buf, "-180.000000") == 0);
    }
    /* the shortest text needs 9 bytes */
    memset(buf, 'Z', sizeof buf);
    assert(format_udeg(0, 90000000, buf, 8) == 0 && buf[0] == 'Z');
    assert(format_udeg(0, 90000000, buf, 9) == 1 && strcmp(buf, "0.000000") == 0);
}

/* Independent formulation: snprintf over integer division and remainder (no floating point anywhere). */
static void check_udeg_exhaustive(void)
{
    char got[32], want[32];
    for (int64_t v = -1500000; v <= 1500000; ++v) {
        int64_t a = v < 0 ? -v : v;
        snprintf(want, sizeof want, "%s%" PRId64 ".%06" PRId64, v < 0 ? "-" : "", a / 1000000, a % 1000000);
        assert(format_udeg((int32_t)v, 180000000, got, sizeof got) && strcmp(got, want) == 0);
    }
    const int32_t extremes[] = {-180000000, -179999999, -90000001, -90000000, 89999999, 90000000, 179999999, 180000000};
    for (size_t i = 0; i < sizeof extremes / sizeof extremes[0]; ++i) {
        int64_t v = extremes[i], a = v < 0 ? -v : v;
        snprintf(want, sizeof want, "%s%" PRId64 ".%06" PRId64, v < 0 ? "-" : "", a / 1000000, a % 1000000);
        assert(format_udeg(extremes[i], 180000000, got, sizeof got) && strcmp(got, want) == 0);
    }
}

static void check_record(void)
{
    char buf[64];
    memset(buf, 'Z', sizeof buf);
    assert(format_record(7, -5, 10, buf, sizeof buf) && strcmp(buf, "7,-0.000005,0.000010\n") == 0);
    assert(format_record(0, 0, 0, buf, sizeof buf) && strcmp(buf, "0,0.000000,0.000000\n") == 0);
    assert(format_record(18446744073709551615ull, -90000000, -180000000, buf, sizeof buf));
    assert(strcmp(buf, "18446744073709551615,-90.000000,-180.000000\n") == 0 && strlen(buf) == 44);
    for (size_t size = 0; size <= 45; ++size) { /* 44 characters need 45 bytes */
        memset(buf, 'Z', sizeof buf);
        int ok = format_record(18446744073709551615ull, -90000000, -180000000, buf, size);
        assert(ok == (size >= 45));
        if (!ok) assert(buf[0] == 'Z' && buf[43] == 'Z');
    }
    memset(buf, 'Z', sizeof buf);
    assert(!format_record(1, 90000001, 0, buf, sizeof buf) && buf[0] == 'Z');
    assert(!format_record(1, 0, 180000001, buf, sizeof buf) && buf[0] == 'Z');
    assert(!format_record(1, INT32_MIN, 0, buf, sizeof buf) && !format_record(1, 0, INT32_MIN, buf, sizeof buf));
    assert(!format_record(1, 0, 0, NULL, 64));
}
#endif

/* ================================================================== E03 */
#if EXERCISE == 3
#if GEOLAB_MAX_ROWS > 1000
/* Independent grammar check for one CSV row (no trailing newline). Different structure from the parser in E04:
   it splits on commas with strchr and validates each field by length and character class. */
static int digit(char c) { return c >= '0' && c <= '9'; }
static int field_ok(const char *s, size_t n, size_t max_int, long limit)
{
    size_t i = 0;
    int neg = 0;
    if (n > 0 && s[0] == '-') { neg = 1; i = 1; }
    size_t ib = i;
    while (i < n && digit(s[i])) ++i;
    size_t nint = i - ib;
    if (nint < 1 || nint > max_int || (nint > 1 && s[ib] == '0')) return 0;
    if (i >= n || s[i] != '.' || n - (i + 1) != 6) return 0;
    long v = 0;
    for (size_t k = ib; k < n; ++k) {
        if (k == i) continue;
        if (!digit(s[k])) return 0;
        v = v * 10 + (s[k] - '0');
    }
    if (neg && v == 0) return 0;
    return v <= limit;
}
static int row_ok(const char *row, uint64_t expect_id)
{
    const char *c1 = strchr(row, ','), *c2 = c1 ? strchr(c1 + 1, ',') : NULL;
    if (!c1 || !c2 || strchr(c2 + 1, ',')) return 0;
    char idbuf[32];
    snprintf(idbuf, sizeof idbuf, "%" PRIu64, expect_id);
    if ((size_t)(c1 - row) != strlen(idbuf) || strncmp(row, idbuf, strlen(idbuf)) != 0) return 0;
    return field_ok(c1 + 1, (size_t)(c2 - c1 - 1), 2, 90000000) && field_ok(c2 + 1, strlen(c2 + 1), 3, 180000000);
}

#endif

static char *generate_to_memory(uint64_t seed, size_t count, size_t *len)
{
    FILE *t = tmpfile();
    assert(t != NULL);
    assert(generate_csv(seed, count, t) == 1);
    assert(fflush(t) == 0);
    rewind(t);
    char *buf = read_stream(t, len);
    fclose(t);
    return buf;
}

#if GEOLAB_MAX_ROWS > 1000
static void expect_oracle(const char *name, uint64_t seed, size_t count)
{
    FILE *f = open_oracle(name);
    size_t want_len = 0, got_len = 0;
    char *want = read_stream(f, &want_len);
    fclose(f);
    char *got = generate_to_memory(seed, count, &got_len);
    assert(got_len == want_len && memcmp(got, want, want_len) == 0);
    free(got);
    free(want);
}

static void check_generator(void)
{
    size_t len = 0;
    char *empty = generate_to_memory(5, 0, &len);
    assert(len == strlen(GEOLAB_HEADER) + 1 && strcmp(empty, GEOLAB_HEADER "\n") == 0); /* count 0: header only */
    free(empty);
    expect_oracle("gen_1_1000.csv", 1, 1000);
    expect_oracle("gen_0_1.csv", 0, 1);
    expect_oracle("gen_max_257.csv", UINT64_MAX, 257);
    /* structure of a generated file, checked against the independent grammar */
    char *a = generate_to_memory(1, 1000, &len);
    assert(a[len - 1] == '\n' && memchr(a, '\r', len) == NULL);
    size_t lines = 0;
    char *p = a;
    while (*p != '\0') {
        char *nl = strchr(p, '\n');
        assert(nl != NULL);
        *nl = '\0';
        if (lines == 0) assert(strcmp(p, GEOLAB_HEADER) == 0);
        else assert(row_ok(p, lines));
        ++lines;
        p = nl + 1;
    }
    assert(lines == 1001);
    size_t len_b = 0, len_c = 0;
    char *b = generate_to_memory(1, 1000, &len_b);
    char *c = generate_to_memory(2, 1000, &len_c);
    assert(len_b != len_c || memcmp(b, c, len_b) != 0); /* different seeds differ (lengths usually differ too) */
    char *b2 = generate_to_memory(1, 1000, &len);
    assert(len == len_b && memcmp(b, b2, len) == 0); /* same inputs, identical bytes */
    free(a); free(b); free(b2); free(c);
}

#endif

static void check_caps_and_streams(void)
{
    FILE *t = tmpfile();
    assert(t != NULL);
    assert(generate_csv(1, (size_t)GEOLAB_MAX_ROWS + 1, t) == 0);
    assert(ftell(t) == 0); /* rejected before anything was written */
    assert(generate_csv(1, 5, NULL) == 0);
#if GEOLAB_MAX_ROWS <= 100
    size_t len = 0;
    char *atcap = generate_to_memory(9, GEOLAB_MAX_ROWS, &len);
    size_t lines = 0;
    for (size_t i = 0; i < len; ++i) lines += atcap[i] == '\n';
    assert(lines == (size_t)GEOLAB_MAX_ROWS + 1);
    free(atcap);
#endif
    fclose(t);
    /* a stream opened for reading makes every write fail deterministically */
    char path[600];
    snprintf(path, sizeof path, "%s/readonly.txt", TEST_TMPDIR);
    FILE *w = fopen(path, "wb");
    assert(w != NULL && fputs("x\n", w) != EOF && fclose(w) == 0);
    FILE *r = fopen(path, "rb");
    assert(r != NULL);
    assert(generate_csv(1, 0, r) == 0);
    assert(generate_csv(1, 5, r) == 0);
    fclose(r);
    remove(path);
#if defined(__linux__)
    /* a stream that fails partway (POSIX fmemopen with a 100-byte buffer, unbuffered): the failure must surface
       from a write inside the row loop, not only from the header */
    char mem[100];
    FILE *m = fmemopen(mem, sizeof mem, "w");
    assert(m != NULL);
    setvbuf(m, NULL, _IONBF, 0);
    assert(generate_csv(1, 10, m) == 0);
    fclose(m);
#endif
}

#if GEOLAB_MAX_ROWS > 1000
static void check_write_file(void)
{
    char path[600];
    snprintf(path, sizeof path, "%s/out_write.csv", TEST_TMPDIR);
    remove(path);
    assert(write_csv_file(path, 1, 1000) == 1 && remove_calls == 0);
    size_t got_len = 0, want_len = 0;
    char *got = read_file(path, &got_len);
    assert(got != NULL);
    FILE *f = open_oracle("gen_1_1000.csv");
    char *want = read_stream(f, &want_len);
    fclose(f);
    assert(got_len == want_len && memcmp(got, want, want_len) == 0);
    free(got); free(want);
    assert(write_csv_file(path, 1, (size_t)GEOLAB_MAX_ROWS + 1) == 0); /* cap: rejected before opening */
    assert(remove_calls == 0);
    assert(write_csv_file(NULL, 1, 1) == 0);
    /* injected fclose failure: the partial file must be removed */
    fail_close_next = 1;
    assert(write_csv_file(path, 2, 10) == 0);
    fail_close_next = 0;
    assert(remove_calls == 1 && strcmp(removed_path, path) == 0);
    assert(fopen(path, "rb") == NULL); /* nothing left behind */
    /* injected fflush failure alone (fclose succeeds): still a failure, still cleaned up */
    remove_calls = 0;
    fail_flush_next = 1;
    assert(write_csv_file(path, 2, 10) == 0);
    fail_flush_next = 0;
    assert(remove_calls == 1 && fopen(path, "rb") == NULL);
    /* a path whose parent does not exist: fopen fails, nothing to remove */
    remove_calls = 0;
    char bad[700];
    snprintf(bad, sizeof bad, "%s/no_such_dir/x.csv", TEST_TMPDIR);
    assert(write_csv_file(bad, 1, 1) == 0 && remove_calls == 0);
    /* a directory path (POSIX/Linux behavior): open fails, and the directory must survive (remove() would delete
       an empty directory, which is why the failed-open path must not call it) */
    struct stat st;
    assert(write_csv_file(TEST_TMPDIR, 1, 1) == 0);
    assert(remove_calls == 0 && stat(TEST_TMPDIR, &st) == 0 && S_ISDIR(st.st_mode));
}
#else
/* with a lowered cap: exactly the cap is accepted and one more row is rejected before the file is opened */
static void check_cap_write(void)
{
    char path[600];
    snprintf(path, sizeof path, "%s/out_cap.csv", TEST_TMPDIR);
    remove(path);
    assert(write_csv_file(path, 3, GEOLAB_MAX_ROWS) == 1);
    assert(write_csv_file(path, 3, (size_t)GEOLAB_MAX_ROWS + 1) == 0 && remove_calls == 0);
    remove(path);
}
#endif
#endif

/* ================================================================== E04 */
#if EXERCISE == 4
typedef struct { const char *line; ParseStatus status; } LineCase;

static void check_table(void)
{
    GeoPoint untouched = {77, 8.5, -9.5};
    assert(parse_record(NULL, &untouched) == PARSE_INVALID_ARGUMENT);
    assert(strcmp(parse_status_name(PARSE_INVALID_ARGUMENT), "PARSE_INVALID_ARGUMENT") == 0);
    assert(untouched.id == 77 && untouched.lat_deg == 8.5 && untouched.lon_deg == -9.5);
    assert(parse_record("1,0.000000,0.000000", NULL) == PARSE_INVALID_ARGUMENT);
    static const LineCase cases[] = {
        {"0,0.000000,0.000000", PARSE_OK},
        {"18446744073709551615,90.000000,180.000000", PARSE_OK},
        {"1,-90.000000,-180.000000", PARSE_OK},
        {"42,-0.000001,0.000001", PARSE_OK},
        {"7,45.123456,-122.654321", PARSE_OK},
        {"", PARSE_EMPTY},
        {"1,0.000000", PARSE_FIELD_COUNT},
        {"1,0.000000,0.000000,0.000000", PARSE_FIELD_COUNT},
        {"1", PARSE_FIELD_COUNT},
        {",", PARSE_FIELD_COUNT},
        {",,", PARSE_BAD_ID},
        {"18446744073709551616,0.000000,0.000000", PARSE_BAD_ID},
        {"999999999999999999999,0.000000,0.000000", PARSE_BAD_ID}, /* 21 digits */
        {"00000000000000000001,0.000000,0.000000", PARSE_BAD_ID},  /* 20 digits but a leading zero */
        {"01,0.000000,0.000000", PARSE_BAD_ID},
        {"+1,0.000000,0.000000", PARSE_BAD_ID},
        {" 1,0.000000,0.000000", PARSE_BAD_ID},
        {"1e2,0.000000,0.000000", PARSE_BAD_ID},
        {"nan,0.000000,0.000000", PARSE_BAD_ID},
        {"1,+1.000000,0.000000", PARSE_BAD_LAT},
        {"1, 1.000000,0.000000", PARSE_BAD_LAT},
        {"1,nan,0.000000", PARSE_BAD_LAT},
        {"1,inf,0.000000", PARSE_BAD_LAT},
        {"1,0x1p3,0.000000", PARSE_BAD_LAT},
        {"1,1.5,0.000000", PARSE_BAD_LAT},
        {"1,1.5000000,0.000000", PARSE_BAD_LAT},
        {"1,.500000,0.000000", PARSE_BAD_LAT},
        {"1,5.,0.000000", PARSE_BAD_LAT},
        {"1,,0.000000", PARSE_BAD_LAT},
        {"1,-0.000000,0.000000", PARSE_BAD_LAT},
        {"1,100.000000,0.000000", PARSE_BAD_LAT}, /* three integer digits: grammar, not range */
        {"1,05.000000,0.000000", PARSE_BAD_LAT},
        {"1,91.000000,0.000000", PARSE_LAT_RANGE},
        {"1,90.000001,0.000000", PARSE_LAT_RANGE},
        {"1,-90.000001,0.000000", PARSE_LAT_RANGE},
        {"1,91.000000,bad", PARSE_LAT_RANGE}, /* the latitude range error comes before the longitude grammar error */
        {"1,0.000000,+1.000000", PARSE_BAD_LON},
        {"1,0.000000,1000.000000", PARSE_BAD_LON}, /* four integer digits: grammar, not range */
        {"1,0.000000,-0.000000", PARSE_BAD_LON},
        {"1,0.000000,0.000000\r", PARSE_BAD_LON},  /* a trailing CR is part of the last field */
        {"1,0.000000\r,0.000000", PARSE_BAD_LAT},
        {"1,0.000000,1.0", PARSE_BAD_LON},
        {"1,0.000000,1e2", PARSE_BAD_LON},
        {"1,0.000000,0.0000001", PARSE_BAD_LON},
        {"1,0.000000,181.000000", PARSE_LON_RANGE},
        {"1,0.000000,180.000001", PARSE_LON_RANGE},
        {"1,0.000000,-181.000000", PARSE_LON_RANGE},
        {"1,0.000000,999.999999", PARSE_LON_RANGE}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        GeoPoint p = {77, 8.5, -9.5};
        ParseStatus s = parse_record(cases[i].line, &p);
        if (s != cases[i].status) fprintf(stderr, "line \"%s\": got %s, want %s\n", cases[i].line, parse_status_name(s), parse_status_name(cases[i].status));
        assert(s == cases[i].status);
        if (s != PARSE_OK) assert(p.id == 77 && p.lat_deg == 8.5 && p.lon_deg == -9.5); /* unchanged on failure */
    }
}

static const char *status_names[] = {"PARSE_OK", "PARSE_EMPTY", "PARSE_FIELD_COUNT", "PARSE_BAD_ID", "PARSE_BAD_LAT",
                                     "PARSE_LAT_RANGE", "PARSE_BAD_LON", "PARSE_LON_RANGE"};

/* Differential test against the Python oracle: each line of parse_cases.txt is
   "STATUS id lat_micro lon_micro text" (text is the remainder and may contain spaces). */
static void check_oracle_cases(void)
{
    FILE *f = open_oracle("parse_cases.txt");
    char row[512];
    long cases = 0, valid = 0, gated = 0;
    while (fgets(row, sizeof row, f) != NULL) {
        size_t rl = strlen(row);
        assert(rl > 0 && row[rl - 1] == '\n');
        row[rl - 1] = '\0';
        char *fld[4];
        char *cursor = row;
        for (int k = 0; k < 4; ++k) {
            fld[k] = cursor;
            cursor = strchr(cursor, ' ');
            assert(cursor != NULL);
            *cursor++ = '\0';
        }
        const char *text = cursor;
        int want = -1;
        for (size_t k = 0; k < sizeof status_names / sizeof status_names[0]; ++k)
            if (strcmp(fld[0], status_names[k]) == 0) want = (int)k;
        assert(want >= 0);
        GeoPoint p = {77, 8.5, -9.5};
        ParseStatus got = parse_record(text, &p);
        if ((int)got != want) fprintf(stderr, "oracle line \"%s\": got %s, want %s\n", text, parse_status_name(got), fld[0]);
        assert((int)got == want);
        ++cases;
        if (want != (int)PARSE_OK) {
            assert(p.id == 77 && p.lat_deg == 8.5 && p.lon_deg == -9.5);
            continue;
        }
        ++valid;
        uint64_t id = strtoull(fld[1], NULL, 10);
        long lat_micro = strtol(fld[2], NULL, 10), lon_micro = strtol(fld[3], NULL, 10);
        assert(p.id == id);
        assert(p.lat_deg == (double)lat_micro / 1e6 && p.lon_deg == (double)lon_micro / 1e6); /* exact, IEEE division */
#if GEO_IEC559
        /* Annex F.5 paragraph 2: conversion of decimal with at most DECIMAL_DIG significant digits is correctly
           rounded, so strtod of the field text equals (double)micro / 1e6, also correctly rounded. */
        const char *c1 = strchr(text, ','), *c2 = strchr(c1 + 1, ',');
        char field[64];
        snprintf(field, sizeof field, "%.*s", (int)(c2 - c1 - 1), c1 + 1);
        assert(p.lat_deg == strtod(field, NULL));
        assert(p.lon_deg == strtod(c2 + 1, NULL));
        ++gated;
#endif
    }
    fclose(f);
    assert(cases >= 2000 && valid >= 200);
    printf("oracle cases: %ld (valid %ld, strtod-equality checked %ld)\n", cases, valid, gated);
}
#endif

/* ================================================================== E05 */
#if EXERCISE == 5
#if GEOLAB_MAX_ROWS <= 1500
static void write_rows(const char *path, size_t rows, int final_newline)
{
    FILE *f = fopen(path, "wb");
    assert(f != NULL);
    fputs(GEOLAB_HEADER "\n", f);
    for (size_t i = 1; i <= rows; ++i) fprintf(f, "%zu,1.500000,-2.250000%s", i, i == rows && !final_newline ? "" : "\n");
    assert(fclose(f) == 0);
}
#endif

static void fixture_path(char *out, size_t n, const char *name) { snprintf(out, n, "%s/%s", FIXTURE_DIR, name); }

/* Reset instrumentation, run the loader on a path, and check the failure contract. */
static void expect_failure(const char *path, size_t line, ParseStatus status)
{
    GeoPoint *pts = (GeoPoint *)0x1;
    size_t cnt = 12345;
    LoadError err = {999, PARSE_OK};
    live_blocks = 0;
    int ok = load_points(path, &pts, &cnt, &err);
    if (ok || err.line != line || err.status != status)
        fprintf(stderr, "%s: ok=%d line=%zu status=%s, want line=%zu status=%s\n", path, ok, err.line,
                parse_status_name(err.status), line, parse_status_name(status));
    assert(!ok && err.line == line && err.status == status);
    assert(pts == (GeoPoint *)0x1 && cnt == 12345); /* outputs unchanged */
    assert(live_blocks == 0);                       /* nothing left allocated on any error path */
}

static GeoPoint *expect_success(const char *path, size_t rows)
{
    GeoPoint *pts = NULL;
    size_t cnt = 999;
    LoadError err = {999, PARSE_IO_ERROR};
    live_blocks = 0;
    int ok = load_points(path, &pts, &cnt, &err);
    if (!ok) fprintf(stderr, "%s: line=%zu status=%s\n", path, err.line, parse_status_name(err.status));
    assert(ok && cnt == rows && err.status == PARSE_OK);
    if (rows == 0) assert(pts == NULL && live_blocks == 0);
    else assert(pts != NULL && live_blocks == 1);
    return pts;
}

static void check_fixtures(void)
{
    GeoPoint untouched = {77, 8.5, -9.5};
    assert(parse_record(NULL, &untouched) == PARSE_INVALID_ARGUMENT);
    assert(untouched.id == 77 && untouched.lat_deg == 8.5 && untouched.lon_deg == -9.5);
    assert(parse_record("1,0.000000,0.000000", NULL) == PARSE_INVALID_ARGUMENT);
    char p[700];
    fixture_path(p, sizeof p, "good.csv");
    GeoPoint *pts = expect_success(p, 5);
    assert(pts[0].id == 1 && pts[4].id == 5);
    assert(pts[0].lat_deg == 0.0 && pts[0].lon_deg == 0.0);
    assert(pts[1].lat_deg == 45.123456 && pts[1].lon_deg == -122.654321); /* the double nearest each decimal text */
    assert(pts[2].lat_deg == -90.0 && pts[2].lon_deg == -180.0);
    assert(pts[3].lat_deg == 90.0 && pts[3].lon_deg == 180.0);
    assert(pts[4].id == 5 && pts[4].lat_deg == -0.000001 && pts[4].lon_deg == 0.000001);
    test_free(pts);
    fixture_path(p, sizeof p, "header_only.csv");
    assert(expect_success(p, 0) == NULL);
    fixture_path(p, sizeof p, "no_final_newline.csv");
    pts = expect_success(p, 3);
    assert(pts[2].id == 3);
    test_free(pts);
    fixture_path(p, sizeof p, "header_no_newline.csv"); /* the header alone, without a newline */
    assert(expect_success(p, 0) == NULL);
    fixture_path(p, sizeof p, "empty.csv");
    expect_failure(p, 1, PARSE_MISSING_HEADER);
    fixture_path(p, sizeof p, "bad_header.csv");
    expect_failure(p, 1, PARSE_BAD_HEADER);
    fixture_path(p, sizeof p, "newline_only.csv");
    expect_failure(p, 1, PARSE_BAD_HEADER);
    fixture_path(p, sizeof p, "bad_id.csv");
    expect_failure(p, 4, PARSE_BAD_ID);
    fixture_path(p, sizeof p, "field_count.csv");
    expect_failure(p, 3, PARSE_FIELD_COUNT);
    fixture_path(p, sizeof p, "bad_lat.csv");
    expect_failure(p, 3, PARSE_BAD_LAT);
    fixture_path(p, sizeof p, "lat_range.csv");
    expect_failure(p, 5, PARSE_LAT_RANGE);
    fixture_path(p, sizeof p, "bad_lon.csv");
    expect_failure(p, 2, PARSE_BAD_LON);
    fixture_path(p, sizeof p, "lon_range.csv");
    expect_failure(p, 4, PARSE_LON_RANGE);
    fixture_path(p, sizeof p, "blank_middle.csv");
    expect_failure(p, 3, PARSE_EMPTY);
    fixture_path(p, sizeof p, "blank_last.csv");
    expect_failure(p, 4, PARSE_EMPTY);
    fixture_path(p, sizeof p, "crlf.csv");
    expect_failure(p, 1, PARSE_BAD_HEADER); /* the CR is part of the header line */
    fixture_path(p, sizeof p, "crlf_rows.csv");
    expect_failure(p, 2, PARSE_BAD_LON);
    fixture_path(p, sizeof p, "nul_byte.csv");
    expect_failure(p, 3, PARSE_NUL_BYTE);
    fixture_path(p, sizeof p, "long_line.csv");
    expect_failure(p, 3, PARSE_LINE_TOO_LONG);
    fixture_path(p, sizeof p, "high_byte.csv"); /* byte 0xFF must not be mistaken for EOF (a char holding the result of fgetc) */
    expect_failure(p, 3, PARSE_BAD_ID);
    fixture_path(p, sizeof p, "line_127.csv"); /* 127 characters is allowed by the reader: the record itself is bad */
    expect_failure(p, 2, PARSE_BAD_ID);
    fixture_path(p, sizeof p, "line_128.csv");
    expect_failure(p, 2, PARSE_LINE_TOO_LONG);
    snprintf(p, sizeof p, "%s/no_such_file.csv", TEST_TMPDIR);
    expect_failure(p, 0, PARSE_OPEN_ERROR);
#if defined(__linux__)
    expect_failure(TEST_TMPDIR, 1, PARSE_IO_ERROR); /* glibc opens a directory for reading; the first read fails (EISDIR) */
#endif
    GeoPoint *keep = (GeoPoint *)0x1;
    size_t cnt = 5;
    LoadError err = {1, PARSE_OK};
    fixture_path(p, sizeof p, "good.csv");
    assert(!load_points(NULL, &keep, &cnt, &err) && !load_points(p, NULL, &cnt, &err) && !load_points(p, &keep, NULL, &err) &&
           !load_points(p, &keep, &cnt, NULL));
    assert(keep == (GeoPoint *)0x1 && cnt == 5 && err.line == 1 && err.status == PARSE_OK);
}

#if GEOLAB_MAX_ROWS > 4096
static void check_oracle_file(void)
{
    /* 3000 rows written by the Python oracle: values must equal (double)micro/1e6 and growth must follow the plan */
    char p[700];
    snprintf(p, sizeof p, "%s/gen_7_3000.csv", ORACLE_DIR);
    alloc_calls = 0;
    GeoPoint *pts = expect_success(p, 3000);
    FILE *m = open_oracle("gen_7_3000.micro");
    for (size_t i = 0; i < 3000; ++i) {
        uint64_t id = 0;
        long lat = 0, lon = 0;
        assert(fscanf(m, "%" SCNu64 " %ld %ld", &id, &lat, &lon) == 3);
        assert(pts[i].id == id && pts[i].lat_deg == (double)lat / 1e6 && pts[i].lon_deg == (double)lon / 1e6);
    }
    fclose(m);
    test_free(pts);
    /* capacity 1024, then 2048, then 4096: one malloc and two reallocs, with checked byte counts */
    assert(alloc_calls == 3);
    assert(alloc_sizes[0] == 1024 * sizeof(GeoPoint) && alloc_sizes[1] == 2048 * sizeof(GeoPoint) &&
           alloc_sizes[2] == 4096 * sizeof(GeoPoint));
}
#endif

static void check_injected_failures(void)
{
    char p[700];
    fixture_path(p, sizeof p, "good.csv");
    /* first allocation fails */
    alloc_calls = 0;
    fail_alloc_at = 1;
    expect_failure(p, 2, PARSE_OUT_OF_MEMORY);
    fail_alloc_at = 0;
    /* a failing realloc must free the old block (the temporary-pointer idiom): 3000 rows, first growth fails */
#if GEOLAB_MAX_ROWS > 4096
    snprintf(p, sizeof p, "%s/gen_7_3000.csv", ORACLE_DIR);
    alloc_calls = 0;
    fail_alloc_at = 2;
    expect_failure(p, 1026, PARSE_OUT_OF_MEMORY); /* header is line 1, row 1025 is line 1026 */
    fail_alloc_at = 0;
    fail_alloc_at = 3;
    alloc_calls = 0;
    expect_failure(p, 2050, PARSE_OUT_OF_MEMORY);
    fail_alloc_at = 0;
#endif
    /* a failing fclose after a successful parse is an I/O error, with nothing leaked */
    fixture_path(p, sizeof p, "good.csv");
    close_calls = 0;
    fail_close_next = 1;
    expect_failure(p, 0, PARSE_IO_ERROR);
    fail_close_next = 0;
    assert(close_calls == 1);
    /* a read error at the k-th character: IO_ERROR on the line in progress, and the file is still closed */
    read_calls = 0;
    read_error_flag = 0;
    close_calls = 0;
    fail_read_at = 25; /* the header is 18 characters plus a newline (19), so the 25th read is inside line 2 */
    expect_failure(p, 2, PARSE_IO_ERROR);
    fail_read_at = 0;
    read_error_flag = 0;
    assert(close_calls == 1);
    /* the first error wins over a later close failure */
    read_calls = 0;
    close_calls = 0;
    fail_read_at = 30;
    fail_close_next = 1;
    expect_failure(p, 2, PARSE_IO_ERROR);
    fail_read_at = 0;
    fail_close_next = 0;
    read_error_flag = 0;
    fixture_path(p, sizeof p, "bad_id.csv");
    close_calls = 0;
    fail_close_next = 1;
    expect_failure(p, 4, PARSE_BAD_ID); /* a parse error is reported even if the close also fails */
    fail_close_next = 0;
    assert(close_calls == 1);
}

#if GEOLAB_MAX_ROWS <= 1500
static void check_caps(void)
{
    char p[700];
    snprintf(p, sizeof p, "%s/rows.csv", TEST_TMPDIR);
    const size_t cap = GEOLAB_MAX_ROWS;
    write_rows(p, cap, 1);
    alloc_calls = 0;
    GeoPoint *pts = expect_success(p, cap);
    test_free(pts);
#if GEOLAB_MAX_ROWS < 1024
    assert(alloc_calls == 1 && alloc_sizes[0] == cap * sizeof(GeoPoint)); /* initial capacity clamps to the cap */
#else
    assert(alloc_calls == 2 && alloc_sizes[0] == 1024 * sizeof(GeoPoint) && alloc_sizes[1] == cap * sizeof(GeoPoint)); /* doubling clamps */
#endif
    write_rows(p, cap, 0); /* the same, without a final newline */
    pts = expect_success(p, cap);
    test_free(pts);
    write_rows(p, cap + 1, 1);
    expect_failure(p, cap + 2, PARSE_TOO_MANY_ROWS); /* the header is line 1, so row cap + 1 is line cap + 2 */
    write_rows(p, cap + 1, 0);
    expect_failure(p, cap + 2, PARSE_TOO_MANY_ROWS);
    remove(p);
}
#endif
#endif

/* ================================================================== E06 */
#if EXERCISE == 6
static uint64_t lcg_state;
static uint32_t harness_next(void)
{
    lcg_state = lcg_state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
    return (uint32_t)(lcg_state >> 32);
}

static int rel_close(double got, double want, double rel, double floor_abs)
{
    return fabs(got - want) <= fmax(floor_abs, rel * fabs(want));
}

static void check_builtin(void)
{
    const double R = GEO_EARTH_RADIUS_KM, rad = GEO_PI / 180.0;
    static const GeoPoint data[12] = {
        {1, 0.0, -2.0}, {2, 0.0, -1.0}, {3, 0.0, 0.0}, {4, 0.0, 1.0}, {5, 0.0, 2.0}, {6, 0.0, 3.0}, {7, 0.0, 10.0},
        {8, 90.0, 0.0}, {9, -90.0, 0.0}, {10, 0.0, 180.0}, {11, 0.0, -180.0}, {12, 45.0, 45.0}};
    ProcessResult r;
    assert(process_points(data, 12, 0.0, 0.0, R * rad * 2.5, &r) == 1);
    assert(r.points == 12 && r.within == 5);
    /* analytic distances: R times the central angle. equator: |lon| degrees; poles: pi/2; (0,+-180): pi; (45,45): pi/3 */
    double expect_sum = R * (rad * (2 + 1 + 0 + 1 + 2 + 3 + 10) + 3 * GEO_PI + GEO_PI / 3);
    assert(rel_close(r.sum_km, expect_sum, TOL_SUM_REL, 0));
    assert(r.min_km == 0.0); /* the center itself: dphi = dlam = 0 gives exactly 0 */
    assert(rel_close(r.max_km, GEO_PI * R, TOL_ANALYTIC_REL, 0));
    for (int i = 0; i < 12; ++i) {
        double d = -1.0;
        assert(haversine_km(0.0, 0.0, data[i].lat_deg, data[i].lon_deg, &d));
        double angle = i < 7 ? fabs(data[i].lon_deg) * rad : i < 9 ? GEO_PI / 2 : i < 11 ? GEO_PI : GEO_PI / 3;
        assert(rel_close(d, R * angle, TOL_ANALYTIC_REL, TOL_DIST_ABS_KM));
    }
}

static void check_differential(void)
{
    enum { N = 10000 };
    GeoPoint *pts = malloc(N * sizeof *pts);
    assert(pts != NULL);
    lcg_state = 4242;
    for (int i = 0; i < N; ++i) {
        uint32_t a = harness_next();
        uint32_t b = harness_next();
        pts[i].id = (uint64_t)i + 1;
        pts[i].lat_deg = (double)((int64_t)(a % 180000001u) - 90000000) / 1e6;
        pts[i].lon_deg = (double)((int64_t)(b % 360000001u) - 180000000) / 1e6;
    }
    static const double centers[][2] = {{37.75, -122.5}, {0.0, 0.0}, {90.0, 0.0}, {-45.5, 179.999999}};
    static const double radii[] = {500.0, 3000.0, 8000.0, 12000.0, 20015.0};
    for (size_t ci = 0; ci < 4; ++ci) {
        for (size_t ri = 0; ri < 5; ++ri) {
            double clat = centers[ci][0], clon = centers[ci][1], radius = radii[ri];
            long double ref_sum = 0.0L;
            double ref_min = 0.0, ref_max = 0.0;
            size_t ref_within = 0;
            for (int i = 0; i < N; ++i) {
                double d = reference_distance_km(clat, clon, pts[i].lat_deg, pts[i].lon_deg);
                assert(fabs(d - radius) >= 1e-6); /* no point sits within a micron-scale of the boundary */
                ref_sum += d;
                if (d <= radius) ++ref_within;
                if (i == 0 || d < ref_min) ref_min = d;
                if (i == 0 || d > ref_max) ref_max = d;
            }
            ProcessResult r;
            assert(process_points(pts, N, clat, clon, radius, &r) == 1);
            assert(r.points == N && r.within == ref_within);
            assert(rel_close(r.sum_km, (double)ref_sum, TOL_SUM_REL, 0));
            assert(rel_close(r.min_km, ref_min, TOL_MINMAX_REL, TOL_DIST_ABS_KM));
            assert(rel_close(r.max_km, ref_max, TOL_MINMAX_REL, TOL_DIST_ABS_KM));
        }
    }
    /* self-consistent inclusive boundary: use a point's own computed distance as the radius */
    for (int i = 0; i < 200; ++i) {
        ProcessResult one, at, below;
        assert(process_points(&pts[i], 1, 37.75, -122.5, 100000.0, &one) && one.within == 1);
        double d = one.max_km;
        assert(d == one.min_km && d == one.sum_km);
        assert(process_points(&pts[i], 1, 37.75, -122.5, d, &at) && at.within == 1);
        double smaller = nextafter(d, 0.0);
        if (smaller < d) {
            assert(process_points(&pts[i], 1, 37.75, -122.5, smaller, &below) && below.within == 0);
        }
    }
    free(pts);
}

static void check_rejections_and_edges(void)
{
    static const GeoPoint good[3] = {{1, 10.0, 20.0}, {2, -30.0, 40.0}, {3, 0.0, 0.0}};
    ProcessResult sentinel = {7, 8, 9.0, 10.0, 11.0}, r = sentinel;
    /* empty input succeeds with every field zero */
    assert(process_points(NULL, 0, 0.0, 0.0, 10.0, &r) == 1);
    assert(r.points == 0 && r.within == 0 && r.sum_km == 0.0 && r.min_km == 0.0 && r.max_km == 0.0);
    r = sentinel;
    assert(process_points(good, 0, 0.0, 0.0, 10.0, &r) == 1 && r.points == 0);
    /* an empty dataset still validates the center and the radius, and a rejection leaves the output unchanged */
    r = sentinel;
    assert(process_points(NULL, 0, 91.0, 0.0, 10.0, &r) == 0 && memcmp(&r, &sentinel, sizeof r) == 0);
    assert(process_points(NULL, 0, 0.0, NAN, 10.0, &r) == 0 && memcmp(&r, &sentinel, sizeof r) == 0);
    assert(process_points(NULL, 0, 0.0, 0.0, -1.0, &r) == 0 && memcmp(&r, &sentinel, sizeof r) == 0);
    assert(process_points(NULL, 0, 0.0, 0.0, NAN, &r) == 0 && memcmp(&r, &sentinel, sizeof r) == 0);
    assert(process_points(NULL, 0, 0.0, 0.0, 100000.5, &r) == 0 && memcmp(&r, &sentinel, sizeof r) == 0);
    /* every rejection leaves the output unchanged */
    r = sentinel;
#define REJECT(call) do { assert((call) == 0); assert(memcmp(&r, &sentinel, sizeof r) == 0); } while (0)
    REJECT(process_points(NULL, 3, 0.0, 0.0, 10.0, &r));
    REJECT(process_points(good, 3, 91.0, 0.0, 10.0, &r));
    REJECT(process_points(good, 3, -90.5, 0.0, 10.0, &r));
    REJECT(process_points(good, 3, 0.0, 180.5, 10.0, &r));
    REJECT(process_points(good, 3, NAN, 0.0, 10.0, &r));
    REJECT(process_points(good, 3, 0.0, INFINITY, 10.0, &r));
    REJECT(process_points(good, 3, 0.0, 0.0, -1.0, &r));
    REJECT(process_points(good, 3, 0.0, 0.0, 100000.5, &r));
    REJECT(process_points(good, 3, 0.0, 0.0, NAN, &r));
    REJECT(process_points(good, 3, 0.0, 0.0, INFINITY, &r));
    assert(process_points(good, 3, 0.0, 0.0, 0.0, NULL) == 0);
    GeoPoint bad_last[3] = {{1, 10.0, 20.0}, {2, -30.0, 40.0}, {3, 91.0, 0.0}}; /* valid points come first */
    REJECT(process_points(bad_last, 3, 0.0, 0.0, 10.0, &r));
    GeoPoint bad_nan[3] = {{1, 10.0, 20.0}, {2, NAN, 40.0}, {3, 0.0, 0.0}};
    REJECT(process_points(bad_nan, 3, 0.0, 0.0, 10.0, &r));
    GeoPoint bad_lon[3] = {{1, 10.0, 20.0}, {2, 5.0, INFINITY}, {3, 0.0, 0.0}};
    REJECT(process_points(bad_lon, 3, 0.0, 0.0, 10.0, &r));
    GeoPoint bad_first[3] = {{1, 10.0, -181.0}, {2, 5.0, 0.0}, {3, 0.0, 0.0}};
    REJECT(process_points(bad_first, 3, 0.0, 0.0, 10.0, &r));
#undef REJECT
    /* range limits are accepted exactly at the ends */
    assert(process_points(good, 3, 90.0, 180.0, 0.0, &r) == 1 && r.points == 3);
    assert(process_points(good, 3, -90.0, -180.0, 100000.0, &r) == 1 && r.within == 3);
    /* min, max and sum cover all points even when none is within the radius */
    assert(process_points(good, 3, 0.0, 0.0, 0.0, &r) == 1 && r.within == 1); /* the point (0,0) is at distance 0 */
    assert(r.min_km == 0.0 && r.max_km > r.min_km);
}
#endif

/* ================================================================== E07 */
#if EXERCISE == 7
#define U TOL_UNIT_ROUNDOFF
#define HAVE_WIDE_LDBL (GEO_IEC559 && LDBL_MANT_DIG >= 57)

/* key mapping for the distance in representable doubles (finite inputs) */
static uint64_t ukey(double x)
{
    uint64_t b;
    memcpy(&b, &x, sizeof b);
    if (x == 0.0) return UINT64_C(1) << 63;
    return (b >> 63) ? ~b : b | (UINT64_C(1) << 63);
}
static uint64_t ulps(double a, double b)
{
    uint64_t ka = ukey(a), kb = ukey(b);
    return ka > kb ? ka - kb : kb - ka;
}
static long double gamma_k(long k) { return (long double)k * U / (1.0L - (long double)k * U); }
static long pairwise_k(size_t n) /* additions any one value takes part in: <= 7 in its block + one per tree level */
{
    if (n <= 8) return n > 0 ? (long)n - 1 : 0;
    long l = pairwise_k(n / 2), r = pairwise_k(n - n / 2);
    return 1 + (l > r ? l : r);
}

static void check_basics(void)
{
    double sentinel = 42.0, out = sentinel;
    int (*const sums[3])(const double *, size_t, double *) = {sum_naive, sum_pairwise, sum_neumaier};
    const double one[1] = {1.5};
    for (int s = 0; s < 3; ++s) {
        assert(sums[s](NULL, 0, &out) == 1 && out == 0.0); /* an empty sum is 0 */
        out = sentinel;
        assert(sums[s](one, 0, &out) == 1 && out == 0.0);
        out = sentinel;
        assert(sums[s](NULL, 3, &out) == 0 && out == sentinel);  /* NULL data with n > 0 */
        assert(sums[s](one, 1, NULL) == 0);
        assert(sums[s](one, 1, &out) == 1 && out == 1.5);
        /* integers: every partial sum is an integer below 2^53, so all methods are exact */
        double ramp[1000];
        for (int i = 0; i < 1000; ++i) ramp[i] = i + 1;
        assert(sums[s](ramp, 1000, &out) == 1 && out == 500500.0);
        for (size_t n = 0; n <= 40; ++n) { /* block boundaries of the pairwise sum: 8, 9, 16, 17, ... */
            assert(sums[s](ramp, n, &out) == 1 && out == (double)(n * (n + 1) / 2));
        }
        /* IEEE arithmetic for overflow and non-finite input: the call succeeds; the result is +-inf or NaN */
        const double big[2] = {1e308, 1e308};
        out = 0.0;
        assert(sums[s](big, 2, &out) == 1 && !isfinite(out));
        const double inf1[2] = {INFINITY, 1.0};
        out = 0.0;
        assert(sums[s](inf1, 2, &out) == 1 && !isfinite(out));
        const double nan1[2] = {NAN, 1.0};
        assert(sums[s](nan1, 2, &out) == 1 && isnan(out));
    }
    /* derived: naive and pairwise give +infinity for {inf, 1}; the compensated sum forms inf - inf and gives NaN */
    const double inf1[2] = {INFINITY, 1.0};
    assert(sum_naive(inf1, 2, &out) && isinf(out) && sum_pairwise(inf1, 2, &out) && isinf(out));
    assert(sum_neumaier(inf1, 2, &out) && isnan(out));
}

static void check_cancellation(void)
{
    const double v[4] = {1e16, 1.0, -1e16, 1.0}; /* exact sum 2 */
    double out = 0.0;
    assert(sum_neumaier(v, 4, &out) == 1 && out == 2.0);
    /* the same four numbers in other orders: sometimes the running sum is the larger operand, sometimes the new one */
    const double reordered[4] = {1.0, 1e16, 1.0, -1e16};
    const double big_last[4] = {1.0, 1.0, 1e16, -1e16};
    const double big_mid[4] = {1e16, 1.0, 1.0, -1e16};
    assert(sum_neumaier(reordered, 4, &out) == 1 && out == 2.0);
    assert(sum_neumaier(big_last, 4, &out) == 1 && out == 2.0);
    assert(sum_neumaier(big_mid, 4, &out) == 1 && out == 2.0);
    /* 2^53 followed by a thousand ones: each 1 is a tie that rounds back down, so a plain sum stays at 2^53 */
    static double w[1001];
    w[0] = 9007199254740992.0;
    for (int i = 1; i <= 1000; ++i) w[i] = 1.0;
    assert(sum_neumaier(w, 1001, &out) == 1 && out == 9007199254741992.0); /* 2^53 + 1000, representable (even) */
    /* order matters for the plain sum: reverse the ones-first order and it is exact */
    static double z[1001];
    for (int i = 0; i < 1000; ++i) z[i] = 1.0;
    z[1000] = 9007199254740992.0;
    assert(sum_naive(z, 1001, &out) == 1 && out == 9007199254741992.0);
}

/* bounds against the correctly rounded exact sums written by the oracle (Python math.fsum) */
static void check_against_oracle(void)
{
    enum { N = 1000000 };
    double *v = malloc(N * sizeof *v);
    assert(v != NULL);
    FILE *f = open_oracle("sums.txt");
    for (int c = 0; c < 2; ++c) {
        char name[32];
        double exact = 0.0;
        assert(fscanf(f, "%31s %lf", name, &exact) == 2);
        if (strcmp(name, "tenths") == 0) for (size_t i = 0; i < N; ++i) v[i] = 0.1;
        else for (size_t i = 0; i < N; ++i) v[i] = (double)((uint64_t)(i + 1) * 2654435761u % 1000003u) / 7.0;
        assert(strcmp(name, c == 0 ? "tenths" : "hashed") == 0);
        long double abs_sum = 0.0L;
        for (size_t i = 0; i < N; ++i) abs_sum += fabsl(v[i]);
        double naive = 0, pair = 0, neu = 0;
        assert(sum_naive(v, N, &naive) && sum_pairwise(v, N, &pair) && sum_neumaier(v, N, &neu));
        /* |computed - fsum| <= |computed - exact| + u |exact|; the rigorous bounds are stated in ex07.c */
        long double e = fabsl((long double)exact);
        assert(fabsl((long double)naive - exact) <= gamma_k(N - 1) * abs_sum + U * e);
        assert(fabsl((long double)pair - exact) <= gamma_k(pairwise_k(N)) * abs_sum + U * e);
        assert(fabsl((long double)neu - exact) <= 2 * U * e + gamma_k(N - 1) * gamma_k(N - 1) * abs_sum);
        assert(ulps(neu, exact) <= 2); /* the plan's stated tolerance; implied by the bound above for these inputs */
        printf("%s: ulps naive=%" PRIu64 " pairwise=%" PRIu64 " neumaier=%" PRIu64 "\n", name, ulps(naive, exact),
               ulps(pair, exact), ulps(neu, exact));
    }
    fclose(f);
    free(v);
}

static void check_grids(void)
{
    double sentinel = 42.0;
    double small[8];
    for (int i = 0; i < 8; ++i) small[i] = sentinel;
    int (*const grids[2])(double, double, size_t, double *) = {grid_accumulated, grid_explicit};
    for (int g = 0; g < 2; ++g) {
        /* rejections leave the array untouched */
        assert(grids[g](0.0, 0.1, GRID_MAX + 1, small) == 0);
        assert(grids[g](NAN, 0.1, 8, small) == 0 && grids[g](0.0, NAN, 8, small) == 0);
        assert(grids[g](INFINITY, 0.1, 8, small) == 0 && grids[g](0.0, -INFINITY, 8, small) == 0);
        assert(grids[g](1e308, 1e308, 3, small) == 0); /* the final element overflows */
        assert(grids[g](-1e308, -1e308, 3, small) == 0);
        assert(grids[g](0.0, 0.1, 8, NULL) == 0);
        assert(grids[g](NAN, 0.1, 0, NULL) == 0 && grids[g](0.0, INFINITY, 0, NULL) == 0); /* validated even when n == 0 */
        for (int i = 0; i < 8; ++i) assert(small[i] == sentinel);
        assert(grids[g](0.0, 0.1, 0, NULL) == 1 && grids[g](0.0, 0.1, 0, small) == 1); /* n == 0: nothing to write */
        for (int i = 0; i < 8; ++i) assert(small[i] == sentinel);
        /* exactly representable steps are exact in both: 0.5 * i */
        static double half[1000];
        assert(grids[g](-3.0, 0.5, 1000, half) == 1);
        for (int i = 0; i < 1000; ++i) assert(half[i] == -3.0 + 0.5 * i);
        assert(grids[g](7.0, 0.0, 5, small) == 1); /* a zero step */
        for (int i = 0; i < 5; ++i) assert(small[i] == 7.0);
        assert(grids[g](2.0, 1.0, 1, small) == 1 && small[0] == 2.0); /* n == 1 is just the start */
        for (int i = 0; i < 8; ++i) small[i] = sentinel;
    }
    /* the maximum size is accepted, and the last element of a validated grid is finite */
    double *big = malloc((size_t)GRID_MAX * sizeof *big);
    assert(big != NULL);
    assert(grid_explicit(0.0, 1.0, GRID_MAX, big) == 1 && big[GRID_MAX - 1] == (double)(GRID_MAX - 1));
    assert(grid_accumulated(0.0, 1.0, GRID_MAX, big) == 1 && big[GRID_MAX - 1] == (double)(GRID_MAX - 1));
    free(big);
    /* explicit error bound: |x_i - i/10| / (i/10) <= 1.5 u (1 + 2^-52), proved in the answer key. 10 * x_i needs at
       most 57 bits, so it is exact in a 64-bit long double and the comparison against i is exact. */
#if HAVE_WIDE_LDBL
    enum { G = 1000001 };
    double *e = malloc(G * sizeof *e), *a = malloc(G * sizeof *a);
    assert(e != NULL && a != NULL);
    assert(grid_explicit(0.0, 0.1, G, e) == 1 && grid_accumulated(0.0, 0.1, G, a) == 1);
    long double worst_e = 0.0L, worst_a = 0.0L;
    for (long i = 1; i < G; ++i) {
        long double ee = fabsl(10.0L * e[i] - (long double)i) / (long double)i;
        long double aa = fabsl(10.0L * a[i] - (long double)i) / (long double)i;
        if (ee > worst_e) worst_e = ee;
        if (aa > worst_a) worst_a = aa;
        assert(aa <= ((long double)i + 1) * U); /* accumulated: at most (i + 1) u, from i roundings of at most u x_k plus the step's error */
    }
    assert(worst_e <= 1.5L * U * (1.0L + 0x1p-52L));
    printf("grid: explicit max relative error %.6Le (bound %.6Le), accumulated %.6Le\n", worst_e, 1.5L * U, worst_a);
    free(e);
    free(a);
#else
    puts("gated checks skipped: exact long double comparison of the grid error");
#endif
}
#endif

/* ================================================================== main */
int main(void)
{
    /* The wrappers are references to library functions that a correct solution may or may not call (for example
       feof instead of ferror): mention them so that an unused wrapper never breaks the build. */
#if EXERCISE == 3
    (void)test_fclose;
    (void)test_fflush;
    (void)test_remove;
#elif EXERCISE == 5
    (void)test_malloc;
    (void)test_realloc;
    (void)test_free;
    (void)test_fgetc;
    (void)test_ferror;
    (void)test_fclose;
#endif
#if EXERCISE == 1
    check_oracle_streams();
    check_threshold_edges();
    check_rejections();
    check_distribution();
#elif EXERCISE == 2
    check_udeg_exact();
    check_udeg_rejections();
    check_udeg_buffer_boundary();
    check_udeg_exhaustive();
    check_record();
#elif EXERCISE == 3
#if GEOLAB_MAX_ROWS > 1000
    check_generator();
    check_write_file();
#else
    check_cap_write();
#endif
    check_caps_and_streams();
#elif EXERCISE == 4
    check_table();
    check_oracle_cases();
    if (!GEO_IEC559) puts("gated checks skipped: strtod equality (Annex F.5)");
#elif EXERCISE == 5
    check_fixtures();
#if GEOLAB_MAX_ROWS > 4096
    check_oracle_file();
#endif
    check_injected_failures();
#if GEOLAB_MAX_ROWS <= 1500
    check_caps();
#endif
#elif EXERCISE == 6
    check_builtin();
    check_differential();
    check_rejections_and_edges();
#elif EXERCISE == 7
    check_basics();
    check_cancellation();
    check_against_oracle();
    check_grids();
#endif
    puts("contract passed");
    return 0;
}

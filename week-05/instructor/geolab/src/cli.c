/* cli.c: the command line. The option scanner, parse_cli_u64 and cli_usage are supplied plumbing; parse_cli_decimal,
   cmd_generate and cmd_query are the exercise (E01, E02). Reference solution. */
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cli.h"
#include "geolab.h"

/* ---- supplied plumbing ---- */

static void set_why(char *why, size_t why_size, const char *text, const char *arg)
{
    if (why == NULL || why_size == 0) return;
    if (arg != NULL) snprintf(why, why_size, "%s %s", text, arg);
    else snprintf(why, why_size, "%s", text);
}

int cli_scan(int argc, char **argv, int first, const char *const *names, size_t n, const char **values, char *why,
             size_t why_size)
{
    enum { MAX_OPTIONS = 16 };
    const char *found[MAX_OPTIONS] = {0};
    if (argv == NULL || names == NULL || values == NULL || n > MAX_OPTIONS || first < 0) {
        set_why(why, why_size, "internal error: bad scanner arguments", NULL);
        return 0;
    }
    for (int i = first; i < argc; i += 2) {
        size_t k = 0;
        while (k < n && strcmp(argv[i], names[k]) != 0) ++k;
        if (k == n) {
            set_why(why, why_size, strncmp(argv[i], "--", 2) == 0 ? "unknown option" : "unexpected argument", argv[i]);
            return 0;
        }
        if (i + 1 >= argc) {
            set_why(why, why_size, "missing value for", argv[i]);
            return 0;
        }
        if (found[k] != NULL) {
            set_why(why, why_size, "duplicate option", argv[i]);
            return 0;
        }
        found[k] = argv[i + 1];
    }
    for (size_t k = 0; k < n; ++k) values[k] = found[k];
    return 1;
}

int parse_cli_u64(const char *text, uint64_t max, uint64_t *out)
{
    if (text == NULL || out == NULL || *text == '\0') return 0;
    uint64_t v = 0;
    for (const char *s = text; *s != '\0'; ++s) {
        if (*s < '0' || *s > '9') return 0; /* no sign, no whitespace, no locale */
        unsigned d = (unsigned)(*s - '0');
        if (v > (UINT64_MAX - d) / 10) return 0;
        v = v * 10 + d;
    }
    if (v > max) return 0;
    *out = v;
    return 1;
}

int cli_usage(const char *command, const char *message)
{
    static const char *const lines[] = {
        "generate --count N --seed S --out FILE",
        "query --input FILE --lat X --lon Y --radius-km R [--threads 1] [--backend scalar] [--index none]",
        "bench --input FILE --variant parse|distance|query --repeat N [--warmup W] [--lat X --lon Y --radius-km R]"};
    fprintf(stderr, "geolab: %s\n", message);
    for (size_t i = 0; i < sizeof lines / sizeof lines[0]; ++i) {
        if (command == NULL || strncmp(lines[i], command, strlen(command)) == 0) fprintf(stderr, "usage: geolab %s\n", lines[i]);
    }
    return GEOLAB_EXIT_USAGE;
}

int cli_check_future_options(const char *threads, const char *backend, const char *index)
{
    uint64_t t = 1;
    if (threads != NULL && (!parse_cli_u64(threads, 256, &t) || t == 0)) return cli_usage("query", "bad --threads");
    if (backend != NULL && strcmp(backend, "scalar") != 0 && strcmp(backend, "simd") != 0)
        return cli_usage("query", "bad --backend");
    if (index != NULL && strcmp(index, "none") != 0 && strcmp(index, "grid") != 0 && strcmp(index, "kd") != 0)
        return cli_usage("query", "bad --index");
    if (t != 1 || (backend != NULL && strcmp(backend, "scalar") != 0) || (index != NULL && strcmp(index, "none") != 0)) {
        fprintf(stderr, "geolab: unsupported in checkpoint 1 (only --threads 1 --backend scalar --index none)\n");
        return GEOLAB_EXIT_UNSUPPORTED;
    }
    return 0;
}

/* ---- E01: command-line numbers ---- */

/* Grammar -?(0|[1-9][0-9]*)(\.[0-9]{1,6})?. The whole part is accumulated with a guard that keeps it at most
   limit_micro / 10^6 <= 10^9, so whole * 10^6 + frac <= limit_micro + 999999 < 2^63 and no int64_t operation can
   overflow; the final comparison |micro| <= limit_micro is exact integer arithmetic. |micro| <= 10^15 < 2^53, so
   (double)micro is exact and micro / 1e6 is ONE correctly rounded IEC 60559 division (Annex F): the result is the
   double nearest the decimal the user typed. That is correct rounding, not exactness: 0.1 has no exact double. */
int parse_cli_decimal(const char *text, int allow_sign, int64_t limit_micro, double *out)
{
    if (text == NULL || out == NULL || limit_micro < 0 || limit_micro > INT64_C(1000000000000000)) return 0;
    const char *s = text;
    int negative = 0;
    if (*s == '-') {
        if (!allow_sign) return 0;
        negative = 1;
        ++s;
    }
    if (*s < '0' || *s > '9') return 0;          /* at least one integer digit: rejects "", "-", ".5", "+1" */
    if (s[0] == '0' && s[1] >= '0' && s[1] <= '9') return 0; /* no leading zero: rejects "01" */
    const int64_t whole_limit = limit_micro / 1000000;
    int64_t whole = 0;
    int too_large = 0;
    for (; *s >= '0' && *s <= '9'; ++s) {
        int64_t d = *s - '0';
        if (too_large || whole > (whole_limit - d) / 10) too_large = 1; /* keep scanning: grammar still checked */
        else whole = whole * 10 + d;
    }
    int64_t frac = 0;
    if (*s == '.') {
        ++s;
        int digits = 0;
        for (; *s >= '0' && *s <= '9'; ++s) {
            if (++digits > 6) return 0;              /* "1.1234567" */
            frac = frac * 10 + (*s - '0');
        }
        if (digits == 0) return 0;                   /* "5." */
        for (; digits < 6; ++digits) frac *= 10;     /* scale to millionths */
    }
    if (*s != '\0') return 0;                        /* "1e2", "nan", "1 ", "0x10" */
    if (too_large) return 0;
    int64_t micro = whole * 1000000 + frac;
    if (micro > limit_micro) return 0;
    double value = (double)micro / 1000000.0;
    *out = (negative && micro != 0) ? -value : value; /* "-0.0" yields +0.0 */
    return 1;
}

/* ---- the generate subcommand (E01) ---- */

int cmd_generate(int argc, char **argv)
{
    static const char *const names[] = {"--count", "--seed", "--out"};
    const char *v[3];
    char why[160];
    if (!cli_scan(argc, argv, 2, names, 3, v, why, sizeof why)) return cli_usage("generate", why);
    if (v[0] == NULL || v[1] == NULL || v[2] == NULL) return cli_usage("generate", "missing option");
    uint64_t count = 0, seed = 0;
    if (!parse_cli_u64(v[0], GEOLAB_MAX_ROWS, &count)) return cli_usage("generate", "bad --count");
    if (!parse_cli_u64(v[1], UINT64_MAX, &seed)) return cli_usage("generate", "bad --seed");
    if (v[2][0] == '\0') return cli_usage("generate", "empty --out");
    if (!write_csv_file(v[2], seed, (size_t)count)) {
        fprintf(stderr, "geolab: could not write %s\n", v[2]);
        return GEOLAB_EXIT_DATA;
    }
    return GEOLAB_EXIT_OK;
}

/* ---- the query subcommand (E02) ---- */

int cmd_query(int argc, char **argv)
{
    static const char *const names[] = {"--input", "--lat", "--lon", "--radius-km", "--threads", "--backend", "--index"};
    const char *v[7];
    char why[160];
    if (!cli_scan(argc, argv, 2, names, 7, v, why, sizeof why)) return cli_usage("query", why);
    if (v[0] == NULL || v[1] == NULL || v[2] == NULL || v[3] == NULL) return cli_usage("query", "missing option");
    double lat = 0.0, lon = 0.0, radius = 0.0;
    if (!parse_cli_decimal(v[1], 1, GEOLAB_LAT_LIMIT_MICRO, &lat)) return cli_usage("query", "bad --lat");
    if (!parse_cli_decimal(v[2], 1, GEOLAB_LON_LIMIT_MICRO, &lon)) return cli_usage("query", "bad --lon");
    if (!parse_cli_decimal(v[3], 0, GEOLAB_RADIUS_LIMIT_MICRO, &radius)) return cli_usage("query", "bad --radius-km");
    int future = cli_check_future_options(v[4], v[5], v[6]);
    if (future != 0) return future;

    /* Load and compute the complete result before printing anything. */
    GeoPoint *points = NULL;
    size_t count = 0;
    LoadError err = {0, PARSE_OK};
    if (!load_points(v[0], &points, &count, &err)) {
        fprintf(stderr, "geolab: %s at line %zu in %s\n", parse_status_name(err.status), err.line, v[0]);
        return GEOLAB_EXIT_DATA;
    }
    QueryHit *hits = NULL;
    size_t nhits = 0;
    int ok = query_points(points, count, lat, lon, radius, &hits, &nhits);
    free(points);
    if (!ok) {
        fprintf(stderr, "geolab: query failed (out of memory)\n"); /* every input was validated above */
        return GEOLAB_EXIT_DATA;
    }
    /* Print. The program never calls setlocale, so "%.6f" uses '.' (the "C" locale, C11 7.11.1.1 para 4). A write
       error can happen after some output was written; it is reported, and no rollback is promised. */
    int wrote = fputs("id,distance_km\n", stdout) != EOF;
    for (size_t i = 0; wrote && i < nhits; ++i) {
        wrote = printf("%" PRIu64 ",%.6f\n", hits[i].id, hits[i].distance_km) > 0;
    }
    free(hits);
    if (fflush(stdout) != 0 || ferror(stdout)) wrote = 0;
    if (!wrote) {
        fprintf(stderr, "geolab: output error\n");
        return GEOLAB_EXIT_DATA;
    }
    return GEOLAB_EXIT_OK;
}

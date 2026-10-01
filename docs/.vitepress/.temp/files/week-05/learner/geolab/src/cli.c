/* cli.c: the command line. The option scanner, parse_cli_u64, cli_usage and cli_check_future_options are supplied
   plumbing; parse_cli_decimal, cmd_generate and cmd_query are yours (E01.C, E02.C). Contracts are in cli.h and
   CHECKPOINT-1.md. */
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

/* ---- E01.C: command-line numbers ---- */

/* TODO: the grammar -?(0|[1-9][0-9]*)(\.[0-9]{1,6})?, accumulated as integer micro-units with a guard that makes
   overflow impossible, range-checked against limit_micro, converted by ONE division by 1e6. No strtod/atof. */
int parse_cli_decimal(const char *text, int allow_sign, int64_t limit_micro, double *out)
{
    (void)text;
    (void)allow_sign;
    (void)limit_micro;
    (void)out;
    return 0;
}

/* ---- E01.C: the generate subcommand ---- */

/* TODO: scan --count, --seed, --out with cli_scan (argv[2] onward); each is required; --count is parse_cli_u64 up to
   GEOLAB_MAX_ROWS, --seed up to UINT64_MAX, --out non-empty. Usage errors: return cli_usage("generate", why).
   A failed write: "geolab: could not write FILE" on stderr, GEOLAB_EXIT_DATA. Success prints nothing. */
int cmd_generate(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    fprintf(stderr, "geolab: generate is not implemented yet\n");
    return GEOLAB_EXIT_DATA;
}

/* ---- E02.C: the query subcommand ---- */

/* TODO: scan --input --lat --lon --radius-km (required) and --threads --backend --index (optional); parse the numbers
   with parse_cli_decimal (latitude and longitude signed, radius unsigned); call cli_check_future_options; load
   with load_points (a failure prints "geolab: STATUS at line N in FILE", exit GEOLAB_EXIT_DATA); query; only then
   print "id,distance_km" and one "ID,D" line per hit with "%.6f"; check every write and fflush(stdout), reporting
   "geolab: output error" (exit GEOLAB_EXIT_DATA) if any fails. Free everything on every path. */
int cmd_query(int argc, char **argv)
{
    (void)argc;
    (void)argv;
    fprintf(stderr, "geolab: query is not implemented yet\n");
    return GEOLAB_EXIT_DATA;
}

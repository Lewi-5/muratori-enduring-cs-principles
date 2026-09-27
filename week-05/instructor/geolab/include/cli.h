#ifndef GEOLAB_CLI_H
#define GEOLAB_CLI_H
/* The geolab command line (contract version 1). See CHECKPOINT-1.md. */
#include <stddef.h>
#include <stdint.h>

enum {
    GEOLAB_EXIT_OK = 0,          /* success */
    GEOLAB_EXIT_DATA = 1,        /* input, data, allocation, clock or output error */
    GEOLAB_EXIT_USAGE = 2,       /* unknown, duplicate or missing option; malformed or out-of-range value */
    GEOLAB_EXIT_UNSUPPORTED = 3  /* a valid option value that checkpoint 1 does not support */
};

/* Micro-unit limits for parse_cli_decimal. */
#define GEOLAB_LAT_LIMIT_MICRO INT64_C(90000000)
#define GEOLAB_LON_LIMIT_MICRO INT64_C(180000000)
#define GEOLAB_RADIUS_LIMIT_MICRO INT64_C(100000000000) /* 100000 km */

/* ---- supplied plumbing (cli.c) ---- */

/* Scan argv[first..argc) as "--name value" pairs. names[0..n) are the accepted option names (with the leading
   dashes). On success returns 1 and sets values[i] to the value of names[i], or NULL when that option is absent.
   Returns 0 and writes a short reason into why (always NUL-terminated when why_size > 0) for an unknown option, a
   duplicate option, an option without a value, or a stray argument. values is written only on success. */
int cli_scan(int argc, char **argv, int first, const char *const *names, size_t n, const char **values, char *why,
             size_t why_size);

/* A decimal unsigned integer: one or more digits, no sign, no whitespace, value <= max. Returns 1 and writes *out,
   or 0 (nothing written). */
int parse_cli_u64(const char *text, uint64_t max, uint64_t *out);

/* Print "geolab: <message>" and the usage line for command to stderr; returns GEOLAB_EXIT_USAGE. */
int cli_usage(const char *command, const char *message);

/* The checkpoint-only options of query. Returns 0 when all are absent or have their checkpoint-1 values
   (--threads 1, --backend scalar, --index none); GEOLAB_EXIT_USAGE (after printing usage) for a malformed value;
   GEOLAB_EXIT_UNSUPPORTED (after printing "geolab: unsupported in checkpoint 1 ...") for a well-formed value that a
   later checkpoint implements: --threads 2..256, --backend simd, --index grid or kd. */
int cli_check_future_options(const char *threads, const char *backend, const char *index);

/* ---- learner work (cli.c) ---- */

/* A decimal number of the form -?(0|[1-9][0-9]*)(\.[0-9]{1,6})? (the '-' only when allow_sign is nonzero).
   The value is accumulated as an integer number of millionths (micro-units) with checked arithmetic, must satisfy
   |micro| <= limit_micro (limit_micro must be in [0, 10^15]), and is converted by one correctly rounded division
   micro / 1e6 (Annex F.5). A negative zero ("-0", "-0.000") is accepted and yields +0.0. Returns 1 and writes
   *out, or 0 (nothing written) for a NULL argument, a grammar error, an invalid limit, or a value outside the
   limit. Never uses strtod, atof or the locale. */
int parse_cli_decimal(const char *text, int allow_sign, int64_t limit_micro, double *out);

/* The subcommands. argv[0] is the program, argv[1] the subcommand name. Each returns an exit code. */
int cmd_generate(int argc, char **argv);
int cmd_query(int argc, char **argv);
int cmd_bench(int argc, char **argv); /* in bench.c */
#endif

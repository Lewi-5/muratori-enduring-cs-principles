/* csv.c: the week-4 CSV v1 generator, formatter, parser and loader in one translation unit (E01.C).

   TODO: paste your week-4 E01-E05 code here. Keep ONLY the four functions declared in geolab.h external; make every
   helper (lcg_next, lcg_below, format_udeg, format_record, parse_record's helpers, append_row, ...) static, so that
   `make symbols` shows exactly the public interface. The bytes `generate` writes must stay identical to week 4's:
   the tests compare them with the week-4 oracle digests.

   One change from week 4 (see the corrections in PLAN.md): after a failure that follows a successful fopen,
   remove the partial output only if it is a regular file (use POSIX stat() and S_ISREG from <sys/stat.h>), so that
   a path such as /dev/full is never removed.

   If your week-4 code does not work, you may copy the instructor's week-4 reference after making an attempt. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include "geolab.h"

int generate_csv(uint64_t seed, size_t count, FILE *out)
{
    (void)seed;
    (void)count;
    (void)out;
    return 0; /* TODO */
}

int write_csv_file(const char *path, uint64_t seed, size_t count)
{
    (void)path;
    (void)seed;
    (void)count;
    return 0; /* TODO */
}

ParseStatus parse_record(const char *line, GeoPoint *out)
{
    (void)line;
    (void)out;
    return PARSE_INVALID_ARGUMENT; /* TODO */
}

int load_points(const char *path, GeoPoint **points, size_t *count, LoadError *err)
{
    (void)path;
    (void)points;
    (void)count;
    (void)err;
    return 0; /* TODO */
}

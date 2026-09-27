/* E05: the loader. Learner scaffold: fill in the TODO bodies (add static helpers as you wish). */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

typedef struct { size_t line; ParseStatus status; } LoadError;

/* ---- copy your own E04 solution here ---- */
ParseStatus parse_record(const char *line, GeoPoint *out)
{
    /* TODO: paste your E04 parse_record (and its helpers). */
    (void)line;
    (void)out;
    return PARSE_EMPTY;
}

/* ---- the exercise. Contract: see learner/exercises.md (E05.C). ---- */
int load_points(const char *path, GeoPoint **points, size_t *count, LoadError *err)
{
    /* TODO: fgetc into a GEOLAB_MAX_LINE + 1 byte buffer; header check; checked growth; free on every error path;
       outputs unchanged on failure. */
    (void)path;
    (void)points;
    (void)count;
    (void)err;
    return 0;
}

/* ---- supplied driver ---- */
int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: ex05 FILE\n");
        return 2;
    }
    GeoPoint *points = NULL;
    size_t count = 0;
    LoadError err = {0, PARSE_OK};
    if (!load_points(argv[1], &points, &count, &err)) {
        printf("error line=%zu status=%s\n", err.line, parse_status_name(err.status));
        return 1;
    }
    if (count == 0) printf("rows=0\n");
    else printf("rows=%zu first_id=%" PRIu64 " last_id=%" PRIu64 "\n", count, points[0].id, points[count - 1].id);
    free(points);
    return 0;
}

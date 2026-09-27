/* E02: formatting fixed-point text from integers. Learner scaffold: fill in the TODO bodies. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

/* Contract: see learner/exercises.md (E02.C). */
int format_udeg(int32_t value, int32_t limit, char *out, size_t out_size)
{
    /* TODO: integer arithmetic only; never negate an int32_t; leave out untouched on rejection. */
    (void)value;
    (void)limit;
    (void)out;
    (void)out_size;
    return 0;
}

int format_record(uint64_t id, int32_t lat_udeg, int32_t lon_udeg, char *out, size_t out_size)
{
    /* TODO: "ID,LAT,LON\n" plus a NUL terminator; latitude limit 90000000, longitude limit 180000000. */
    (void)id;
    (void)lat_udeg;
    (void)lon_udeg;
    (void)out;
    (void)out_size;
    return 0;
}

/* ---- supplied driver. Playground: add records, predict the text on paper, run, reconcile. ---- */
int main(void)
{
    static const struct { uint64_t id; int32_t lat, lon; } records[] = {
        {1, 0, 0}, {7, -5, 10}, {42, 45123456, -122654321}, {0, 999999, -1000000},
        {UINT64_MAX, -90000000, -180000000}, {123456789, 90000000, 180000000}};
    for (size_t i = 0; i < sizeof records / sizeof records[0]; ++i) {
        char buf[64];
        if (!format_record(records[i].id, records[i].lat, records[i].lon, buf, sizeof buf)) return 1;
        printf("line=%s", buf); /* the record already ends with a newline */
    }
    return 0;
}

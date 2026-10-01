/* E04: parsing one record. Learner scaffold: fill in the TODO body (add static helpers as you wish). */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "geolab_types.h"
#include "platform.h"

/* Contract: see learner/exercises.md (E04.C). The canonical grammar and the order of the statuses are there. */
ParseStatus parse_record(const char *line, GeoPoint *out)
{
    /* TODO: no strtod, no isdigit on char, checked digit accumulation, *out unchanged on any failure. */
    (void)line;
    (void)out;
    return PARSE_EMPTY;
}

/* ---- supplied driver. Playground: add lines, predict the status on paper, run, reconcile. ---- */
int main(void)
{
    static const char *const lines[] = {
        "1,0.000000,0.000000", "18446744073709551615,90.000000,180.000000", "7,-33.868800,151.209300",
        "01,1.000000,1.000000", "5,91.000000,0.000000", "5,1.5,2.000000", "3,0.000000", "9,-0.000000,0.000000",
        "10,45.000000,181.000000", "18446744073709551616,0.000000,0.000000", ""};
    for (size_t i = 0; i < sizeof lines / sizeof lines[0]; ++i) {
        GeoPoint p = {0, 0.0, 0.0};
        ParseStatus s = parse_record(lines[i], &p);
        printf("line=\"%s\" status=%s", lines[i], parse_status_name(s));
        if (s == PARSE_OK) printf(" id=%" PRIu64 " lat=%.6f lon=%.6f", p.id, p.lat_deg, p.lon_deg);
        printf("\n");
    }
    return 0;
}

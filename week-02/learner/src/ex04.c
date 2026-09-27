#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* BEGIN MAP HELPERS */
typedef struct { size_t offset; size_t size; } FieldSpan;

int layout_map(const FieldSpan *fields, size_t count, size_t object_size,
               char *out, size_t out_size)
{
    /* TODO: implement the corresponding learner contract. */
    (void)fields; (void)count; (void)object_size; (void)out; (void)out_size; return 0;
}
/* END MAP HELPERS */

typedef struct { uint64_t id; double lat_deg; double lon_deg; } GeoPoint;
struct A { char tag; double value; int count; };
struct Inner { short code; double value; };
struct Nested { char tag; struct Inner inner; unsigned char bytes[3]; };

static int show(const char *name, const FieldSpan fields[3], size_t size)
{
    if (size == SIZE_MAX) return 0;
    char *map = malloc(size + 1);
    if (map == NULL) return 0;
    int ok = layout_map(fields, 3, size, map, size + 1);
    if (ok) printf("%s size=%zu map=%s\n", name, size, map);
    free(map);
    return ok;
}

int main(void)
{
#define SPAN(type, member) {offsetof(type, member), sizeof(((type *)0)->member)}
    const FieldSpan geo[] = {SPAN(GeoPoint, id), SPAN(GeoPoint, lat_deg), SPAN(GeoPoint, lon_deg)};
    const FieldSpan a[] = {SPAN(struct A, tag), SPAN(struct A, value), SPAN(struct A, count)};
    const FieldSpan nested[] = {SPAN(struct Nested, tag), SPAN(struct Nested, inner), SPAN(struct Nested, bytes)};
#undef SPAN
    return !(show("GeoPoint", geo, sizeof(GeoPoint)) && show("A", a, sizeof(struct A))
        && show("Nested", nested, sizeof(struct Nested)));
}

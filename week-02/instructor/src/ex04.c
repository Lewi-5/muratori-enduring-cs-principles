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
    if (out == NULL || (count != 0 && fields == NULL) || count > 26
        || object_size == 0 || object_size == SIZE_MAX || out_size <= object_size) return 0;
    for (size_t i = 0; i < count; ++i) {
        if (fields[i].size == 0 || fields[i].offset > object_size
            || fields[i].size > object_size - fields[i].offset) return 0;
        for (size_t j = 0; j < i; ++j)
            if (fields[i].offset < fields[j].offset + fields[j].size
                && fields[j].offset < fields[i].offset + fields[i].size) return 0;
    }
    /* No output has been changed on any rejection path. */
    memset(out, '.', object_size);
    const char labels[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (size_t i = 0; i < count; ++i) memset(out + fields[i].offset, labels[i], fields[i].size);
    out[object_size] = '\0';
    return 1;
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

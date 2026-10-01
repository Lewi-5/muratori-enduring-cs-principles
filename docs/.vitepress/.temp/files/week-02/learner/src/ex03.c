#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>
#include "platform.h"

int is_power_of_two(size_t value)
{
    /* TODO: implement the corresponding learner contract. */
    (void)value; return 0;
}

int align_up(size_t value, size_t alignment, size_t *out)
{
    /* TODO: implement the corresponding learner contract. */
    (void)value; (void)alignment; (void)out; return 0;
}

/* BEGIN LAYOUT HELPERS */
typedef struct { size_t size; size_t align; } MemberSpec;

int predict_layout(const MemberSpec *members, size_t count, size_t *offsets,
                   size_t *size, size_t *align)
{
    /* TODO: implement the corresponding learner contract. */
    (void)members; (void)count; (void)offsets; (void)size; (void)align; return 0;
}
/* END LAYOUT HELPERS */

/* BEGIN DEMO TYPES */
typedef struct { uint64_t id; double lat_deg; double lon_deg; } GeoPoint;
struct A { char tag; double value; int count; };
struct Inner { short code; double value; };
struct Nested { char tag; struct Inner inner; unsigned char bytes[3]; };
/* END DEMO TYPES */

static int show(const char *name, const MemberSpec *specs, const char *const *names,
                const size_t *observed, size_t real_size, size_t real_align)
{
    size_t offsets[3], size, align;
    if (!predict_layout(specs, 3, offsets, &size, &align)) return 0;
    int match = size == real_size && align == real_align;
    for (size_t i = 0; i < 3; ++i) match = match && offsets[i] == observed[i];
    printf("struct=%s predicted_size=%zu observed_size=%zu predicted_align=%zu observed_align=%zu match=%d\n",
           name, size, real_size, align, real_align, match);
    for (size_t i = 0; i < 3; ++i)
        printf("member=%s predicted=%zu observed=%zu\n", names[i], offsets[i], observed[i]);
    return !REFERENCE_ABI || match;
}

int main(void)
{
    const MemberSpec geo[] = {{sizeof(uint64_t), alignof(uint64_t)}, {sizeof(double), alignof(double)}, {sizeof(double), alignof(double)}};
    const MemberSpec a[] = {{sizeof(char), alignof(char)}, {sizeof(double), alignof(double)}, {sizeof(int), alignof(int)}};
    const MemberSpec nested[] = {{sizeof(char), alignof(char)}, {sizeof(struct Inner), alignof(struct Inner)}, {sizeof(unsigned char[3]), alignof(unsigned char[3])}};
    const size_t go[] = {offsetof(GeoPoint, id), offsetof(GeoPoint, lat_deg), offsetof(GeoPoint, lon_deg)};
    const size_t ao[] = {offsetof(struct A, tag), offsetof(struct A, value), offsetof(struct A, count)};
    const size_t no[] = {offsetof(struct Nested, tag), offsetof(struct Nested, inner), offsetof(struct Nested, bytes)};
    const char *gn[] = {"id", "lat_deg", "lon_deg"}, *an[] = {"tag", "value", "count"}, *nn[] = {"tag", "inner", "bytes"};
    puts(REFERENCE_ABI ? "reference_abi=checked" : "reference_abi=skipped");
    return !(show("GeoPoint", geo, gn, go, sizeof(GeoPoint), alignof(GeoPoint))
        && show("A", a, an, ao, sizeof(struct A), alignof(struct A))
        && show("Nested", nested, nn, no, sizeof(struct Nested), alignof(struct Nested)));
}

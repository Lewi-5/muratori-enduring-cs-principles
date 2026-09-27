#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>
#include "platform.h"

int is_power_of_two(size_t value)
{
    return value != 0 && (value & (value - 1)) == 0;
}

int align_up(size_t value, size_t alignment, size_t *out)
{
    if (out == NULL || !is_power_of_two(alignment)) return 0;
    size_t mask = alignment - 1;
    if (value > SIZE_MAX - mask) return 0;
    *out = (value + mask) & ~mask;
    return 1;
}

/* BEGIN LAYOUT HELPERS */
typedef struct { size_t size; size_t align; } MemberSpec;

int predict_layout(const MemberSpec *members, size_t count, size_t *offsets,
                   size_t *size, size_t *align)
{
    if (count == 0 || members == NULL || offsets == NULL || size == NULL || align == NULL) return 0;
    size_t end = 0, largest = 1;
    /* First pass validates the entire request without altering outputs. */
    for (size_t i = 0; i < count; ++i) {
        size_t position;
        if (members[i].size == 0 || !is_power_of_two(members[i].align)
            || members[i].size % members[i].align != 0
            || !align_up(end, members[i].align, &position)
            || members[i].size > SIZE_MAX - position) return 0;
        end = position + members[i].size;
        if (members[i].align > largest) largest = members[i].align;
    }
    size_t total;
    if (!align_up(end, largest, &total)) return 0;
    end = 0;
    for (size_t i = 0; i < count; ++i) {
        size_t position = 0;
        (void)align_up(end, members[i].align, &position); /* Proven to succeed above. */
        offsets[i] = position;
        end = position + members[i].size;
    }
    *size = total;
    *align = largest;
    return 1;
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

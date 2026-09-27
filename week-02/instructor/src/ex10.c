#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

/* Supplied CLI plumbing: the learning task is composing the checked helpers. */
int parse_types(const char *text, MemberSpec *members, const char **names, size_t *count)
{
    static const struct { const char *name; MemberSpec spec; } types[] = {
#define TYPE(name, type) {name, {sizeof(type), alignof(type)}}
        TYPE("char", char), TYPE("short", short), TYPE("int", int), TYPE("long", long),
        TYPE("llong", long long), TYPE("float", float), TYPE("double", double),
        TYPE("ldouble", long double), TYPE("ptr", void *)
#undef TYPE
    };
    if (text == NULL || members == NULL || names == NULL || count == NULL) return 0;
    MemberSpec temporary[26];
    const char *labels[26];
    size_t used = 0;
    const char *p = text;
    for (;;) {
        const char *end = strchr(p, ',');
        size_t length = end == NULL ? strlen(p) : (size_t)(end - p);
        if (length == 0 || used == 26) return 0;
        size_t i;
        for (i = 0; i < sizeof types / sizeof types[0]; ++i)
            if (strlen(types[i].name) == length && strncmp(p, types[i].name, length) == 0) break;
        if (i == sizeof types / sizeof types[0]) return 0;
        temporary[used] = types[i].spec;
        labels[used++] = types[i].name;
        if (end == NULL) break;
        p = end + 1;
    }
    memcpy(members, temporary, used * sizeof temporary[0]);
    memcpy(names, labels, used * sizeof labels[0]);
    *count = used;
    return 1;
}

int main(int argc, char **argv)
{
    MemberSpec specs[26];
    const char *names[26];
    size_t count, offsets[26], size, align;
    if (argc != 2 || !parse_types(argv[1], specs, names, &count)
        || !predict_layout(specs, count, offsets, &size, &align) || size == SIZE_MAX) {
        fputs("error: expected 1..26 comma-separated known types with representable layout\n", stderr);
        return 1;
    }
    char *map = malloc(size + 1);
    if (map == NULL) { fputs("error: map allocation failed\n", stderr); return 1; }
    FieldSpan spans[26] = {{0, 0}};
    size_t member_bytes = 0;
    for (size_t i = 0; i < count; ++i) {
        spans[i] = (FieldSpan){offsets[i], specs[i].size};
        member_bytes += specs[i].size; /* Validated layout bounds this total. */
    }
    if (!layout_map(spans, count, size, map, size + 1)) { free(map); return 1; }
    printf("members=%zu size=%zu align=%zu padding=%zu\n", count, size, align, size - member_bytes);
    const char labels[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (size_t i = 0; i < count; ++i)
        printf("%c %s offset=%zu size=%zu align=%zu\n", labels[i], names[i], offsets[i], specs[i].size, specs[i].align);
    printf("map=%s\n", map);
    free(map);
    return 0;
}

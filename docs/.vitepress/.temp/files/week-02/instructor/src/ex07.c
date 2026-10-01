#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>
#include <stdlib.h>
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

typedef struct { uint32_t count; uint32_t capacity; } Header;
typedef struct { uint32_t id; uint32_t next; double weight; } Record;

int is_aligned(const void *p, size_t alignment)
{
    /* Numeric address divisibility is a reference-platform assumption. */
    return p != NULL && is_power_of_two(alignment) && (uintptr_t)p % alignment == 0;
}

void *alloc_aligned(size_t size, size_t alignment)
{
    size_t rounded;
    /* Deliberate whitelist: do not pass arbitrary powers of two to C11 aligned_alloc. */
    if (size == 0 || (alignment != alignof(max_align_t) && !(REFERENCE_ABI && alignment == 64))
        || !align_up(size, alignment, &rounded)) return NULL;
    return aligned_alloc(alignment, rounded);
}

int carve(void *block, size_t block_size, size_t capacity, Header **header, Record **records)
{
    if (header == NULL || records == NULL || capacity > UINT32_MAX
        || !is_aligned(block, alignof(Header)) || !is_aligned(block, alignof(Record))) return 0;
    size_t offset;
    if (!align_up(sizeof(Header), alignof(Record), &offset)
        || capacity > (SIZE_MAX - offset) / sizeof(Record)) return 0;
    size_t needed = offset + capacity * sizeof(Record);
    if (block_size < needed) return 0;
    /* All failure checks precede typed pointer formation and stores. */
    Header *h = block;
    Record *r = capacity == 0 ? NULL : (Record *)((unsigned char *)block + offset);
    *h = (Header){0, (uint32_t)capacity};
    for (size_t i = 0; i < capacity; ++i) r[i] = (Record){(uint32_t)i, 0, 0.0};
    *header = h;
    *records = r;
    return 1;
}

int main(void)
{
#if REFERENCE_ABI
    _Alignas(64) static unsigned char static_bytes[64];
    _Alignas(64) unsigned char automatic_bytes[64];
    size_t offset;
    if (!align_up(sizeof(Header), alignof(Record), &offset)) return 1;
    size_t needed = offset + 3 * sizeof(Record);
    void *block = malloc(needed + 1);
    void *aligned = alloc_aligned(100, 64);
    if (block == NULL || aligned == NULL) { free(block); free(aligned); return 1; }
    Header *h = NULL;
    Record *r = NULL;
    int ordinary = is_aligned(block, alignof(max_align_t));
    int a64 = is_aligned(aligned, 64), s64 = is_aligned(static_bytes, 64), l64 = is_aligned(automatic_bytes, 64);
    int carved = carve(block, needed, 3, &h, &r);
    int rejected = !carve((unsigned char *)block + 1, needed, 3, &h, &r);
    printf("malloc_max_align=%d alloc64=%d static64=%d automatic64=%d carve=%d misaligned_rejected=%d\n",
           ordinary, a64, s64, l64, carved, rejected);
    free(aligned);
    free(block);
    return !(ordinary && a64 && s64 && l64 && carved && rejected);
#else
    puts("target_alignment=skipped");
    return 0;
#endif
}

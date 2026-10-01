#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>
#include <stdlib.h>
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

typedef struct { uint32_t count; uint32_t capacity; } Header;
typedef struct { uint32_t id; uint32_t next; double weight; } Record;

int is_aligned(const void *p, size_t alignment)
{
    /* TODO: implement the corresponding learner contract. */
    (void)p; (void)alignment; return 0;
}

void *alloc_aligned(size_t size, size_t alignment)
{
    /* TODO: implement the corresponding learner contract. */
    (void)size; (void)alignment; return NULL;
}

int carve(void *block, size_t block_size, size_t capacity, Header **header, Record **records)
{
    /* TODO: implement the corresponding learner contract. */
    (void)block; (void)block_size; (void)capacity; (void)header; (void)records; return 0;
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

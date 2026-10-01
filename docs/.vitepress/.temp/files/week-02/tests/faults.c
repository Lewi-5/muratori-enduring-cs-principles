#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdalign.h>
static int calls, releases, fail;
static size_t requested_size, requested_alignment;
#if EXERCISE == 6
static void *test_malloc(size_t size) { ++calls; return fail ? NULL : malloc(size); }
#define malloc test_malloc
#else
static void *test_aligned_alloc(size_t alignment, size_t size)
{
    ++calls; requested_size=size; requested_alignment=alignment;
    return fail ? NULL : aligned_alloc(alignment,size);
}
#define aligned_alloc test_aligned_alloc
#endif
static void test_free(void *p) { if(p) ++releases; free(p); }
#define free test_free
#define main exercise_main
#include SOURCE
#undef main

int main(void)
{
#if EXERCISE == 6
    (void)requested_size; (void)requested_alignment;
    fail=1; assert(counter_create(1)==NULL && calls==1 && releases==0);
    fail=0; int *a=counter_create(9), *b=counter_create(1); assert(a && b && *a==9 && *b==1);
    counter_destroy(a); counter_destroy(b); counter_destroy(NULL);
    assert(calls==3 && releases==2);
#else
    fail=1;
    assert(alloc_aligned(100,alignof(max_align_t))==NULL && calls==1 && releases==0);
    assert(requested_size>=100 && requested_size%requested_alignment==0);
    assert(!alloc_aligned(0,alignof(max_align_t)) && calls==1);
    assert(!alloc_aligned(100,3) && calls==1);
    assert(!alloc_aligned(SIZE_MAX,64) && calls==1);
    fail=0;
    void *p=alloc_aligned(100,alignof(max_align_t)); assert(p); free(p);
    assert(calls==2 && releases==1);
#endif
    puts("allocation faults passed");
    return 0;
}

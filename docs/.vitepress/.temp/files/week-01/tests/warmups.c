/* Warm-up contract checks (ungraded). Each warm-up source is included with its main renamed.
   Library headers come first so that the W04 allocation hook can replace malloc only in the source. */
#include <assert.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if WARMUP == 4
static int fail_next_malloc;
static size_t last_request;
static void *hooked_malloc(size_t size)
{
    last_request = size;
    if (fail_next_malloc) { fail_next_malloc = 0; return NULL; }
    return malloc(size);
}
#define malloc hooked_malloc
#endif
#define main warmup_main
#include SOURCE
#undef main
#undef malloc

#if WARMUP == 1
static void check(void)
{
    unsigned long long out = 99;
    assert(checked_add(2, 3, 10, &out) && out == 5);
    assert(checked_add(7, 3, 10, &out) && out == 10);            /* exactly the limit is accepted */
    out = 99;
    assert(!checked_add(7, 4, 10, &out) && out == 99);           /* one over the limit is rejected */
    assert(!checked_add(11, 0, 10, &out) && out == 99);          /* a alone exceeds the limit */
    assert(!checked_add(0, 11, 10, &out) && out == 99);
    assert(checked_add(0, 0, 0, &out) && out == 0);
    out = 99;
    assert(!checked_add(ULLONG_MAX, 1, ULLONG_MAX, &out) && out == 99);  /* would wrap to 0 */
    assert(!checked_add(1, ULLONG_MAX, ULLONG_MAX, &out) && out == 99);
    assert(!checked_add(ULLONG_MAX / 2 + 1, ULLONG_MAX / 2 + 1, ULLONG_MAX, &out) && out == 99);
    assert(checked_add(ULLONG_MAX - 5, 5, ULLONG_MAX, &out) && out == ULLONG_MAX);
    assert(!checked_add(1, 1, 10, NULL));
}
#elif WARMUP == 2
static void check(void)
{
    const int values[] = {4, -2, 7, 7, 1};
    size_t at = 99;
    assert(last_index_of(values, 5, 7, &at) && at == 3);          /* the last of two matches */
    assert(last_index_of(values, 5, 4, &at) && at == 0);          /* index 0 must be reachable */
    assert(last_index_of(values, 5, 1, &at) && at == 4);
    at = 99;
    assert(!last_index_of(values, 5, 9, &at) && at == 99);        /* absent: output unchanged */
    assert(!last_index_of(values, 0, 4, &at) && at == 99);        /* empty prefix */
    assert(!last_index_of(NULL, 0, 4, &at) && at == 99);          /* NULL allowed only at length 0 */
    const int one[] = {INT_MIN};
    assert(last_index_of(one, 1, INT_MIN, &at) && at == 0);
    assert(!last_index_of(values, 5, 7, NULL));
    assert(last_index_of(values, 2, -2, &at) && at == 1);         /* only the first length elements count */
    at = 99;
    assert(!last_index_of(values, 2, 7, &at) && at == 99);
}
#elif WARMUP == 3
static void check(void)
{
    const uint32_t v = UINT32_C(0x01020304);
    assert(byte_at(v, 0) == 0x04 && byte_at(v, 1) == 0x03 && byte_at(v, 2) == 0x02 && byte_at(v, 3) == 0x01);
    assert(byte_at(UINT32_C(0xFF000000), 3) == 0xFF && byte_at(UINT32_C(0xFF000000), 0) == 0);
    assert(byte_at(UINT32_C(0x80FF7F00), 1) == 0x7F && byte_at(UINT32_C(0x80FF7F00), 2) == 0xFF);
    assert(bit_count(0) == 0 && bit_count(1) == 1 && bit_count(UINT32_C(0x80000000)) == 1);
    assert(bit_count(UINT32_C(0xFFFFFFFF)) == 32 && bit_count(v) == 5 && bit_count(UINT32_C(0xF0F0F0F0)) == 16);
    for (unsigned shift = 0; shift < 32; ++shift) assert(bit_count(UINT32_C(1) << shift) == 1);
}
#elif WARMUP == 4
static void check(void)
{
    const char *text = "geolab";
    char *copy = copy_text(text);
    assert(copy != NULL && copy != text && strcmp(copy, text) == 0);
    assert(last_request == strlen(text) + 1);                     /* room for the terminating NUL */
    copy[0] = 'G';
    assert(strcmp(text, "geolab") == 0);                          /* the original is untouched */
    free(copy);
    char *empty = copy_text("");
    assert(empty != NULL && empty[0] == '\0' && last_request == 1);
    free(empty);
    assert(copy_text(NULL) == NULL);
    fail_next_malloc = 1;
    assert(copy_text(text) == NULL);                              /* allocation failure is reported, not ignored */
}
#else
#error WARMUP must be 1, 2, 3 or 4
#endif

int main(void)
{
    check();
    puts("warm-up passed");
    return 0;
}

/* Library adapters exist only in this test TU, not in learner executables. */
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if EXERCISE == 11
static int allocations, releases, fail_allocation;
static void *test_malloc(size_t size)
{
    ++allocations;
    return fail_allocation ? NULL : malloc(size);
}
static void test_free(void *ptr)
{
    ++releases;
    free(ptr);
}
#define malloc test_malloc
#define free test_free
#elif EXERCISE == 12
static int fail_open, fail_read, fail_close, closes;
static FILE *test_fopen(const char *path, const char *mode)
{
    (void)path;
    (void)mode;
    return fail_open ? NULL : tmpfile();
}
static int test_fgetc(FILE *file) { return fail_read ? EOF : fgetc(file); }
static int test_ferror(FILE *file) { return fail_read || ferror(file); }
static int test_fclose(FILE *file)
{
    ++closes;
    int status = fclose(file); /* Release the real stream even for injected errors. */
    return fail_close ? EOF : status;
}
#define fopen test_fopen
#define fgetc test_fgetc
#define ferror test_ferror
#define fclose test_fclose
#endif
#define main exercise_main
#include SOURCE
#undef main

int main(void)
{
#if EXERCISE == 11
    unsigned long long out = 99;
    assert(allocated_sum(0, &out) && out == 0);
    assert(allocations == 0 && releases == 0);
    assert(!allocated_sum(SIZE_MAX, &out));
    assert(allocations == 0 && releases == 0);
    fail_allocation = 1;
    out = 99;
    assert(!allocated_sum(5, &out) && out == 99);
    assert(allocations == 1 && releases == 0);
    fail_allocation = 0;
    assert(allocated_sum(5, &out) && out == 10);
    assert(allocations == 2 && releases == 1);
#elif EXERCISE == 12
    size_t bytes = 99, newlines = 88;
    fail_open = 1;
    assert(!count_file("unused", &bytes, &newlines));
    assert(bytes == 99 && newlines == 88 && closes == 0);
    fail_open = 0;
    fail_read = 1;
    assert(!count_file("unused", &bytes, &newlines));
    assert(bytes == 99 && newlines == 88 && closes == 1);
    fail_read = 0;
    fail_close = 1;
    assert(!count_file("unused", &bytes, &newlines));
    assert(bytes == 99 && newlines == 88 && closes == 2);
    fail_read = 1;
    assert(!count_file("unused", &bytes, &newlines));
    assert(closes == 3); /* A read error must not short-circuit closing. */
    fail_read = fail_close = 0;
    assert(count_file("unused", &bytes, &newlines));
    assert(bytes == 0 && newlines == 0 && closes == 4);
#endif
    puts("fault paths passed");
    return 0;
}

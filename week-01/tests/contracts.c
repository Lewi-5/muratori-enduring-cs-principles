/* Compile once per exercise, including its implementation in this test TU.
   Production ex14 still compiles and links two independent object files. */
#include <assert.h>
#include <limits.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#define main exercise_main
#include SOURCE
#undef main

int main(void)
{
#if EXERCISE == 3
    unsigned long long sum = 99;
    assert(sum_to(0, &sum) && sum == 0);
    assert(sum_to(1, &sum) && sum == 1);
    assert(sum_to(10, &sum) && sum == 55);
    assert(sum_to(10000, &sum) && sum == 50005000);
    assert(!sum_to(10001, &sum) && sum == 50005000);
#elif EXERCISE == 4
    int out = 123;
    assert(!clamp_int(4, 9, 1, &out) && out == 123);
    for (int x = -5; x <= 5; ++x) {
        assert(clamp_int(x, -3, 3, &out));
        assert(out == (x < -3 ? -3 : x > 3 ? 3 : x));
    }
    assert(clamp_int(INT_MIN, INT_MIN, INT_MAX, &out) && out == INT_MIN);
    assert(clamp_int(INT_MAX, INT_MIN, INT_MAX, &out) && out == INT_MAX);
    assert(clamp_int(1, 2, 2, &out) && out == 2);
#elif EXERCISE == 5
    Stats out;
    const int values[] = {INT_MAX, 0, INT_MIN, INT_MAX};
    assert(!array_stats(NULL, 0, &out) && out.count == 0 && out.min == 0 && out.max == 0);
    assert(array_stats(values, 1, &out) && out.count == 1 && out.min == INT_MAX && out.max == INT_MAX);
    assert(array_stats(values, 4, &out) && out.count == 4 && out.min == INT_MIN && out.max == INT_MAX);
#elif EXERCISE == 6
    const int values[] = {1000, -1000, 7, -9, 3};
    assert(sum_index(NULL, 0) == 0 && sum_pointer(NULL, 0) == 0);
    assert(sum_index(values, 1) == 1000 && sum_pointer(values, 1) == 1000);
    assert(sum_index(values, 5) == 1 && sum_pointer(values, 5) == 1);
    int many[10000];
    for (size_t i = 0; i < 10000; ++i) many[i] = 1000;
    assert(sum_index(many, 10000) == 10000000L && sum_pointer(many, 10000) == 10000000L);
#elif EXERCISE == 7
    assert(valid_point((GeoPoint){0, 0, 0}));
    assert(valid_point((GeoPoint){UINT64_MAX, 90, 180}));
    assert(valid_point((GeoPoint){1, -90, -180}));
    assert(!valid_point((GeoPoint){1, 90.01, 0}));
    assert(!valid_point((GeoPoint){1, -90.01, 0}));
    assert(!valid_point((GeoPoint){1, 0, 180.01}));
    assert(!valid_point((GeoPoint){1, 0, -180.01}));
    assert(!valid_point((GeoPoint){1, NAN, 0}));
    assert(!valid_point((GeoPoint){1, 0, NAN}));
    assert(!valid_point((GeoPoint){1, INFINITY, 0}));
    assert(!valid_point((GeoPoint){1, 0, -INFINITY}));
#elif EXERCISE == 10
    unsigned f = set_flag(0, FLAG_READ);
    assert(f == FLAG_READ && has_flag(f, FLAG_READ) && !has_flag(f, FLAG_WRITE));
    assert(set_flag(f, FLAG_READ) == f);
    f = toggle_flag(f, FLAG_WRITE);
    assert(has_flag(f, FLAG_READ | FLAG_WRITE));
    assert(toggle_flag(f, FLAG_WRITE) == FLAG_READ);
    assert(clear_flag(f, FLAG_READ) == FLAG_WRITE);
    assert(clear_flag(0, FLAG_READ) == 0);
    assert(set_flag(UINT_MAX, FLAG_READ) == UINT_MAX);
#elif EXERCISE == 11
    unsigned long long out = 77;
    assert(allocated_sum(0, &out) && out == 0);
    assert(allocated_sum(1, &out) && out == 0);
    assert(allocated_sum(5, &out) && out == 10);
    assert(allocated_sum(101, &out) && out == 4950);
    assert(allocated_sum(1000000, &out) && out == 49500000);
    assert(!allocated_sum(1000001, &out) && out == 49500000);
    assert(!allocated_sum(SIZE_MAX, &out) && out == 49500000);
#elif EXERCISE == 13
    unsigned long long out = 55;
    assert(parse_decimal("00042", 100, &out) && out == 42);
    assert(parse_decimal("0", 0, &out) && out == 0);
    const char *bad[] = {"", "-1", "+1", " 1", "1 ", "1x", "1.0", "0x10", "1000001", "9999999999999999999999999999999999999999"};
    for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
        out = 55;
        assert(!parse_decimal(bad[i], 1000000, &out) && out == 55);
    }
    char maximum[64];
    (void)snprintf(maximum, sizeof maximum, "%llu", ULLONG_MAX);
    assert(parse_decimal(maximum, ULLONG_MAX, &out) && out == ULLONG_MAX);
#elif EXERCISE == 14
    const int values[] = {2, 4, 2, 2, 7};
    assert(count_equal(NULL, 0, 2) == 0);
    assert(count_equal(values, 5, 2) == 3);
    assert(count_equal(values, 5, 9) == 0);
    assert(count_equal(values, 1, 2) == 1);
#endif
    puts("contract passed");
    return 0;
}

/* W01: add without overflowing. Reference solution. */
#include <limits.h>
#include <stdio.h>

/* Stores a + b in *out and returns 1 when the sum is at most limit; otherwise returns 0 and
   leaves *out unchanged. The test is arranged so that nothing is ever computed that could
   exceed limit: b > limit - a is only evaluated once a <= limit is known. */
int checked_add(unsigned long long a, unsigned long long b, unsigned long long limit, unsigned long long *out)
{
    if (out == NULL || a > limit || b > limit - a) return 0;
    *out = a + b;
    return 1;
}

int main(void)
{
    const unsigned long long cases[][3] = {{2, 3, 10}, {7, 3, 10}, {7, 4, 10}, {ULLONG_MAX, 1, ULLONG_MAX}};
    for (int i = 0; i < 4; ++i) {
        unsigned long long out = 99;
        int ok = checked_add(cases[i][0], cases[i][1], cases[i][2], &out);
        printf("add(%llu, %llu, limit=%llu) -> ok=%d out=%llu\n", cases[i][0], cases[i][1], cases[i][2], ok, out);
    }
    return 0;
}

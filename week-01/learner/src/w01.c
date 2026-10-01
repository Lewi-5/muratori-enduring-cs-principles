/* W01: add without overflowing. Warm-up scaffold: fill in the TODO body. */
#include <limits.h>
#include <stdio.h>

int checked_add(unsigned long long a, unsigned long long b, unsigned long long limit, unsigned long long *out)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)a;
    (void)b;
    (void)limit;
    (void)out;
    return 0;
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

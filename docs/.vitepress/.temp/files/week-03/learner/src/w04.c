/* W04: which side? Warm-up scaffold: fill in the TODO body. */
#include <stdio.h>

int orientation(long long ax, long long ay, long long bx, long long by, long long cx, long long cy)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)ax;
    (void)ay;
    (void)bx;
    (void)by;
    (void)cx;
    (void)cy;
    return 2;
}

int main(void)
{
    printf("left=%d\n", orientation(0, 0, 4, 0, 1, 3));
    printf("right=%d\n", orientation(0, 0, 4, 0, 1, -3));
    printf("collinear=%d\n", orientation(0, 0, 4, 0, 8, 0));
    return 0;
}

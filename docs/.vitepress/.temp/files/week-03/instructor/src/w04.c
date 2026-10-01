/* W04: which side? Reference solution. */
#include <stdio.h>

/* Sign of the cross product (b - a) x (c - a) for integer points with every coordinate in
   [-2^30, 2^30]: +1 when c is to the left of the directed line a->b (a counter-clockwise turn),
   -1 when it is to the right, 0 when the three points are collinear. In that domain each
   difference fits in 32 bits and each product in 63, so long long arithmetic is exact. */
int orientation(long long ax, long long ay, long long bx, long long by, long long cx, long long cy)
{
    long long cross = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
    return (cross > 0) - (cross < 0);
}

int main(void)
{
    printf("left=%d\n", orientation(0, 0, 4, 0, 1, 3));
    printf("right=%d\n", orientation(0, 0, 4, 0, 1, -3));
    printf("collinear=%d\n", orientation(0, 0, 4, 0, 8, 0));
    return 0;
}

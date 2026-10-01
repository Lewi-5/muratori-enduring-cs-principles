#include <limits.h>
#include <stdio.h>

/* Returns 1 and stores a / b on success. Returns 0 and leaves *out untouched when the
   division is not defined: b == 0, or INT_MIN / -1 (the true result does not fit in int). */
static int safe_divide(int a, int b, int *out)
{
    if (b == 0 || (a == INT_MIN && b == -1)) return 0;
    *out = a / b;
    return 1;
}

int main(void)
{
    const int cases[][2] = {{7, 2}, {-7, 2}, {7, 0}, {INT_MIN, -1}};
    for (int i = 0; i < 4; ++i) {
        int out = 42; /* a sentinel: if it survives, the function did not write */
        int ok = safe_divide(cases[i][0], cases[i][1], &out);
        printf("%d / %d -> ok=%d out=%d\n", cases[i][0], cases[i][1], ok, out);
    }
    return 0;
}

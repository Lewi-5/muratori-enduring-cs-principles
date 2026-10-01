#include <math.h>
#include <stdio.h>

int main(void)
{
    const double at[] = {1.0, 2.0, 1000.0, 1e16};
    for (int i = 0; i < 4; ++i) {
        double x = at[i];
        double step = nextafter(x, INFINITY) - x;
        printf("next double after %-6g is %.17g larger\n", x, step);
    }
    double big = 1e16;
    printf("1e16 + 1 == 1e16 ? %s\n", big + 1.0 == big ? "yes" : "no");
    return 0;
}

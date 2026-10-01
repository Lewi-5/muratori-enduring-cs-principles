#include <stdio.h>

int main(void)
{
    double sum = 0.1 + 0.2;
    double target = 0.3;
    printf("0.1 + 0.2 = %.17g\n", sum);
    printf("0.3       = %.17g\n", target);
    printf("equal?      %s\n", sum == target ? "yes" : "no");
    return 0;
}

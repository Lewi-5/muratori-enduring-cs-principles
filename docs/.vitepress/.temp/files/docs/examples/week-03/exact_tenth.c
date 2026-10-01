#include <stdio.h>

int main(void)
{
    double tenth = 0.1;
    printf("%%a:    %a\n", tenth);
    printf("%%.55f: %.55f\n", tenth);
    printf("%%.17g: %.17g\n", tenth);
    printf("%%g:    %g\n", tenth);
    return 0;
}

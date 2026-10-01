#include <stdio.h>

int main(void)
{
    long long a = 100000001, b = 99999999;
    double da = 100000001.0, db = 99999999.0;
    printf("integer product: %lld\n", a * b);
    printf("double product:  %.17g\n", da * db);
    return 0;
}

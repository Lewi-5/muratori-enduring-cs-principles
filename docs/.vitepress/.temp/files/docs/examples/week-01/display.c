#include <stdio.h>

int main(void)
{
    int answer = 42;
    char digit = '4';
    printf("answer as %%d: %d  as %%x: %x  as %%o: %o\n", answer, answer, answer);
    printf("digit as %%c: %c  as %%d: %d\n", digit, digit);
    printf("digit - '0' = %d\n", digit - '0');
    return 0;
}

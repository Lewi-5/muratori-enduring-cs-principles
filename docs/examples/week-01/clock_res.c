#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <time.h>

int main(void)
{
    struct timespec res;
    if (clock_getres(CLOCK_MONOTONIC, &res) != 0) {
        perror("clock_getres");
        return 1;
    }
    printf("CLOCK_MONOTONIC resolution: %ld s + %ld ns\n", (long)res.tv_sec, res.tv_nsec);
    return 0;
}

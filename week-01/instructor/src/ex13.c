#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

int parse_decimal(const char *text, unsigned long long limit, unsigned long long *out)
{
    /* strtoull itself permits whitespace and a sign; our grammar does not. */
    if (*text == '\0') return 0;
    for (const char *p = text; *p != '\0'; ++p) if (*p < '0' || *p > '9') return 0;
    errno = 0;
    char *end;
    unsigned long long value = strtoull(text, &end, 10);
    if (errno == ERANGE || end == text || *end != '\0' || value > limit) return 0;
    *out = value;
    return 1;
}

int main(int argc, char **argv)
{
    unsigned long long value;
    if (argc != 2 || !parse_decimal(argv[1], 1000000ULL, &value)) {
        fputs("error: expected decimal digits in 0..1000000\n", stderr);
        return 1;
    }
    printf("value=%llu\n", value);
    return 0;
}

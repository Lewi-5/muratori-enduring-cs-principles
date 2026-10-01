#ifndef WEEK01_DECIMAL_H
#define WEEK01_DECIMAL_H
#include <stddef.h>

/* Supplied CLI plumbing for ex03/ex11, not the strtoull exercise.
   Decimal digits only. Check before multiplying; leave output unchanged on error. */
static int decimal_size(const char *text, size_t limit, size_t *out)
{
    size_t value = 0;
    if (*text == '\0') return 0;
    for (; *text != '\0'; ++text) {
        if (*text < '0' || *text > '9') return 0;
        size_t digit = (size_t)(*text - '0');
        if (digit > limit || value > (limit - digit) / 10) return 0;
        value = value * 10 + digit;
    }
    *out = value;
    return 1;
}
#endif

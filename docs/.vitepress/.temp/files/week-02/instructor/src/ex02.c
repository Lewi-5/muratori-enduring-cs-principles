#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>

/* BEGIN ALIGNMENT HELPERS */
int is_power_of_two(size_t value)
{
    return value != 0 && (value & (value - 1)) == 0;
}

int align_up(size_t value, size_t alignment, size_t *out)
{
    if (out == NULL || !is_power_of_two(alignment)) return 0;
    size_t mask = alignment - 1;
    if (value > SIZE_MAX - mask) return 0;
    *out = (value + mask) & ~mask;
    return 1;
}
/* END ALIGNMENT HELPERS */

int main(void)
{
#define SHOW(name, type) printf("type=%s size=%zu align=%zu\n", name, sizeof(type), alignof(type))
    SHOW("char", char); SHOW("short", short); SHOW("int", int);
    SHOW("long", long); SHOW("llong", long long); SHOW("float", float);
    SHOW("double", double); SHOW("ldouble", long double); SHOW("ptr", void *);
    SHOW("max_align_t", max_align_t);
#undef SHOW
    return 0;
}

#include <stddef.h>
#include <stdint.h>
#include <stdalign.h>
#include <stdio.h>

/* BEGIN ALIGNMENT HELPERS */
int is_power_of_two(size_t value)
{
    /* TODO: implement the corresponding learner contract. */
    (void)value; return 0;
}

int align_up(size_t value, size_t alignment, size_t *out)
{
    /* TODO: implement the corresponding learner contract. */
    (void)value; (void)alignment; (void)out; return 0;
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

#include <stdio.h>

#define FLAG_READ (1u << 0)
#define FLAG_WRITE (1u << 1)

unsigned set_flag(unsigned flags, unsigned mask) { return flags | mask; }
int has_flag(unsigned flags, unsigned mask) { return (flags & mask) == mask; }
unsigned toggle_flag(unsigned flags, unsigned mask) { return flags ^ mask; }
unsigned clear_flag(unsigned flags, unsigned mask) { return flags & ~mask; }

int main(void)
{
    unsigned flags = set_flag(0u, FLAG_READ);
    printf("set=%u test=%d ", flags, has_flag(flags, FLAG_READ));
    flags = toggle_flag(flags, FLAG_WRITE);
    printf("toggle=%u clear=%u\n", flags, clear_flag(flags, FLAG_READ));
    return 0;
}

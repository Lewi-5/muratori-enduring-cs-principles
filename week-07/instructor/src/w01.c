#include <stddef.h>
#include <stdint.h>
unsigned address_bytes(unsigned mod, unsigned rm)
{
    if (mod > 2 || rm > 7) return 99u;
    return mod == 1 ? 1u : (mod == 2 || rm == 6 ? 2u : 0u);
}

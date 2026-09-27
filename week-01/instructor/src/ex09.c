#include <limits.h>
#include <stdint.h>
#include <stdio.h>

int main(void)
{
    uint32_t value = UINT32_C(0x01020304);
    /* Character lvalues may inspect any object's representation. */
    const unsigned char *bytes = (const unsigned char *)&value;
    printf("char_bits=%d bytes=%zu\n", CHAR_BIT, sizeof value);
    for (size_t i = 0; i < sizeof value; ++i) printf("%02x%s", (unsigned)bytes[i], i + 1 == sizeof value ? "\n" : " ");
    const char *order = "other";
    if (CHAR_BIT == 8 && sizeof value == 4) {
        if (bytes[0] == 4 && bytes[1] == 3 && bytes[2] == 2 && bytes[3] == 1) order = "little";
        if (bytes[0] == 1 && bytes[1] == 2 && bytes[2] == 3 && bytes[3] == 4) order = "big";
    }
    printf("order=%s\n", order);
    return 0;
}

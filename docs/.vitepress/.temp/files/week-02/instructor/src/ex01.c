#include <limits.h>
#include <stdint.h>
#include <stdio.h>

int format_bytes(const void *object, size_t size, char *out, size_t out_size)
{
    /* This formatter deliberately supports octets only. Validate before writing. */
    if (CHAR_BIT != 8 || out == NULL || (size != 0 && object == NULL)) return 0;
    if (size == 0) {
        if (out_size == 0) return 0;
        out[0] = '\0';
        return 1;
    }
    if (size > SIZE_MAX / 3 || out_size < size * 3) return 0;
    const unsigned char *bytes = object;
    const char hex[] = "0123456789abcdef";
    for (size_t i = 0; i < size; ++i) {
        out[3 * i] = hex[bytes[i] >> 4];
        out[3 * i + 1] = hex[bytes[i] & 15u];
        out[3 * i + 2] = i + 1 == size ? '\0' : ' ';
    }
    return 1;
}

int main(void)
{
    if (CHAR_BIT != 8) { puts("octet_formatter=skipped"); return 0; }
    const unsigned char raw[] = {0, 0x7f, 0x80, 0xff};
    uint32_t u = UINT32_C(0x01020304);
    int32_t s = -2;
    char text[12];
    if (!format_bytes(raw, sizeof raw, text, sizeof text)) return 1;
    printf("raw=%s\n", text);
    if (!format_bytes(&u, sizeof u, text, sizeof text)) return 1;
    printf("u32=%s\n", text);
    if (!format_bytes(&s, sizeof s, text, sizeof text)) return 1;
    printf("i32=%s\n", text);
    return 0;
}

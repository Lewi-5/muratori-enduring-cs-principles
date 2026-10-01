#include <limits.h>
#include <stdint.h>
#include <stdio.h>

int format_bytes(const void *object, size_t size, char *out, size_t out_size)
{
    /* TODO: implement the corresponding learner contract. */
    (void)object; (void)size; (void)out; (void)out_size; return 0;
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

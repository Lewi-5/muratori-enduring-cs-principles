/* W01: the bytes of a double. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

/* The 64-bit pattern of a binary64 value. memcpy copies the object representation;
   reading the double through a uint64_t pointer would break the effective-type rules. */
int double_bits(double value, uint64_t *out)
{
    if (out == NULL || !GEO_IEC559) return 0;
    memcpy(out, &value, sizeof *out);
    return 1;
}

/* The same bytes, in the order they sit in memory (lowest address first). */
int double_bytes(double value, unsigned char out[sizeof(double)])
{
    if (out == NULL) return 0;
    memcpy(out, &value, sizeof value);
    return 1;
}

int main(void)
{
    struct { const char *name; double value; } const samples[] = {{"1.0", 1.0}, {"-2.0", -2.0}, {"0.5", 0.5}};
    puts(GEO_IEC559 ? "ieee754_binary64=checked" : "ieee754_binary64=skipped");
    if (!GEO_IEC559) return 0;
    for (size_t i = 0; i < sizeof samples / sizeof samples[0]; ++i) {
        uint64_t bits;
        unsigned char bytes[sizeof(double)];
        if (!double_bits(samples[i].value, &bits) || !double_bytes(samples[i].value, bytes)) return 1;
        printf("value=%s bits=0x%016" PRIX64 " memory=", samples[i].name, bits);
        for (size_t b = 0; b < sizeof bytes; ++b) printf("%02X%s", bytes[b], b + 1 < sizeof bytes ? " " : "\n");
    }
    return 0;
}

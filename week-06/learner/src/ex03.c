/* E03: immediates and signs. Implement read_imm, to_signed and sign_extend8; the driver is supplied. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)
{
    /* TODO: 1 or 2 bytes, little-endian, assembled by arithmetic (no memcpy). Reject NULL pointers, a size other than
       1 or 2, and any read past avail, testing offset <= avail && size <= avail - offset (never offset + size). */
    (void)bytes;
    (void)avail;
    (void)offset;
    (void)size;
    (void)out;
    return 0;
}

int32_t to_signed(uint16_t value, unsigned wide)
{
    /* TODO: the signed value of an 8-bit (wide == 0) or 16-bit (wide == 1) pattern, by arithmetic, never by a
       narrowing cast such as (int16_t)value (implementation-defined for values above 0x7FFF). */
    (void)value;
    (void)wide;
    return 0;
}

uint16_t sign_extend8(uint8_t value)
{
    /* TODO: copy bit 7 into bits 8..15 */
    (void)value;
    return 0;
}

int main(void)
{
    static const uint8_t stream[] = {0x34, 0x12, 0xFE, 0xFF, 0x80};
    uint16_t v = 0;
    if (read_imm(stream, sizeof stream, 0, 2, &v)) printf("read16@0=0x%04X\n", (unsigned)v);
    if (read_imm(stream, sizeof stream, 2, 2, &v)) printf("read16@2=0x%04X signed=%ld\n", (unsigned)v, (long)to_signed(v, 1));
    printf("read16@4 rejected=%d\n", !read_imm(stream, sizeof stream, 4, 2, &v));
    uint16_t ext = sign_extend8(0xFE);
    printf("sign_extend8(0xFE)=0x%04X to_signed8(0xFE)=%ld to_signed16=%ld\n", (unsigned)ext, (long)to_signed(0xFE, 0),
           (long)to_signed(ext, 1));
    return 0;
}

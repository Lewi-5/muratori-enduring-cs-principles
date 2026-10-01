/* E03: immediates and signs. Reference solution. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

/* Read a 1- or 2-byte little-endian value at bytes[offset]. The bounds test is written as
   offset <= avail && size <= avail - offset, so that offset + size is never computed (it could wrap for an offset
   near SIZE_MAX). The 16-bit value is assembled from the bytes by arithmetic, which gives the 8086's value on any
   host; memcpy into a uint16_t would give the HOST's byte order instead (C11 6.2.6.1 leaves it unspecified).
   lo | (hi << 8) is computed on promoted int values no larger than 0xFFFF, so nothing can overflow. */
int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)
{
    if (bytes == NULL || out == NULL || (size != 1 && size != 2)) return 0;
    if (offset > avail || size > avail - offset) return 0;
    if (size == 1) {
        *out = bytes[offset];
    } else {
        unsigned lo = bytes[offset], hi = bytes[offset + 1];
        *out = (uint16_t)(lo | (hi << 8));
    }
    return 1;
}

/* The signed value of an 8-bit (wide == 0) or 16-bit (wide == 1) two's-complement pattern. Precondition: wide is
   0 or 1, and value <= 0xFF when wide == 0. The conversion is arithmetic: (int16_t)value for value > 0x7FFF would
   be implementation-defined (C11 6.3.1.3 para 3). Outside the precondition the result is the documented fallback
   of the 16-bit reading. */
int32_t to_signed(uint16_t value, unsigned wide)
{
    if (wide == 0) {
        uint16_t v = (uint16_t)(value & 0xFFu);
        return v >= 0x80u ? (int32_t)v - 0x100 : (int32_t)v;
    }
    return value >= 0x8000u ? (int32_t)value - 0x10000 : (int32_t)value;
}

/* Sign extension from 8 to 16 bits: copy bit 7 into bits 8..15. 0xFE -> 0xFFFE (both mean -2). */
uint16_t sign_extend8(uint8_t value)
{
    return (uint16_t)(value & 0x80u ? 0xFF00u | value : value);
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

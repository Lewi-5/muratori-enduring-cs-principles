/* E01: read the address DESCRIPTION; never evaluate a guest register. */
#include "address.h"
DecodeStatus decode_address(const uint8_t *bytes, size_t avail, unsigned mod,
                            unsigned rm, Address *out, unsigned *used)
{
    if (!out || !used || (!bytes && avail) || mod > 2 || rm > 7)
        return DEC_INVALID_ARGUMENT;
    Address a = {0, rm, 0, 0};
    unsigned n = mod == 1 ? 1u : (mod == 2 || rm == 6 ? 2u : 0u);
    if (n > avail) return DEC_TRUNCATED;
    unsigned raw = n ? bytes[0] : 0u;
    if (n == 2) raw |= (unsigned)bytes[1] << 8;
    if (mod == 0 && rm == 6) {
        a.direct = 1;
        a.rm = 0;
        a.address = (uint16_t)raw;
    } else if (n) {
        unsigned sign = n == 1 ? 128u : 32768u;
        a.displacement = (int32_t)raw - (raw >= sign ? (n == 1 ? 256 : 65536) : 0);
    }
    *out = a;
    *used = n;
    return DEC_OK;
}

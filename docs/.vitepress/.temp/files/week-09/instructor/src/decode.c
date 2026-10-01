#include "machine.h"
static int32_t signed_pattern(unsigned value, unsigned bits)
{
    unsigned sign=1u << (bits-1u), modulus=1u << bits;
    return value<sign ? (int32_t)value : (int32_t)value-(int32_t)modulus;
}
MachineStatus machine_decode(const uint8_t *bytes, size_t n, Decoded *out)
{
    if (!out || (!bytes && n)) return M_ARGUMENT;
    if (!n) return M_DECODE;
    Decoded d={0};
    unsigned op=bytes[0];
    d.length=1;
    if (op==0xe9 || op==0xeb || (op>=0x70 && op<=0x7f)) {
        unsigned bits=op==0xe9 ? 16u : 8u;
        d.length=bits==16 ? 3u : 2u;
        if (n<d.length) return M_DECODE;
        unsigned pattern=bytes[1];
        if (bits==16) pattern|=(unsigned)bytes[2] << 8;
        d.relative=signed_pattern(pattern,bits);
        d.kind=op>=0x70 && op<=0x7f ? X_JCC : X_JMP;
        if (d.kind==X_JCC) d.condition=op-0x70u;
    } else {
        d.kind=X_BASE;
        if (decode_one(bytes,n,&d.base)!=DEC_OK) return M_DECODE;
        d.length=d.base.length;
    }
    *out=d;
    return M_OK;
}

int machine_condition(unsigned code, uint16_t flags)
{
    int c=(flags & FLAG_CF)!=0, z=(flags & FLAG_ZF)!=0;
    int s=(flags & FLAG_SF)!=0, o=(flags & FLAG_OF)!=0, p=(flags & FLAG_PF)!=0;
    switch (code) {
    case 0: return o; case 1: return !o; case 2: return c; case 3: return !c;
    case 4: return z; case 5: return !z; case 6: return c || z; case 7: return !c && !z;
    case 8: return s; case 9: return !s; case 10: return p; case 11: return !p;
    case 12: return s!=o; case 13: return s==o; case 14: return z || s!=o;
    case 15: return !z && s==o;
    }
    return -1;
}

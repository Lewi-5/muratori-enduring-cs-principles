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
    if (op>=0x50 && op<=0x57) { d.kind=X_PUSH; d.reg=op-0x50u; }
    else if (op>=0x58 && op<=0x5f) { d.kind=X_POP; d.reg=op-0x58u; }
    else if (op>=0x40 && op<=0x47) { d.kind=X_INC; d.reg=op-0x40u; }
    else if (op>=0x48 && op<=0x4f) { d.kind=X_DEC; d.reg=op-0x48u; }
    else if (op==0xc3) d.kind=X_RET;
    else if (op==0x90) d.kind=X_NOP;
    else if (op==0xe8 || op==0xe9 || op==0xeb || (op>=0x70 && op<=0x7f)) {
        unsigned bits=op==0xe8 || op==0xe9 ? 16u : 8u;
        d.length=bits==16 ? 3u : 2u;
        if (n<d.length) return M_DECODE;
        unsigned pattern=bytes[1];
        if (bits==16) pattern|=(unsigned)bytes[2] << 8;
        d.relative=signed_pattern(pattern,bits);
        d.kind=op==0xe8 ? X_CALL : op>=0x70 && op<=0x7f ? X_JCC : X_JMP;
        if (d.kind==X_JCC) d.condition=op-0x70u;
    } else {
        d.kind=X_BASE;
        if (decode_one(bytes,n,&d.base)!=DEC_OK) return M_DECODE;
        d.length=d.base.length;
    }
    *out=d;
    return M_OK;
}

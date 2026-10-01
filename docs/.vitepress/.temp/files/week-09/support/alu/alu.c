/* E02 reference: the guest result wraps; host signed overflow is never used. */
#include "sim.h"
int sim_alu(Operation op, unsigned wide, uint16_t left, uint16_t right, AluResult *out)
{
    if (!out || wide>1 || (op!=OP_ADD && op!=OP_SUB && op!=OP_CMP)) return 0;
    uint32_t mask=wide ? 65535u : 255u, sign=wide ? 32768u : 128u;
    uint32_t a=left, b=right;
    if (a>mask || b>mask) return 0;
    /* Maximum word sum fits uint32_t. Unsigned subtraction wrap is defined;
       retaining low 8/16 bits gives the guest subtraction pattern. */
    uint32_t full=op==OP_ADD ? a+b : a-b;
    uint32_t r=full & mask;
    unsigned flags=0;
    if (op==OP_ADD ? full>mask : a<b) flags|=FLAG_CF;
    /* ADD overflows when equal-sign inputs change sign; SUB when unlike-sign
       inputs change the destination sign. AF tracks the bit-four boundary. */
    if ((op==OP_ADD ? (~(a^b) & (a^r)) : ((a^b) & (a^r))) & sign) flags|=FLAG_OF;
    if ((a^b^r) & 16u) flags|=FLAG_AF;
    if (!r) flags|=FLAG_ZF;
    if (r & sign) flags|=FLAG_SF;
    unsigned ones=0;
    /* Word high bits never participate in PF. Zero has even parity. */
    for (unsigned bit=0; bit<8; ++bit) ones+=(unsigned)((r >> bit) & 1u);
    if (!(ones & 1u)) flags|=FLAG_PF;
    AluResult result={(uint16_t)r,(uint16_t)flags};
    *out=result;
    return 1;
}

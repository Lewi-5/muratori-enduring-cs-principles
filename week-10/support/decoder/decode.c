/* E02: extend week 6's opcode families; centralize the r/m operand. */
#include "decode.h"
#include "address.h"
static int read_value(const uint8_t *b, size_t n, unsigned at, unsigned count, unsigned *out)
{
    if (at > n || count > n - at) return 0;
    unsigned raw = b[at];
    if (count == 2) raw |= (unsigned)b[at + 1] << 8;
    *out = raw;
    return 1;
}
static int32_t signed_value(unsigned raw, unsigned count)
{
    unsigned sign = count == 1 ? 128u : 32768u;
    return (int32_t)raw - (raw >= sign ? (count == 1 ? 256 : 65536) : 0);
}
static Operand reg_operand(unsigned w, unsigned r)
{
    Operand o = {0}; o.kind = OPERAND_REG; o.wide = w; o.reg = r; return o;
}
static Operand imm_operand(unsigned w, int32_t v)
{
    Operand o = {0}; o.kind = OPERAND_IMM; o.wide = w; o.imm = v; return o;
}
static int arithmetic(unsigned code, Operation *op)
{
    if (code == 0) *op = OP_ADD;
    else if (code == 5) *op = OP_SUB;
    else if (code == 7) *op = OP_CMP;
    else return 0;
    return 1;
}
unsigned decoder_api_version(void) { return DEC_API_VERSION; }
DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out)
{
    if (!out || (!bytes && avail)) return DEC_INVALID_ARGUMENT;
    if (!avail) return DEC_TRUNCATED;
    unsigned b = bytes[0], w = b & 1u, raw;
    Instruction ins = {0};
    if ((b & 0xf0u) == 0xb0u) {
        w = (b >> 3) & 1u;
        unsigned count = w ? 2u : 1u;
        if (!read_value(bytes, avail, 1, count, &raw)) return DEC_TRUNCATED;
        ins.op = OP_MOV; ins.dst = reg_operand(w, b & 7u);
        ins.src = imm_operand(w, signed_value(raw, count)); ins.length = 1u + count;
    } else if ((b & 0xfeu) == 0x04u || (b & 0xfeu) == 0x2cu || (b & 0xfeu) == 0x3cu) {
        unsigned count = w ? 2u : 1u;
        if (!read_value(bytes, avail, 1, count, &raw)) return DEC_TRUNCATED;
        (void)arithmetic((b >> 3) & 7u, &ins.op);
        ins.dst = reg_operand(w, 0); ins.src = imm_operand(w, signed_value(raw, count));
        ins.length = 1u + count;
    } else if ((b & 0xfcu) == 0xa0u) {
        if (!read_value(bytes, avail, 1, 2, &raw)) return DEC_TRUNCATED;
        Operand mem = {0}; mem.kind = OPERAND_MEM; mem.wide = w;
        mem.memory.direct = 1; mem.memory.address = (uint16_t)raw;
        ins.op = OP_MOV;
        ins.dst = (b & 2u) ? mem : reg_operand(w, 0);
        ins.src = (b & 2u) ? reg_operand(w, 0) : mem; ins.length = 3;
    } else {
        int pair = (b & 0xfcu) == 0x88u;
        int group = b == 0x80u || b == 0x81u || b == 0x83u;
        int mov_imm = b == 0xc6u || b == 0xc7u;
        ins.op = OP_MOV;
        if (!pair && ((b & 0xfcu) == 0x00u || (b & 0xfcu) == 0x28u || (b & 0xfcu) == 0x38u)) {
            pair = 1; (void)arithmetic((b >> 3) & 7u, &ins.op);
        }
        if (!pair && !group && !mov_imm) return DEC_UNSUPPORTED_OPCODE;
        if (avail < 2) return DEC_TRUNCATED;
        unsigned mod = bytes[1] >> 6, reg = (bytes[1] >> 3) & 7u, rm = bytes[1] & 7u;
        /* Operation is known at this point, before asking for displacement. */
        if (group && !arithmetic(reg, &ins.op)) return DEC_UNSUPPORTED_OPERATION;
        if (mov_imm && reg != 0) return DEC_UNSUPPORTED_OPERATION;
        Operand target = reg_operand(w, rm);
        unsigned used = 0;
        if (mod != 3) {
            target.kind = OPERAND_MEM;
            DecodeStatus status = decode_address(bytes + 2, avail - 2, mod, rm, &target.memory, &used);
            if (status != DEC_OK) return status;
        }
        unsigned at = 2u + used;
        if (pair) {
            unsigned d = (b >> 1) & 1u;
            ins.dst = d ? reg_operand(w, reg) : target;
            ins.src = d ? target : reg_operand(w, reg);
            ins.length = at;
        } else {
            unsigned count = b == 0x83u || !w ? 1u : 2u;
            if (!read_value(bytes, avail, at, count, &raw)) return DEC_TRUNCATED;
            ins.dst = target; ins.src = imm_operand(w, signed_value(raw, count));
            ins.length = at + count;
        }
    }
    *out = ins;
    return DEC_OK;
}

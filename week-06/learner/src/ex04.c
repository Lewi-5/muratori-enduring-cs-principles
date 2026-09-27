/* E04: decoding one instruction. Implement decode_one; the driver is supplied. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "decode_types.h"

/* ---- copy your E01-E03 helpers here (keep them non-static, so an unused copy never trips -Werror) ---- */
typedef struct { unsigned mod, reg, rm; } ModRM;

ModRM split_modrm(uint8_t byte)
{
    (void)byte;
    ModRM m = {0, 0, 0};
    return m; /* TODO: paste E01 */
}

int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)
{
    (void)bytes;
    (void)avail;
    (void)offset;
    (void)size;
    (void)out;
    return 0; /* TODO: paste E03 */
}

int32_t to_signed(uint16_t value, unsigned wide)
{
    (void)value;
    (void)wide;
    return 0; /* TODO: paste E03 */
}

uint16_t sign_extend8(uint8_t value)
{
    (void)value;
    return 0; /* TODO: paste E03 */
}

/* ---- E04 ---- */

/* TODO: decode the first instruction of bytes[0..avail) for the course subset (learner/exercises.md), following the
   status order exactly: no byte -> DEC_TRUNCATED; opcode outside the subset -> DEC_UNSUPPORTED_OPCODE; ModR/M needed
   but missing -> DEC_TRUNCATED; mod != 11 -> DEC_UNSUPPORTED_MODE; 0x80/0x81/0x83 with reg not 000/101/111 ->
   DEC_UNSUPPORTED_OPERATION; immediate bytes missing -> DEC_TRUNCATED. NULL out, or NULL bytes with avail > 0, is
   DEC_INVALID_ARGUMENT. Check that every byte exists before reading it. Write *out only on DEC_OK. */
DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out)
{
    (void)bytes;
    (void)avail;
    (void)out;
    return DEC_INVALID_ARGUMENT;
}

int main(void)
{
    static const uint8_t samples[][4] = {{0x89, 0xD9}, {0x8B, 0xCB}, {0xB1, 0x0C}, {0xB9, 0xF4, 0xFF}, {0x83, 0xC6, 0xFE},
                                         {0x80, 0xC1, 0xFE}, {0x82, 0xC1, 0x05}, {0x88, 0x07}, {0x81, 0xC6}};
    static const size_t lengths[] = {2, 2, 2, 3, 3, 3, 3, 2, 2};
    static const char *const names[] = {"mov", "add", "sub", "cmp"};
    for (size_t i = 0; i < sizeof lengths / sizeof lengths[0]; ++i) {
        Instruction ins;
        DecodeStatus s = decode_one(samples[i], lengths[i], &ins);
        printf("bytes=");
        for (size_t k = 0; k < lengths[i]; ++k) printf("%02X", samples[i][k]);
        if (s != DEC_OK) {
            printf(" status=%s\n", decode_status_name(s));
            continue;
        }
        printf(" status=DEC_OK op=%s length=%u dst=%s%u:%u src=%s", names[ins.op], ins.length,
               ins.dst.kind == OPERAND_REG ? "reg" : "imm", ins.dst.wide, ins.dst.reg,
               ins.src.kind == OPERAND_REG ? "reg" : "imm");
        if (ins.src.kind == OPERAND_REG) printf("%u:%u\n", ins.src.wide, ins.src.reg);
        else printf("%ld\n", (long)ins.src.imm);
    }
    return 0;
}

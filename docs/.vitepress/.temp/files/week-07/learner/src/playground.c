/* Supplied driver: describe a memory operand, never access guest memory. */
#include <stdio.h>
#include "decode.h"
int main(void)
{
    const uint8_t examples[][6] = {
        {0x8b,0x46,0xfe}, {0x8b,0x06,0xfe,0xff},
        {0x83,0x80,0x00,0x80,0xfe}, {0xc7,0x86,0x00,0x80,0x00,0x80}};
    const unsigned lengths[] = {3,4,5,6};
    for (unsigned k = 0; k < 4; ++k) {
        Instruction ins;
        char text[DEC_MAX_TEXT];
        DecodeStatus s = decode_one(examples[k], lengths[k], &ins);
        if (s != DEC_OK || !format_instruction(&ins, text, sizeof text)) return 1;
        printf("length=%u %s\n", ins.length, text);
    }
    return 0;
}

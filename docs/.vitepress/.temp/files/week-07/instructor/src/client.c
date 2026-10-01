/* E04: separately compiled client, linked against the shared library. */
#include <stdio.h>
#include "decode.h"
int main(void)
{
    const uint8_t bytes[] = {0x8b,0x46,0xfe};
    Instruction ins; char text[DEC_MAX_TEXT];
    if (decoder_api_version() != DEC_API_VERSION ||
        decode_one(bytes, sizeof bytes, &ins) != DEC_OK ||
        !format_instruction(&ins, text, sizeof text)) return 1;
    printf("api=%u %s\n", decoder_api_version(), text);
    return 0;
}

// From week-07: gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -Iinclude
// instructor/extras/roundtrip.c build/instructor/gcc/debug/*.o -o /tmp/roundtrip
// /tmp/roundtrip
#include <stdio.h>
#include <string.h>
#include "decode.h"
int main(void)
{
    const uint8_t encodings[][4]={{0x8b,0x40,0},{0x8b,0x80,0,0},{0x8b,0}};
    const size_t lengths[]={3,4,2};
    char first[DEC_MAX_TEXT];
    for (unsigned k=0; k<3; ++k) {
        Instruction ins; char text[DEC_MAX_TEXT];
        if (decode_one(encodings[k],lengths[k],&ins)!=DEC_OK ||
            !format_instruction(&ins,text,sizeof text)) return 1;
        if (!k) strcpy(first,text);
        else if (strcmp(first,text)) return 1;
        printf("length=%u %s\n",ins.length,text);
    }
    return 0;
}

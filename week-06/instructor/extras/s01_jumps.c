/* S01: conditional jumps and loops. Link with the reference decode.o:
     gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -Iinstructor/src -Isupport instructor/extras/s01_jumps.c \
         build/instructor/gcc/debug/decode.o -o build/s01_jumps && ./build/s01_jumps FILE
   Prints a listing like decode8086, adding the twenty short-branch opcodes 0x70-0x7F and 0xE0-0xE3. Each is two
   bytes: the opcode and a signed 8-bit displacement relative to the NEXT instruction. The course prints the target
   relative to the START of the branch, as NASM's `$` does: target = $ + 2 + displacement, so 75 FC is "jnz $-2". */
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"

static const char *jump_name(unsigned opcode)
{
    static const char *const cc[16] = {"jo", "jno", "jb", "jnb", "jz", "jnz", "jbe", "ja",
                                       "js", "jns", "jp", "jnp", "jl", "jnl", "jle", "jg"};
    static const char *const loops[4] = {"loopnz", "loopz", "loop", "jcxz"};
    if (opcode >= 0x70u && opcode <= 0x7Fu) return cc[opcode - 0x70u];
    if (opcode >= 0xE0u && opcode <= 0xE3u) return loops[opcode - 0xE0u];
    return NULL;
}

/* Decode one instruction including branches. Writes the text and length on DEC_OK. */
static DecodeStatus decode_with_jumps(const uint8_t *bytes, size_t avail, char *text, size_t size, unsigned *length)
{
    if (avail > 0 && jump_name(bytes[0]) != NULL) {
        if (avail < 2) return DEC_TRUNCATED;
        unsigned raw = bytes[1];
        int32_t disp = raw >= 0x80u ? (int32_t)raw - 0x100 : (int32_t)raw; /* arithmetic, not a narrowing cast */
        int32_t rel = 2 + disp;
        snprintf(text, size, "%s $%c%ld", jump_name(bytes[0]), rel >= 0 ? '+' : '-', (long)(rel >= 0 ? rel : -rel));
        *length = 2;
        return DEC_OK;
    }
    Instruction ins;
    DecodeStatus s = decode_one(bytes, avail, &ins);
    if (s != DEC_OK) return s;
    if (!format_instruction(&ins, text, size)) return DEC_INVALID_ARGUMENT;
    *length = ins.length;
    return DEC_OK;
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: s01_jumps FILE\n");
        return 1;
    }
    static uint8_t data[DEC_MAX_INPUT];
    FILE *f = fopen(argv[1], "rb");
    if (f == NULL) return 1;
    size_t n = fread(data, 1, sizeof data, f);
    int bad = ferror(f);
    fclose(f);
    if (bad) return 1;
    printf("bits 16\n");
    for (size_t pos = 0; pos < n;) {
        char text[DEC_MAX_TEXT];
        unsigned length = 0;
        DecodeStatus s = decode_with_jumps(data + pos, n - pos, text, sizeof text, &length);
        if (s != DEC_OK) {
            printf("; %s at offset %zu\n", decode_status_name(s), pos);
            return 1;
        }
        printf("%s\n", text);
        pos += length;
    }
    return 0;
}

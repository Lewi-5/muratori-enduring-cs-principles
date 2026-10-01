#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"

static const char STREAM_HEADER[] = "bits 16\n";

/* Two passes over the same bytes. Pass 1 decodes and formats every instruction into a scratch buffer only to count
   the output (checked size_t arithmetic: each line is at most DEC_MAX_TEXT bytes, and the running total is compared
   with SIZE_MAX before adding), and stops at the first decoding failure. Pass 2 runs only when everything decoded
   and fits, and writes the text. Decoding is a pure function of the bytes, so both passes see the same
   instructions. An instruction stream is decoded from its start: the length of each instruction decides where the
   next begins, so there is no way to resynchronize at an arbitrary offset. */
DecodeStatus decode_stream(const uint8_t *bytes, size_t n, char *text, size_t text_size, size_t *text_len,
                           size_t *error_offset)
{
    if ((bytes == NULL && n > 0) || text == NULL || text_len == NULL || error_offset == NULL) return DEC_INVALID_ARGUMENT;
    size_t need = sizeof STREAM_HEADER - 1; /* visible bytes so far */
    size_t pos = 0;
    while (pos < n) {
        Instruction ins;
        DecodeStatus s = decode_one(bytes + pos, n - pos, &ins);
        if (s != DEC_OK) {
            *error_offset = pos;
            return s;
        }
        char line[DEC_MAX_TEXT];
        if (!format_instruction(&ins, line, sizeof line)) return DEC_INVALID_ARGUMENT; /* unreachable */
        size_t len = strlen(line) + 1; /* plus the newline */
        if (need > SIZE_MAX - len) return DEC_OUTPUT_TOO_SMALL;
        need += len;
        pos += ins.length;
    }
    if (need >= text_size) return DEC_OUTPUT_TOO_SMALL; /* need + 1 bytes are required, for the NUL */
    memcpy(text, STREAM_HEADER, sizeof STREAM_HEADER - 1);
    size_t at = sizeof STREAM_HEADER - 1;
    for (pos = 0; pos < n;) {
        Instruction ins;
        (void)decode_one(bytes + pos, n - pos, &ins); /* succeeded in pass 1 on the same bytes */
        char line[DEC_MAX_TEXT];
        (void)format_instruction(&ins, line, sizeof line);
        size_t len = strlen(line);
        memcpy(text + at, line, len);
        at += len;
        text[at++] = '\n';
        pos += ins.length;
    }
    text[at] = '\0';
    *text_len = at;
    *error_offset = n;
    return DEC_OK;
}

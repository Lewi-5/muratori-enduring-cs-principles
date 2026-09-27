/* decode.c: the decoder library (E06). Paste your E01-E05 code here, make every helper static, and keep only the
   three functions declared in decode.h external (`make symbols` checks it). Then implement decode_stream. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"

DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out)
{
    (void)bytes;
    (void)avail;
    (void)out;
    return DEC_INVALID_ARGUMENT; /* TODO: paste E04 */
}

int format_instruction(const Instruction *ins, char *out, size_t size)
{
    (void)ins;
    (void)out;
    (void)size;
    return 0; /* TODO: paste E05 */
}

/* TODO (E06.C): the contract is in decode.h. First validate the arguments; then a first pass decodes every
   instruction and counts the output with checked size_t arithmetic (stop at the first failure and report its
   offset); only when everything decoded and the text plus its NUL fits, a second pass writes the header line
   "bits 16" and one line per instruction, each ending in a newline. Leave every output you must not change untouched on each failure. */
DecodeStatus decode_stream(const uint8_t *bytes, size_t n, char *text, size_t text_size, size_t *text_len,
                           size_t *error_offset)
{
    (void)bytes;
    (void)n;
    (void)text;
    (void)text_size;
    (void)text_len;
    (void)error_offset;
    return DEC_INVALID_ARGUMENT;
}

#ifndef WEEK06_DECODE_H
#define WEEK06_DECODE_H
/* The week-6 decoder library (E06): three functions over the course subset. Supplied header; week 7 turns this into
   a documented public API. Library functions never print and never exit. */
#include <stddef.h>
#include <stdint.h>
#include "decode_types.h"

/* Decode the first instruction of bytes[0..avail). DEC_OK writes *out; any other status leaves *out unchanged.
   NULL out, or NULL bytes with avail > 0, is DEC_INVALID_ARGUMENT. */
DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out);

/* Canonical text of a valid instruction into out (with NUL). Returns 1, or 0 with out unchanged. */
int format_instruction(const Instruction *ins, char *out, size_t size);

/* Decode bytes[0..n) completely and write "bits 16\n" followed by one canonical line per instruction, each ending in
   "\n", then a NUL, into text[0..text_size).
   - bytes may be NULL only when n == 0; text, text_len and error_offset must not be NULL (DEC_INVALID_ARGUMENT).
   - A first pass validates every instruction and counts the output with checked size_t arithmetic; nothing is
     written unless the whole stream decodes and the text (with its NUL) fits.
   - Byte-decoding failure: returns that status, sets *error_offset to the failing instruction's first byte, and
     leaves text and *text_len unchanged.
   - DEC_OUTPUT_TOO_SMALL or DEC_INVALID_ARGUMENT: every caller output is left unchanged.
   - Success: returns DEC_OK, *text_len = the number of visible bytes (excluding the NUL), *error_offset = n. */
DecodeStatus decode_stream(const uint8_t *bytes, size_t n, char *text, size_t text_size, size_t *text_len,
                           size_t *error_offset);
#endif

/* decode8086: disassemble a file of 8086 subset instructions (E06). Reference solution.
   Argument handling and printing are supplied plumbing; read_input is the exercise. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "decode.h"

typedef enum { READ_OK, READ_ERROR, READ_TOO_LARGE } ReadStatus;

/* Read the whole file into buf[0..cap) with fgetc, setting *n. fgetc returns an int so that EOF is distinguishable
   from every byte; at EOF, ferror separates end of file from a read error. A file with more than cap bytes is
   READ_TOO_LARGE (detected by reading one byte past the limit, never by trusting a size from elsewhere). A failing
   fclose is a read error too. On any failure *n is unchanged; buf may hold partial data, which the caller ignores. */
ReadStatus read_input(const char *path, uint8_t *buf, size_t cap, size_t *n)
{
    FILE *f = fopen(path, "rb");
    if (f == NULL) return READ_ERROR;
    size_t count = 0;
    ReadStatus status = READ_OK;
    for (;;) {
        int c = fgetc(f);
        if (c == EOF) {
            if (ferror(f)) status = READ_ERROR;
            break;
        }
        if (count == cap) {
            status = READ_TOO_LARGE;
            break;
        }
        buf[count++] = (uint8_t)c;
    }
    if (fclose(f) != 0 && status == READ_OK) status = READ_ERROR;
    if (status == READ_OK) *n = count;
    return status;
}

/* ---- supplied plumbing ---- */

/* The largest output for DEC_MAX_INPUT bytes: at most DEC_MAX_INPUT / 2 instructions (every instruction has at least
   two bytes), each at most DEC_MAX_TEXT - 1 characters plus a newline, plus "bits 16\n" and the NUL. */
#define TEXT_CAPACITY (8u + (DEC_MAX_INPUT / 2u) * DEC_MAX_TEXT + 1u)

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "decode8086: usage: decode8086 FILE\n");
        return 1;
    }
    static uint8_t bytes[DEC_MAX_INPUT];
    size_t n = 0;
    ReadStatus rs = read_input(argv[1], bytes, sizeof bytes, &n);
    if (rs == READ_TOO_LARGE) {
        fprintf(stderr, "decode8086: input too large\n");
        return 1;
    }
    if (rs != READ_OK) {
        fprintf(stderr, "decode8086: input error\n");
        return 1;
    }
    char *text = malloc(TEXT_CAPACITY);
    if (text == NULL) {
        fprintf(stderr, "decode8086: input error\n");
        return 1;
    }
    size_t len = 0, offset = 0;
    DecodeStatus s = decode_stream(bytes, n, text, TEXT_CAPACITY, &len, &offset);
    if (s != DEC_OK) {
        free(text);
        fprintf(stderr, "decode8086: %s at offset %zu\n", decode_status_name(s), offset);
        return 1;
    }
    /* Everything is decoded before the first byte is written. A write error can still leave a partial stream; it is
       reported, not rolled back. */
    int ok = fwrite(text, 1, len, stdout) == len;
    free(text);
    if (fflush(stdout) != 0 || ferror(stdout)) ok = 0;
    if (!ok) {
        fprintf(stderr, "decode8086: output error\n");
        return 1;
    }
    return 0;
}

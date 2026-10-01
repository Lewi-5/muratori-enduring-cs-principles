/* Week-6 C contract suites. Compile with -DEXERCISE=n and -DSOURCE="path/exNN.c" (n = 1..5), or with -DEXERCISE=6,
   -DSOURCE="path/decode.c" and -DSOURCE2="path/decode8086.c". Each source is included with main renamed, so the
   named functions and types are the contract, and fault-injection macros reach only the included code. Oracle files
   are read from ORACLE_DIR, fixtures from FIXTURE_DIR. Run through tests/check.py. */
#include <assert.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "decode_types.h"

#ifndef ORACLE_DIR
#error "ORACLE_DIR is required"
#endif

#if EXERCISE == 6
/* fault injection for decode8086.c's read_input only */
int fail_fgetc_after = -1, fail_ferror = 0, fail_fclose = 0, fgetc_calls = 0;
int test_fgetc(FILE *f);
int test_ferror(FILE *f);
int test_fclose(FILE *f);
int test_fgetc(FILE *f)
{
    if (fail_fgetc_after >= 0 && fgetc_calls++ >= fail_fgetc_after) return EOF;
    return fgetc(f);
}
int test_ferror(FILE *f) { return fail_ferror ? 1 : ferror(f); }
int test_fclose(FILE *f)
{
    int r = fclose(f);
    return fail_fclose ? EOF : r;
}
#endif

#define main exercise_main
#include SOURCE
#if EXERCISE == 6
#define fgetc test_fgetc
#define ferror test_ferror
#define fclose test_fclose
#include SOURCE2
#undef fgetc
#undef ferror
#undef fclose
#endif
#undef main

FILE *open_oracle(const char *name);
FILE *open_oracle(const char *name)
{
    char path[1024];
    snprintf(path, sizeof path, "%s/%s", ORACLE_DIR, name);
    FILE *f = fopen(path, "r");
    if (f == NULL) {
        fprintf(stderr, "cannot open %s\n", path);
        exit(2);
    }
    return f;
}

/* Parse lowercase hexadecimal into bytes; returns the count. */
size_t unhex(const char *hex, uint8_t *out, size_t cap);
size_t unhex(const char *hex, uint8_t *out, size_t cap)
{
    size_t n = 0;
    for (; hex[0] && hex[1] && n < cap; hex += 2) {
        unsigned v = 0;
        sscanf(hex, "%2x", &v);
        out[n++] = (uint8_t)v;
    }
    return n;
}

#if EXERCISE == 4
/* The harness's own formatter, used only to compare E04's decoded fields with the oracle's text. */
static void harness_text(const Instruction *ins, char *out, size_t size)
{
    static const char *const ops[] = {"mov", "add", "sub", "cmp"};
    static const char *const r8[] = {"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"};
    static const char *const r16[] = {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"};
    assert(ins->op <= OP_CMP && ins->dst.kind == OPERAND_REG && ins->dst.reg < 8 && ins->dst.wide < 2);
    const char *dst = ins->dst.wide ? r16[ins->dst.reg] : r8[ins->dst.reg];
    if (ins->src.kind == OPERAND_REG) {
        assert(ins->src.reg < 8 && ins->src.wide == ins->dst.wide);
        snprintf(out, size, "%s %s, %s", ops[ins->op], dst, ins->src.wide ? r16[ins->src.reg] : r8[ins->src.reg]);
    } else {
        assert(ins->src.kind == OPERAND_IMM && ins->src.wide == ins->dst.wide);
        snprintf(out, size, "%s %s, %ld", ops[ins->op], dst, (long)ins->src.imm);
    }
}
#endif

int main(void)
{
#if EXERCISE == 1
    FILE *f = open_oracle("modrm.txt");
    unsigned byte, mod, reg, rm;
    int count = 0;
    while (fscanf(f, "%u %u %u %u", &byte, &mod, &reg, &rm) == 4) {
        ModRM m = split_modrm((uint8_t)byte);
        assert(m.mod == mod && m.reg == reg && m.rm == rm);
        assert((m.mod << 6 | m.reg << 3 | m.rm) == byte);
        for (unsigned i = 0; i < 8; ++i) assert(bit_at((uint8_t)byte, i) == ((byte >> i) & 1u));
        assert(bit_at((uint8_t)byte, 8) == 0 && bit_at((uint8_t)byte, UINT_MAX) == 0);
        ++count;
    }
    fclose(f);
    assert(count == 256);
#elif EXERCISE == 2
    static const char *const want[2][8] = {{"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"},
                                           {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"}};
    for (unsigned w = 0; w < 2; ++w)
        for (unsigned r = 0; r < 8; ++r) assert(reg_name(w, r) != NULL && strcmp(reg_name(w, r), want[w][r]) == 0);
    assert(reg_name(2, 0) == NULL && reg_name(0, 8) == NULL && reg_name(1, 8) == NULL && reg_name(UINT_MAX, UINT_MAX) == NULL);
#elif EXERCISE == 3
    static const uint8_t s[] = {0x34, 0x12, 0xFE, 0xFF, 0x80};
    uint16_t v = 0xAAAA;
    assert(read_imm(s, 5, 0, 2, &v) == 1 && v == 0x1234);
    assert(read_imm(s, 5, 0, 1, &v) == 1 && v == 0x34);
    assert(read_imm(s, 5, 3, 2, &v) == 1 && v == 0x80FF); /* the last valid two-byte read */
    assert(read_imm(s, 5, 4, 1, &v) == 1 && v == 0x80);   /* the last valid one-byte read */
    v = 0xAAAA;
    assert(read_imm(s, 5, 4, 2, &v) == 0 && v == 0xAAAA); /* one byte short */
    assert(read_imm(s, 5, 5, 1, &v) == 0 && v == 0xAAAA);
    assert(read_imm(s, 5, 6, 1, &v) == 0 && v == 0xAAAA); /* offset past the end */
    assert(read_imm(s, 5, SIZE_MAX, 2, &v) == 0 && v == 0xAAAA);
    assert(read_imm(s, 5, SIZE_MAX - 1, 2, &v) == 0 && v == 0xAAAA); /* offset + size would wrap to 0 */
    assert(read_imm(s, SIZE_MAX, SIZE_MAX - 1, 2, &v) == 0 && v == 0xAAAA);
    assert(read_imm(s, 5, 0, 3, &v) == 0 && read_imm(s, 5, 0, 0, &v) == 0 && v == 0xAAAA);
    assert(read_imm(NULL, 5, 0, 1, &v) == 0 && read_imm(s, 5, 0, 1, NULL) == 0 && v == 0xAAAA);
    assert(read_imm(s, 0, 0, 1, &v) == 0);
    for (uint32_t x = 0; x <= 0xFFFF; ++x) {
        int32_t sv = to_signed((uint16_t)x, 1);
        assert(sv >= -32768 && sv <= 32767 && (uint32_t)(sv + 65536) % 65536u == x); /* the right residue */
        if (x <= 0xFF) {
            int32_t s8 = to_signed((uint16_t)x, 0);
            assert(s8 >= -128 && s8 <= 127 && (uint32_t)(s8 + 256) % 256u == x);
            uint16_t e = sign_extend8((uint8_t)x);
            assert((e & 0xFFu) == x && (e >> 8) == (x >= 0x80 ? 0xFFu : 0u) && to_signed(e, 1) == s8);
        }
    }
    assert(to_signed(0x7FFF, 1) == 32767 && to_signed(0x8000, 1) == -32768 && to_signed(0xFFFF, 1) == -1);
    assert(to_signed(0xFE, 0) == -2 && sign_extend8(0xFE) == 0xFFFE && sign_extend8(0x7F) == 0x007F);
#elif EXERCISE == 4
    /* every enumerated encoding, then every two-byte prefix with 0, 1 or 2 trailing bytes */
    char line[256], hex[32], status[64], text[64], mine[64];
    unsigned length = 0;
    uint8_t bytes[8];
    size_t checked = 0;
    FILE *f = open_oracle("exhaustive.txt");
    while (fgets(line, sizeof line, f) != NULL) {
        text[0] = '\0';
        if (sscanf(line, "%31s %63s %u %63[^\n]", hex, status, &length, text) < 3) abort();
        size_t n = unhex(hex, bytes, sizeof bytes);
        Instruction ins, before;
        memset(&ins, 0x5A, sizeof ins);
        before = ins;
        DecodeStatus s = decode_one(bytes, n, &ins);
        if (strcmp(decode_status_name(s), status) != 0) {
            fprintf(stderr, "bytes %s: got %s, expected %s\n", hex, decode_status_name(s), status);
            return 1;
        }
        if (s == DEC_OK) {
            harness_text(&ins, mine, sizeof mine);
            if (ins.length != length || strcmp(mine, text) != 0) {
                fprintf(stderr, "bytes %s: got \"%s\" length %u, expected \"%s\" length %u\n", hex, mine, ins.length, text, length);
                return 1;
            }
        } else {
            assert(memcmp(&ins, &before, sizeof ins) == 0); /* unchanged on failure */
        }
        ++checked;
    }
    fclose(f);
    assert(checked > 200000);
    Instruction ins;
    uint8_t one = 0x89;
    assert(decode_one(NULL, 1, &ins) == DEC_INVALID_ARGUMENT);
    assert(decode_one(&one, 1, NULL) == DEC_INVALID_ARGUMENT);
    assert(decode_one(NULL, 0, &ins) == DEC_TRUNCATED);
    printf("%zu encodings and prefixes compared\n", checked);
#elif EXERCISE == 5
    char line[256], opname[8], dst[8], src[16], want[64];
    FILE *f = open_oracle("fields.txt");
    int op, dw, dr, kind, sw, sr;
    long imm;
    size_t checked = 0;
    while (fgets(line, sizeof line, f) != NULL) {
        if (sscanf(line, "%d %d %d %d %d %d %ld %63[^\n]", &op, &dw, &dr, &kind, &sw, &sr, &imm, want) != 8) abort();
        Instruction ins = {(Operation)op, {OPERAND_REG, (unsigned)dw, (unsigned)dr, 0},
                           {(OperandKind)kind, (unsigned)sw, (unsigned)sr, (int32_t)imm}, 2};
        char out[DEC_MAX_TEXT];
        assert(format_instruction(&ins, out, sizeof out) == 1);
        if (strcmp(out, want) != 0) {
            fprintf(stderr, "format: got \"%s\", expected \"%s\"\n", out, want);
            return 1;
        }
        ++checked;
    }
    fclose(f);
    (void)opname; (void)dst; (void)src;
    assert(checked > 20000);
    /* the longest text and the buffer boundary */
    Instruction longest = {OP_CMP, {OPERAND_REG, 1, 0, 0}, {OPERAND_IMM, 1, 0, -32768}, 4};
    char buf[32];
    memset(buf, '#', sizeof buf);
    assert(format_instruction(&longest, buf, 14) == 0 && buf[0] == '#' && buf[13] == '#'); /* one byte short */
    assert(format_instruction(&longest, buf, 15) == 1 && strcmp(buf, "cmp ax, -32768") == 0 && strlen(buf) == 14);
    assert(DEC_MAX_TEXT >= 15);
    /* every invalid field is rejected and leaves the buffer untouched */
    Instruction bad[] = {
        {(Operation)4, {OPERAND_REG, 1, 0, 0}, {OPERAND_REG, 1, 1, 0}, 2},
        {OP_MOV, {OPERAND_REG, 2, 0, 0}, {OPERAND_REG, 2, 1, 0}, 2},
        {OP_MOV, {OPERAND_REG, 1, 8, 0}, {OPERAND_REG, 1, 1, 0}, 2},
        {OP_MOV, {OPERAND_REG, 1, 0, 0}, {OPERAND_REG, 1, 8, 0}, 2},
        {OP_MOV, {OPERAND_IMM, 1, 0, 5}, {OPERAND_REG, 1, 1, 0}, 2},
        {OP_MOV, {OPERAND_REG, 0, 0, 0}, {OPERAND_IMM, 0, 0, 128}, 2},
        {OP_MOV, {OPERAND_REG, 0, 0, 0}, {OPERAND_IMM, 0, 0, -129}, 2},
        {OP_MOV, {OPERAND_REG, 1, 0, 0}, {OPERAND_IMM, 1, 0, 32768}, 3},
        {OP_MOV, {OPERAND_REG, 1, 0, 0}, {OPERAND_IMM, 1, 0, -32769}, 3},
        {OP_ADD, {OPERAND_REG, 1, 0, 0}, {OPERAND_REG, 0, 1, 0}, 2},
        {OP_ADD, {OPERAND_REG, 1, 0, 0}, {(OperandKind)2, 1, 1, 0}, 2},
    };
    for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
        memset(buf, '#', sizeof buf);
        assert(format_instruction(&bad[i], buf, sizeof buf) == 0 && buf[0] == '#');
    }
    assert(format_instruction(NULL, buf, sizeof buf) == 0);
    assert(format_instruction(&longest, NULL, 32) == 0);
    assert(format_instruction(&longest, buf, 0) == 0);
    printf("%zu texts compared\n", checked);
#elif EXERCISE == 6
    /* decode_stream on every supplied listing */
    static char text[8 + (DEC_MAX_INPUT / 2) * DEC_MAX_TEXT + 1];
    static uint8_t data[DEC_MAX_INPUT + 1];
    size_t len = 0, off = 0, n = 0;
    FILE *list = open_oracle("listings.txt");
    char name[64], stat_name[64];
    size_t want_off;
    int listings = 0;
    while (fscanf(list, "%63s %63s %zu", name, stat_name, &want_off) == 3) {
        char path[1024];
        snprintf(path, sizeof path, "%s/listings/%s.bin", FIXTURE_DIR, name);
        assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_OK);
        memset(text, '#', 64);
        len = 777;
        off = 888;
        DecodeStatus s = decode_stream(data, n, text, sizeof text, &len, &off);
        assert(strcmp(decode_status_name(s), stat_name) == 0);
        if (s == DEC_OK) {
            snprintf(path, sizeof path, "%s/listings/%s.txt", FIXTURE_DIR, name);
            FILE *t = fopen(path, "rb");
            assert(t != NULL);
            static char want[4096];
            size_t w = fread(want, 1, sizeof want - 1, t);
            fclose(t);
            want[w] = '\0';
            assert(len == w && strcmp(text, want) == 0 && off == n);
        } else {
            assert(off == want_off && len == 777 && text[0] == '#'); /* text and length unchanged */
        }
        ++listings;
    }
    fclose(list);
    assert(listings >= 10);
    /* empty input: bits 16 alone; NULL bytes allowed only with n == 0 */
    assert(decode_stream(NULL, 0, text, sizeof text, &len, &off) == DEC_OK && strcmp(text, "bits 16\n") == 0 && len == 8 && off == 0);
    uint8_t mov[] = {0x89, 0xD9, 0x89, 0xD9};
    /* the buffer boundary: "bits 16\nmov cx, bx\nmov cx, bx\n" is 30 visible bytes and needs 31 */
    char small[40];
    memset(small, '#', sizeof small);
    len = 5;
    off = 6;
    assert(decode_stream(mov, 4, small, 30, &len, &off) == DEC_OUTPUT_TOO_SMALL);
    assert(small[0] == '#' && small[29] == '#' && len == 5 && off == 6); /* every output unchanged */
    assert(decode_stream(mov, 4, small, 31, &len, &off) == DEC_OK && len == 30 && off == 4);
    assert(strcmp(small, "bits 16\nmov cx, bx\nmov cx, bx\n") == 0);
    len = 5;
    off = 6;
    assert(decode_stream(NULL, 4, small, 40, &len, &off) == DEC_INVALID_ARGUMENT && len == 5 && off == 6);
    assert(decode_stream(mov, 4, NULL, 40, &len, &off) == DEC_INVALID_ARGUMENT && len == 5 && off == 6);
    assert(decode_stream(mov, 4, small, 40, NULL, &off) == DEC_INVALID_ARGUMENT && off == 6);
    assert(decode_stream(mov, 4, small, 40, &len, NULL) == DEC_INVALID_ARGUMENT && len == 5);
    /* resynchronization: the same bytes decode differently from offset 1 */
    uint8_t rs[] = {0xB8, 0x89, 0xD9};
    assert(decode_stream(rs, 3, small, 40, &len, &off) == DEC_OK && strcmp(small, "bits 16\nmov ax, -9847\n") == 0);
    assert(decode_stream(rs + 1, 2, small, 40, &len, &off) == DEC_OK && strcmp(small, "bits 16\nmov cx, bx\n") == 0);
    /* exactly DEC_MAX_INPUT bytes of two-byte instructions, and one byte more */
    char path[1024];
    snprintf(path, sizeof path, "%s/max.bin", TEST_TMPDIR);
    FILE *w = fopen(path, "wb");
    assert(w != NULL);
    for (unsigned i = 0; i < DEC_MAX_INPUT / 2; ++i) fwrite(mov, 1, 2, w);
    fclose(w);
    n = 0;
    assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_OK && n == DEC_MAX_INPUT);
    assert(decode_stream(data, n, text, sizeof text, &len, &off) == DEC_OK && len == 8 + (DEC_MAX_INPUT / 2) * 11u);
    w = fopen(path, "ab");
    fputc(0x90, w);
    fclose(w);
    n = 42;
    assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_TOO_LARGE && n == 42);
    /* missing file, directory, injected read and close failures: READ_ERROR, n unchanged */
    assert(read_input(TEST_TMPDIR "/no-such-file.bin", data, DEC_MAX_INPUT, &n) == READ_ERROR && n == 42);
    assert(read_input(TEST_TMPDIR, data, DEC_MAX_INPUT, &n) == READ_ERROR && n == 42);
    snprintf(path, sizeof path, "%s/listings/program.bin", FIXTURE_DIR);
    fail_fgetc_after = 5;
    fgetc_calls = 0;
    fail_ferror = 1;
    assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_ERROR && n == 42);
    fail_fgetc_after = -1;
    fail_ferror = 0;
    fail_fclose = 1;
    assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_ERROR && n == 42);
    fail_fclose = 0;
    assert(read_input(path, data, DEC_MAX_INPUT, &n) == READ_OK && n == 28);
    printf("%d listings\n", listings);
#else
#error "EXERCISE must be 1..6"
#endif
    printf("contract passed\n");
    return 0;
}

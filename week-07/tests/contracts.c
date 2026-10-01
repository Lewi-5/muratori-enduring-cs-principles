#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"
#include "address.h"
static void case_check(const uint8_t *b, size_t n, const char *expected)
{
    Instruction ins; char text[DEC_MAX_TEXT];
    assert(decode_one(b,n,&ins)==DEC_OK && ins.length==n);
    assert(format_instruction(&ins,text,sizeof text) && strcmp(text,expected)==0);
    size_t len=strlen(text);
    char snapshot[DEC_MAX_TEXT]; memset(text,0x5a,sizeof text); memcpy(snapshot,text,sizeof text);
    assert(!format_instruction(&ins,text,len) && memcmp(text,snapshot,sizeof text)==0);
    assert(format_instruction(&ins,text,len+1));
    for (size_t k=0; k<n; ++k) {
        Instruction untouched; memset(&untouched,0x5a,sizeof untouched);
        unsigned char original[sizeof untouched]; memcpy(original,&untouched,sizeof untouched);
        assert(decode_one(b,k,&untouched)==DEC_TRUNCATED);
        assert(memcmp(&untouched,original,sizeof untouched)==0);
    }
}
int main(void)
{
    const uint8_t a[]={0x8b,0x46,0xfe}, b[]={0x8b,0x06,0xfe,0xff};
    const uint8_t c[]={0x83,0x80,0x00,0x80,0xfe}, d[]={0xc7,0x86,0,0x80,0,0x80};
    case_check(a,sizeof a,"mov ax, [bp - 2]");
    case_check(b,sizeof b,"mov ax, [65534]");
    case_check(c,sizeof c,"add word [bx + si - 32768], -2");
    case_check(d,sizeof d,"mov word [bp - 32768], -32768");
    Address address={0}; unsigned used=99;
    assert(decode_address(NULL,0,0,0,&address,&used)==DEC_OK && used==0);
    Address before=address; used=99;
    assert(decode_address(NULL,0,0,6,&address,&used)==DEC_TRUNCATED && used==99);
    assert(memcmp(&before,&address,sizeof address)==0);
    assert(decode_address(NULL,0,3,0,&address,&used)==DEC_INVALID_ARGUMENT);
    assert(decode_address(NULL,1,0,0,&address,&used)==DEC_INVALID_ARGUMENT);
    Instruction ins={0};
    assert(decode_one(NULL,1,&ins)==DEC_INVALID_ARGUMENT);
    assert(decode_one(a,sizeof a,NULL)==DEC_INVALID_ARGUMENT);
    const uint8_t bad[]={0x81,0x0e};
    assert(decode_one(bad,sizeof bad,&ins)==DEC_UNSUPPORTED_OPERATION);
    const uint8_t mov_bad[]={0xc7,0x0e};
    assert(decode_one(mov_bad,sizeof mov_bad,&ins)==DEC_UNSUPPORTED_OPERATION);
    const uint8_t prefix[]={0x26};
    assert(decode_one(prefix,1,&ins)==DEC_UNSUPPORTED_OPCODE);
    assert(decode_one(a,sizeof a,&ins)==DEC_OK);
    char text[200], save[200]; memset(text,0x5a,sizeof text); memcpy(save,text,sizeof text);
    ins.src=ins.dst; ins.dst.kind=OPERAND_MEM; ins.src.kind=OPERAND_MEM;
    assert(!format_instruction(&ins,text,sizeof text) && !memcmp(text,save,sizeof text));
    assert(decode_one(a,sizeof a,&ins)==DEC_OK);
    ins.src.memory.rm=8;
    assert(!format_instruction(&ins,text,sizeof text));
    ins.src.memory.rm=6; ins.src.memory.displacement=32768;
    assert(!format_instruction(&ins,text,sizeof text));
    assert(!format_instruction(NULL,text,sizeof text));
    size_t len=99, offset=99;
    const uint8_t late[]={0x89,0xd9,0x8b,0x06,0x34};
    assert(decode_stream(late,sizeof late,text,sizeof text,&len,&offset)==DEC_TRUNCATED);
    assert(len==99 && offset==2 && !memcmp(text,save,sizeof text));
    offset=99;
    assert(decode_stream(a,sizeof a,text,1,&len,&offset)==DEC_OUTPUT_TOO_SMALL);
    assert(len==99 && offset==99 && !memcmp(text,save,sizeof text));
    assert(decode_stream(a,sizeof a,text,sizeof text,&len,&offset)==DEC_OK);
    assert(!strcmp(text,"bits 16\nmov ax, [bp - 2]\n") && len==strlen(text) && offset==3);
    memset(text,0x5a,sizeof text); memcpy(save,text,sizeof text);
    len=99; offset=99;
    assert(decode_stream(NULL,0,text,8,&len,&offset)==DEC_OUTPUT_TOO_SMALL);
    assert(len==99 && offset==99 && !memcmp(text,save,sizeof text));
    assert(decode_stream(NULL,0,text,9,&len,&offset)==DEC_OK && len==8 && offset==0);
    assert(decode_stream(NULL,1,text,sizeof text,&len,&offset)==DEC_INVALID_ARGUMENT);
    assert(decoder_api_version()==7);
    puts("PASS API, truncation, transaction and formatting contracts"); return 0;
}

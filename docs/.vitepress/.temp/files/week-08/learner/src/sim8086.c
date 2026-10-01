/* E05 supplied file/trace driver. Implement E01-E04 to make it work. */
#include <stdint.h>
#include <stdio.h>
#include "sim.h"
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


static void state_line(const CpuState *state)
{
    static const char *const names[]={"ax","cx","dx","bx","sp","bp","si","di"};
    for (unsigned r=0; r<8; ++r) printf(" %s=%04x",names[r],(unsigned)state->regs[r]);
    printf(" ip=%04x flags=%04x\n",(unsigned)state->ip,(unsigned)state->flags);
}
int main(int argc, char **argv)
{
    if (argc!=2) { fputs("sim8086: usage: sim8086 FILE\n",stderr); return 1; }
    static uint8_t bytes[DEC_MAX_INPUT]; size_t n=0;
    ReadStatus input=read_input(argv[1],bytes,sizeof bytes,&n);
    if (input!=READ_OK) {
        fprintf(stderr,"sim8086: %s\n",input==READ_TOO_LARGE ? "input too large" : "input error"); return 1;
    }
    CpuState final={0}; RunResult result=sim_run(bytes,n,&final);
    if (result.status!=SIM_OK) {
        const char *name=result.status==SIM_DECODE_ERROR ? decode_status_name(result.decode_status) : sim_status_name(result.status);
        fprintf(stderr,"sim8086: %s at offset %zu\n",name,result.offset); return 1;
    }
    /* No stdout until the full tentative execution succeeds. Second pass
       emits a deterministic trace from the SAME zero initial state. */
    CpuState trace={0};
    for (size_t offset=0; offset<n;) {
        Instruction ins; char text[DEC_MAX_TEXT];
        if (decode_one(bytes+offset,n-offset,&ins)!=DEC_OK ||
            !format_instruction(&ins,text,sizeof text) || sim_step(&ins,&trace)!=SIM_OK) return 1;
        printf("offset=%zu %s |",offset,text); state_line(&trace);
        offset+=ins.length;
    }
    printf("final steps=%zu |",result.steps); state_line(&final);
    if (fflush(stdout)!=0 || ferror(stdout)) { fputs("sim8086: output error\n",stderr); return 1; }
    return 0;
}

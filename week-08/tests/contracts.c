#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "sim.h"
static Instruction decoded(const uint8_t *bytes,size_t n)
{
    Instruction ins; assert(decode_one(bytes,n,&ins)==DEC_OK); return ins;
}
int main(void)
{
    CpuState state={{0x1234,0x5678,0x9abc,0xdef0,1,2,3,4},0xffff,65534};
    uint16_t value=99;
    for (unsigned code=0; code<8; ++code) {
        assert(sim_read_register(&state,1,code,&value) && value==state.regs[code]);
        assert(sim_read_register(&state,0,code,&value));
        assert(value==(code<4 ? state.regs[code]%256 : state.regs[code-4]/256));
    }
    assert(sim_write_register(&state,0,0,0xff) && state.regs[0]==0x12ff);
    assert(sim_write_register(&state,0,4,0x80) && state.regs[0]==0x80ff);
    unsigned char snapshot[sizeof state]; memcpy(snapshot,&state,sizeof state);
    assert(!sim_write_register(&state,0,0,256) && !memcmp(snapshot,&state,sizeof state));
    assert(!sim_write_register(&state,2,0,0) && !sim_write_register(&state,1,8,0));
    assert(!sim_write_register(NULL,1,0,0));
    value=99; assert(!sim_read_register(&state,2,0,&value) && value==99);
    assert(!sim_read_register(NULL,1,0,&value) && !sim_read_register(&state,1,0,NULL));
    AluResult alu={99,99};
    assert(!sim_alu(OP_MOV,0,1,2,&alu) && alu.value==99 && alu.flags==99);
    assert(!sim_alu(OP_ADD,2,1,2,&alu) && !sim_alu(OP_SUB,0,256,1,&alu));
    assert(!sim_alu(OP_ADD,0,1,2,NULL));
    const uint8_t mov[]={0x88,0xe0}; /* mov al,ah: read high before writing low */
    Instruction ins=decoded(mov,sizeof mov);
    assert(sim_step(&ins,&state)==SIM_OK && state.regs[0]==0x8080 && state.flags==0xffff && state.ip==0);
    const uint8_t cmp[]={0x3c,0x80}; ins=decoded(cmp,sizeof cmp);
    uint16_t original=state.regs[0];
    assert(sim_step(&ins,&state)==SIM_OK && state.regs[0]==original);
    assert(state.flags==(uint16_t)((65535u ^ FLAG_ARITH)|FLAG_ZF|FLAG_PF));
    memcpy(snapshot,&state,sizeof state);
    ins.length=0;
    assert(sim_step(&ins,&state)==SIM_INVALID_INSTRUCTION && !memcmp(snapshot,&state,sizeof state));
    ins.length=2; ins.src.wide=1;
    assert(sim_step(&ins,&state)==SIM_INVALID_INSTRUCTION && !memcmp(snapshot,&state,sizeof state));
    ins.src.wide=0; ins.src.imm=128;
    assert(sim_step(&ins,&state)==SIM_INVALID_INSTRUCTION);
    assert(sim_step(NULL,&state)==SIM_INVALID_ARGUMENT && sim_step(&ins,NULL)==SIM_INVALID_ARGUMENT);
    const uint8_t mem[]={0x8b,0x07}; ins=decoded(mem,sizeof mem);
    assert(sim_step(&ins,&state)==SIM_UNSUPPORTED_OPERAND && !memcmp(snapshot,&state,sizeof state));
    const uint8_t late[]={0xb8,0x34,0x12,0x8b,0x07};
    RunResult run=sim_run(late,sizeof late,&state);
    assert(run.status==SIM_UNSUPPORTED_OPERAND && run.offset==3 && run.steps==1);
    assert(!memcmp(snapshot,&state,sizeof state));
    const uint8_t truncated[]={0xb8,0x34,0x12,0xb9,0x56};
    run=sim_run(truncated,sizeof truncated,&state);
    assert(run.status==SIM_DECODE_ERROR && run.decode_status==DEC_TRUNCATED && run.offset==3 && run.steps==1);
    assert(!memcmp(snapshot,&state,sizeof state));
    run=sim_run(NULL,0,&state); assert(run.status==SIM_OK && !run.steps && !memcmp(snapshot,&state,sizeof state));
    assert(sim_run(NULL,1,&state).status==SIM_INVALID_ARGUMENT);
    assert(sim_run(late,sizeof late,NULL).status==SIM_INVALID_ARGUMENT);
    assert(sim_run(late,65537,&state).status==SIM_INPUT_TOO_LARGE);
    const uint8_t add[]={0xb0,0xff,0x04,1};
    state=(CpuState){0}; state.ip=65534;
    run=sim_run(add,sizeof add,&state);
    assert(run.status==SIM_OK && run.steps==2 && run.offset==4 && state.ip==2 && state.regs[0]==0);
    assert(state.flags==(FLAG_CF|FLAG_PF|FLAG_AF|FLAG_ZF));
    /* All width/register combinations, including shared-byte sources. ALU
       values/flags are separately compared against the mathematical oracle. */
    const uint8_t opcodes[]={0x88,0x00,0x28,0x38};
    for (unsigned op=0; op<4; ++op) for (unsigned wide=0; wide<2; ++wide)
        for (unsigned dst=0; dst<8; ++dst) for (unsigned src=0; src<8; ++src) {
            state=(CpuState){{0x7f80,0xff01,0x8000,0x00ff,0x1234,0x5678,0x9abc,0xdef0},0xffff,65535};
            CpuState expected=state;
            unsigned ds=wide ? dst : dst%4, ss=wide ? src : src%4;
            unsigned shift=wide || dst<4 ? 0u : 8u;
            uint16_t a=(uint16_t)(wide ? state.regs[ds] : ((uint32_t)state.regs[ds] >> shift)&255u);
            unsigned source_shift=wide || src<4 ? 0u : 8u;
            uint16_t b=(uint16_t)(wide ? state.regs[ss] : ((uint32_t)state.regs[ss] >> source_shift)&255u);
            uint16_t value_to_write=b;
            if (op) {
                assert(sim_alu((Operation)op,wide,a,b,&alu));
                value_to_write=alu.value;
                expected.flags=(uint16_t)((65535u ^ FLAG_ARITH)|alu.flags);
            }
            if (op!=3) {
                if (wide) expected.regs[ds]=value_to_write;
                else if (!shift) expected.regs[ds]=(uint16_t)((state.regs[ds]/256u)*256u+value_to_write);
                else expected.regs[ds]=(uint16_t)((state.regs[ds]%256u)+(uint32_t)value_to_write*256u);
            }
            expected.ip=1;
            uint8_t encoded[]={ (uint8_t)(opcodes[op]|wide), (uint8_t)(0xc0u|src<<3|dst) };
            ins=decoded(encoded,sizeof encoded);
            assert(sim_step(&ins,&state)==SIM_OK);
            assert(!memcmp(state.regs,expected.regs,sizeof state.regs));
            assert(state.flags==expected.flags && state.ip==expected.ip);
        }
    const uint8_t extended[]={0x83,0xc0,0xfe};
    state=(CpuState){0}; state.regs[0]=1;
    ins=decoded(extended,sizeof extended);
    assert(sim_step(&ins,&state)==SIM_OK && state.regs[0]==65535 && state.flags==(FLAG_PF|FLAG_SF));
    puts("PASS register aliases, validation, MOV/CMP, flags preservation, IP wrap and program rollback"); return 0;
}

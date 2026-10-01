/* E04 reference: file framing and guest architectural IP are separate. */
#include "sim.h"
RunResult sim_run(const uint8_t *bytes, size_t n, CpuState *state)
{
    RunResult result={SIM_OK,DEC_OK,0,0};
    if (!state || (!bytes && n)) { result.status=SIM_INVALID_ARGUMENT; return result; }
    if (n>DEC_MAX_INPUT) { result.status=SIM_INPUT_TOO_LARGE; return result; }
    /* Tentative state remains private through all decode/execution failures. */
    CpuState next=*state;
    while (result.offset<n) {
        Instruction ins;
        DecodeStatus decoded=decode_one(bytes+result.offset,n-result.offset,&ins);
        if (decoded!=DEC_OK) {
            result.status=SIM_DECODE_ERROR; result.decode_status=decoded; return result;
        }
        result.status=sim_step(&ins,&next);
        if (result.status!=SIM_OK) return result;
        result.offset+=ins.length;
        ++result.steps;
    }
    *state=next;
    return result;
}

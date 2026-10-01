#include "sim.h"
SimStatus sim_step(const Instruction *ins, CpuState *state)
{
    /* TODO E03: validate, read both operands, update a temporary state, commit. */
    (void)ins; (void)state; return SIM_INVALID_INSTRUCTION;
}

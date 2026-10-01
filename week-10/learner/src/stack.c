#include "machine.h"
MachineStatus machine_push(Machine *m, uint16_t value)
{
    /* E01: validate window, reserve two bytes, encode guest word, commit SP. */
    (void)m; (void)value; return M_STACK;
}
MachineStatus machine_pop(Machine *m, uint16_t *value)
{
    /* E01: validate available word, decode before changing SP/output. */
    (void)m; (void)value; return M_STACK;
}

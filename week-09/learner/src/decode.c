#include "machine.h"
/* TODO: implement the public contract. */
int machine_condition(unsigned c, uint16_t f) { (void)c; (void)f; return -1; }
MachineStatus machine_decode(const uint8_t *b, size_t n, Decoded *o) { (void)b; (void)n; (void)o; return M_DECODE; }

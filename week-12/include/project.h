#ifndef WEEK12_PROJECT_H
#define WEEK12_PROJECT_H
#include "machine.h"
typedef struct {
    const uint8_t *bytes;
    size_t length;
    uint8_t boundary[65536];
} CodeImage;
typedef struct {
    uint16_t before_ip;
    CpuState after;
    unsigned changed_count;
    uint16_t addresses[2];
    uint8_t values[2];
} TraceRecord;
/* All storage is caller-owned, accessible and disjoint, including code,
   CodeImage, Machine, trace array, scalar counts and warm-up outputs.
   No allocation, I/O or retained storage except CodeImage's borrowed bytes.
   A CodeImage must come from successful project_prepare and stay unchanged.
   Its bytes must remain alive AND immutable until the image is retired.
   Editing/replacing code requires fresh preparation, even at the same pointer.
   The map is host metadata, never guest architectural state or prediction. */
/* E01: n<=65535, NULL bytes only n=0. Decode EVERY byte sequentially via
   supplied machine_decode, mark starts and end, initialize unused boundaries.
   Commit image only on success. Return offset=n/steps=0 on success, failing
   opcode offset/steps=0 on decode failure, zeros on argument failure.
   No target or stack validation yet: those depend on the execution state. */
MachineResult project_prepare(const uint8_t *bytes, size_t n, CodeImage *out);
/* E02: one atomic step, same Week 10 subset/semantics, but use prepared map
   rather than reparsing the whole region. Current IP must be a start < n.
   Taken branch/return target is a start or exactly n. Untaken target ignored.
   Reads/addresses use pre-state, words wrap FFFF->0000, stack never wraps.
   Original PUSH SP stores decremented SP; POP SP final value is popped SP.
   Stack flags preserved; INC/DEC preserve CF; opaque flags remain unchanged.
   NULL arguments give M_ARGUMENT; at halt boundary returns M_TARGET.
   Every failure leaves the complete Machine unchanged. */
MachineStatus project_step(const CodeImage *image, Machine *machine);
/* E03: positive budget, initial IP boundary including halt; execute local
   Machine and commit only at halt. End on last allowed step succeeds.
   Empty prepared image at IP=0 succeeds. Failure offset=current attempted IP,
   steps=successful tentative steps; bad args give zeros. */
MachineResult project_run(const CodeImage *image, size_t budget, Machine *machine);
/* E04: validate complete run before writing ANY caller trace/state/count.
   Each successful instruction gets a record: pre-IP, all post CPU fields,
   at most two CHANGED data bytes in increasing address order. Repeated stores
   of the same value produce no delta. Unused delta entries initialized zero.
   capacity counts records; NULL records allowed only capacity=0. NULL count
   invalid. On valid execution with steps>capacity return M_CAPACITY, offset
   n and steps=required count, preserving ALL outputs. Execution errors have
   precedence over capacity. Otherwise count=steps, Machine commits, and
   only records[0..count) are written. Immutable code/image enables replay. */
MachineResult project_trace(const CodeImage *image, size_t budget, Machine *machine,
                            TraceRecord *records, size_t capacity, size_t *count);
/* W01: byte ADD with modulo-256 result and carry, a/b<=255.
   W02: boundary lookup, target<=65535, map is exactly 65536 accessible bytes;
   return membership as boolean (any nonzero entry). W03: emit a little-endian
   word into two accessible bytes. Return 1/0; invalid args preserve outputs. */
int w01(unsigned a, unsigned b, uint8_t *result, int *carry);
int w02(const uint8_t *map, unsigned target, int *present);
int w03(uint16_t word, uint8_t *bytes);
#endif

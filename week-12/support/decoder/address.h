#ifndef WEEK07_ADDRESS_H
#define WEEK07_ADDRESS_H
#include "decode.h"
/* E01 helper, internal to the library. bytes begin at the displacement, after
   the ModR/M byte. mod must be 0..2, rm 0..7. Failure preserves both outputs.
   used is 0, 1 or 2. A direct address is present only for mod=0, rm=6.
   Accessible input and output objects must be disjoint, including out/used. */
DecodeStatus decode_address(const uint8_t *bytes, size_t avail, unsigned mod,
                            unsigned rm, Address *out, unsigned *used);
#endif

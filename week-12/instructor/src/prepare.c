#include "project.h"
MachineResult project_prepare(const uint8_t *bytes, size_t n, CodeImage *out)
{
    MachineResult result={M_ARGUMENT,0,0};
    if (!out || (!bytes && n) || n>65535) return result;
    CodeImage candidate={0}; candidate.bytes=bytes;candidate.length=n;
    size_t cursor=0;
    while (cursor<n) {
        Decoded d;
        result.status=machine_decode(bytes+cursor,n-cursor,&d);
        if (result.status!=M_OK) { result.offset=cursor;return result; }
        candidate.boundary[cursor]=1;
        cursor+=d.length;
    }
    candidate.boundary[n]=1;
    result.status=M_OK;result.offset=n;
    *out=candidate;
    return result;
}

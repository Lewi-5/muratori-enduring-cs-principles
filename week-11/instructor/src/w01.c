#include "lab.h"
int w01(unsigned position, AbiLocation *out)
{
    if (!out || position>=32) return 0;
    AbiLocation a={0};
    if (position<6) { a.place=ABI_GP; a.index=position; }
    else { a.place=ABI_STACK; a.offset=8u+8u*(position-6u); }
    *out=a; return 1;
}

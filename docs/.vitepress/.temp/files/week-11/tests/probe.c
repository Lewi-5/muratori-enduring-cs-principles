#include <assert.h>
#include <stdint.h>
#include <stdio.h>
extern uint64_t abi_probe_sum7(uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t,uint64_t);
int main(void)
{
    assert(abi_probe_sum7(1,2,3,4,5,6,7)==28);
    assert(abi_probe_sum7(UINT64_MAX,1,0,0,0,0,0)==0);
    for (uint64_t k=0; k<1000; ++k) assert(abi_probe_sum7(k,k,k,k,k,k,k)==k*7);
    puts("PASS one 16-line scalar ABI probe"); return 0;
}

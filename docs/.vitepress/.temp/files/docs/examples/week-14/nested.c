#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint64_t root=100, child=30, grandchild=10;
    printf("root self=%" PRIu64 "\n",root-child);
    printf("recursive id inclusive=%" PRIu64 " self=%" PRIu64 "\n",
           child+grandchild,(child-grandchild)+grandchild);
    printf("covered=%" PRIu64 " inclusive sum=%" PRIu64 "\n",
           (root-child)+(child-grandchild)+grandchild,root+child+grandchild);
    return 0;
}

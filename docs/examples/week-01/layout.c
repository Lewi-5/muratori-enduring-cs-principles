#include <stddef.h>
#include <stdio.h>

struct Loose { char first; int number; char last; };
struct Tight { int number; char first; char last; };

int main(void)
{
    printf("Loose: size=%zu first=%zu number=%zu last=%zu\n", sizeof(struct Loose),
           offsetof(struct Loose, first), offsetof(struct Loose, number), offsetof(struct Loose, last));
    printf("Tight: size=%zu number=%zu first=%zu last=%zu\n", sizeof(struct Tight),
           offsetof(struct Tight, number), offsetof(struct Tight, first), offsetof(struct Tight, last));
    return 0;
}

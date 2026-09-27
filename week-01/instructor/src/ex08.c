#include <stddef.h>
#include <stdio.h>

struct A { char tag; double value; int count; };
struct B { double value; int count; char tag; };

int main(void)
{
    printf("members char=%zu double=%zu int=%zu\n", sizeof(char), sizeof(double), sizeof(int));
    printf("A size=%zu tag=%zu value=%zu count=%zu\n", sizeof(struct A),
           offsetof(struct A, tag), offsetof(struct A, value), offsetof(struct A, count));
    printf("B size=%zu value=%zu count=%zu tag=%zu\n", sizeof(struct B),
           offsetof(struct B, value), offsetof(struct B, count), offsetof(struct B, tag));
    return 0;
}

/* Reuse the tested layout model; keep the full exercise's demo out of main. */
#define main layout_demo_main
#include "../src/ex03.c"
#undef main
#include <string.h>

static const MemberSpec members[5] = {
    {sizeof(char), alignof(char)}, {sizeof(double), alignof(double)},
    {sizeof(short), alignof(short)}, {sizeof(int), alignof(int)}, {sizeof(char), alignof(char)}
};
static size_t minimum = SIZE_MAX, maximum, permutations;

static void visit(size_t order[5], size_t depth, unsigned used, int print)
{
    if (depth != 5) {
        for (size_t i = 0; i < 5; ++i) if ((used & (1u << i)) == 0) {
            order[depth] = i;
            visit(order, depth + 1, used | (1u << i), print);
        }
        return;
    }
    MemberSpec specs[5];
    for (size_t i = 0; i < 5; ++i) specs[i] = members[order[i]];
    size_t offsets[5], size, align;
    if (!predict_layout(specs, 5, offsets, &size, &align)) return;
    if (!print) {
        ++permutations;
        if (size < minimum) minimum = size;
        if (size > maximum) maximum = size;
    } else if (size == minimum) {
        /* A and E are distinct char fields, so all 120 identity permutations count. */
        char names[6];
        for (size_t i = 0; i < 5; ++i) names[i] = "ABCDE"[order[i]];
        names[5] = '\0';
        printf("minimum_order=%s\n", names);
    }
}

int main(void)
{
    size_t order[5];
    visit(order, 0, 0, 0);
    printf("permutations=%zu min=%zu max=%zu\n", permutations, minimum, maximum);
    visit(order, 0, 0, 1);
    return permutations != 120;
}

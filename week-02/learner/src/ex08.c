#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef struct { uint32_t id; uint32_t next; double weight; } Record;

Record *node_at(Record *table, size_t count, uint32_t index)
{
    /* TODO: implement the corresponding learner contract. */
    (void)table; (void)count; (void)index; return NULL;
}

int chain_length(const Record *table, size_t count, uint32_t head, size_t *out)
{
    /* TODO: implement the corresponding learner contract. */
    (void)table; (void)count; (void)head; (void)out; return 0;
}

int main(void)
{
    Record original[4] = {{0, 0, 0}, {1, 3, 0}, {2, 0, 0}, {3, 2, 0}}, copy[4];
    memcpy(copy, original, sizeof copy); /* Same representation, preserved slot identities. */
    size_t length, copied;
    if (!chain_length(original, 4, 1, &length) || !chain_length(copy, 4, 1, &copied)) return 1;
    struct PointerRow { struct PointerRow *next; } links[4] = {{NULL}}, link_copy[4];
    links[1].next = &links[3]; links[3].next = &links[2];
    memcpy(link_copy, links, sizeof links);
    int follows_copy = link_copy[1].next == &link_copy[3];
    if (link_copy[1].next != &links[3] || link_copy[3].next != &links[2]
        || link_copy[3].next == &link_copy[2]) return 1;
    copy[2].next = 1;
    size_t unchanged = 99;
    int cycle = !chain_length(copy, 4, 1, &unchanged) && unchanged == 99;
    printf("chain=%zu copy_chain=%zu pointer_links_follow_copy=%d cycle_rejected=%d\n",
           length, copied, follows_copy, cycle);
    return follows_copy || !cycle;
}

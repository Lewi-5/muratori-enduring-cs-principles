#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

int member_offset(size_t index, size_t count, size_t element_size, size_t within,
                  size_t member_size, size_t *out)
{
    /* TODO: implement the corresponding learner contract. */
    (void)index; (void)count; (void)element_size; (void)within; (void)member_size; (void)out; return 0;
}

int grid_offset(size_t rows, size_t cols, size_t element_size, size_t row,
                size_t col, size_t *out)
{
    /* TODO: implement the corresponding learner contract. */
    (void)rows; (void)cols; (void)element_size; (void)row; (void)col; (void)out; return 0;
}

int main(void)
{
    struct A { char tag; double value; int count; } recs[4] = {{0}};
    int grid[3][4] = {{0}};
    for (size_t i = 0; i < 4; ++i) {
        size_t offset;
        if (!member_offset(i, 4, sizeof recs[0], offsetof(struct A, count), sizeof(int), &offset)) return 1;
        int match = (unsigned char *)&recs + offset == (unsigned char *)&recs[i].count;
        printf("recs[%zu].count offset=%zu match=%d\n", i, offset, match);
        if (!match) return 1;
    }
    for (size_t row = 0; row < 3; ++row) for (size_t col = 0; col < 4; ++col) {
        size_t offset;
        if (!grid_offset(3, 4, sizeof(int), row, col, &offset)) return 1;
        int match = (unsigned char *)&grid + offset == (unsigned char *)&grid[row][col];
        printf("grid[%zu][%zu] offset=%zu match=%d\n", row, col, offset, match);
        if (!match) return 1;
    }
    return 0;
}

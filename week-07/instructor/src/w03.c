#include <stddef.h>
#include <stdint.h>
int next_offset(size_t offset, size_t length, size_t total, size_t *out)
{
    if (!out || offset > total || !length || length > total - offset) return 0;
    *out = offset + length;
    return 1;
}

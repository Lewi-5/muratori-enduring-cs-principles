#include <stdint.h>
#include <stdio.h>

int count_file(const char *path, size_t *bytes, size_t *newlines)
{
    FILE *file = fopen(path, "rb");
    if (file == NULL) return 0;
    size_t b = 0, n = 0;
    int ch, ok = 1; /* int preserves every unsigned char value and EOF. */
    while ((ch = fgetc(file)) != EOF) {
        if (b == SIZE_MAX) { ok = 0; break; }
        ++b;
        if (ch == '\n') ++n;
    }
    if (ferror(file)) ok = 0; /* EOF alone is not an error. */
    if (fclose(file) != 0) ok = 0; /* Do not short-circuit this close. */
    if (!ok) return 0;
    *bytes = b;
    *newlines = n;
    return 1;
}

int main(int argc, char **argv)
{
    size_t bytes, newlines;
    if (argc != 2 || !count_file(argv[1], &bytes, &newlines)) {
        fputs("error: expected readable file; open/read/close failed\n", stderr);
        return 1;
    }
    printf("bytes=%zu newlines=%zu\n", bytes, newlines);
    return 0;
}

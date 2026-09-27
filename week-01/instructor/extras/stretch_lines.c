#include <stdint.h>
#include <stdio.h>

int count_lines(const char *path, size_t *bytes, size_t *newlines, size_t *lines)
{
    FILE *file = fopen(path, "rb");
    if (file == NULL) return 0;
    size_t b = 0, n = 0;
    int ch, last = EOF, ok = 1;
    while ((ch = fgetc(file)) != EOF) {
        if (b == SIZE_MAX) { ok = 0; break; }
        ++b;
        if (ch == '\n') ++n;
        last = ch; /* Only the last character, not the whole line, is needed. */
    }
    if (ferror(file)) ok = 0;
    if (fclose(file) != 0) ok = 0;
    if (!ok) return 0;
    *bytes = b;
    *newlines = n;
    *lines = n + (b != 0 && last != '\n');
    return 1;
}

int main(int argc, char **argv)
{
    size_t bytes, newlines, lines;
    if (argc != 2 || !count_lines(argv[1], &bytes, &newlines, &lines)) {
        fputs("error: open/read/close or count failure\n", stderr);
        return 1;
    }
    printf("bytes=%zu newlines=%zu lines=%zu\n", bytes, newlines, lines);
    return 0;
}

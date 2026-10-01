/* W04: own a copy of a string. Reference solution. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Returns a newly allocated copy of text, which the caller must free exactly once.
   Returns NULL for a NULL text or when allocation fails. strlen counts the characters
   before the terminating NUL; the copy needs one more byte to hold that NUL. */
char *copy_text(const char *text)
{
    if (text == NULL) return NULL;
    size_t length = strlen(text);
    char *copy = malloc(length + 1);
    if (copy == NULL) return NULL;
    memcpy(copy, text, length + 1);
    return copy;
}

int main(void)
{
    char *copy = copy_text("geolab");
    if (copy == NULL) {
        fputs("copy_text: allocation failed\n", stderr);
        return 1;
    }
    copy[0] = 'G'; /* the copy is ours to change; the string literal is not */
    printf("copy=%s length=%zu\n", copy, strlen(copy));
    free(copy);
    return 0;
}

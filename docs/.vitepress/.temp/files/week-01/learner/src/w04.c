/* W04: own a copy of a string. Warm-up scaffold: fill in the TODO body. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *copy_text(const char *text)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)text;
    return NULL;
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

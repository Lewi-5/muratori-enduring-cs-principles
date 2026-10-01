#include <stdlib.h>
int main(void) { int *p=malloc(sizeof *p);if (!p) return 2; *p=42;free(p);return *(volatile int *)p==42 ? 0:1; }

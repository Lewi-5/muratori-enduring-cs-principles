#ifndef WEEK05_ENVINFO_H
#define WEEK05_ENVINFO_H
#include <stdio.h>
/* Supplied: print the environment block that begins every bench output. Each line is "env KEY=VALUE source=S",
   where S names where the value came from (compiler macro, Makefile, uname(2), /proc/cpuinfo, clock_getres).
   Returns 1 if every write succeeded, 0 otherwise. Missing information is printed as "unknown", not guessed. */
int envinfo_print(FILE *out);
#endif

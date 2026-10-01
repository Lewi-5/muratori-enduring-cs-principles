#include "lab.h"
int w01(Item *a,Item *b) { if (!a || !b) return 0; if (a->key>b->key) { Item t=*a; *a=*b; *b=t; } return 1; }

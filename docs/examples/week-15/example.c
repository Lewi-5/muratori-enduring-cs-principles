#include <stdio.h>
int main(void)
{
    unsigned keys[]={3,1,3,0},tags[]={0,1,2,3};
    for (unsigned i=1;i<4;++i) {
        unsigned key=keys[i],tag=tags[i],j=i;
        while (j && keys[j-1]>key) { keys[j]=keys[j-1];tags[j]=tags[j-1];--j; }
        keys[j]=key;tags[j]=tag;
    }
    for (unsigned i=0;i<4;++i) printf("%u:%u%s",keys[i],tags[i],i==3 ? "\n":" ");
    return 0;
}

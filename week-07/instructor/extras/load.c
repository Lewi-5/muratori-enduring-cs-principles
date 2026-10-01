/* Linux/POSIX target probe, not ISO C pointer conversion advice.
   gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -Iinclude
   instructor/extras/load.c -ldl -o /tmp/load
   /tmp/load ./build/instructor/gcc/debug/libdecode.so */
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include "decode.h"
int main(int argc, char **argv)
{
    if (argc!=2) return 1;
    void *handle=dlopen(argv[1],RTLD_NOW);
    if (!handle) { fprintf(stderr,"%s\n",dlerror()); return 1; }
    (void)dlerror();
    void *symbol=dlsym(handle,"decoder_api_version");
    const char *error=dlerror();
    if (error || !symbol) {
        fprintf(stderr,"%s\n",error ? error : "missing symbol");
        (void)dlclose(handle); return 1;
    }
    unsigned (*version)(void);
    _Static_assert(sizeof version==sizeof symbol,"requires this POSIX pointer representation");
    memcpy(&version,&symbol,sizeof version);
    unsigned revision=version();
    printf("api=%u\n",revision);
    int closed=dlclose(handle);
    return revision==DEC_API_VERSION && closed==0 ? 0 : 1;
}

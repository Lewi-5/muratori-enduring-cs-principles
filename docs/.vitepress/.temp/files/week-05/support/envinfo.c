/* Supplied: the environment reporter. No exercise answer lives here. POSIX (uname) and Linux (/proc/cpuinfo).
   The Makefile compiles every file with -D_POSIX_C_SOURCE=200809L. */
#include "envinfo.h"
#include <stdint.h>
#include <string.h>
#include <sys/utsname.h>
#include "buildinfo.h"
#include "monotonic.h"

#ifndef GEOLAB_BUILD_FLAGS
#define GEOLAB_BUILD_FLAGS "unknown"
#endif
#ifndef GEOLAB_BUILD_VARIANT
#define GEOLAB_BUILD_VARIANT "unknown"
#endif

/* Copy the value after the first ':' of the "model name" line, trimmed, into out. Returns 1 if found. */
static int cpu_model(char *out, size_t size)
{
    FILE *f = fopen("/proc/cpuinfo", "r");
    if (f == NULL) return 0;
    char line[512];
    int found = 0;
    while (!found && fgets(line, sizeof line, f) != NULL) {
        if (strncmp(line, "model name", 10) != 0) continue;
        const char *colon = strchr(line, ':');
        if (colon == NULL) continue;
        ++colon;
        while (*colon == ' ' || *colon == '\t') ++colon;
        size_t n = strcspn(colon, "\n");
        if (n >= size) n = size - 1;
        memcpy(out, colon, n);
        out[n] = '\0';
        found = 1;
    }
    fclose(f);
    return found;
}

int envinfo_print(FILE *out)
{
    int ok = 1;
#ifdef __VERSION__
    const char *compiler = __VERSION__;
#else
    const char *compiler = "unknown";
#endif
    ok &= fprintf(out, "env compiler=\"%s\" source=__VERSION__\n", compiler) > 0;
    ok &= fprintf(out, "env build_variant=%s source=Makefile\n", GEOLAB_BUILD_VARIANT) > 0;
    ok &= fprintf(out, "env flags=\"%s\" source=Makefile\n", GEOLAB_BUILD_FLAGS) > 0;
    struct utsname u;
    if (uname(&u) == 0) {
        ok &= fprintf(out, "env uname=\"%s %s %s\" source=uname(2)\n", u.sysname, u.release, u.machine) > 0;
    } else {
        ok &= fprintf(out, "env uname=unknown source=uname(2)\n") > 0;
    }
    char model[256];
    if (cpu_model(model, sizeof model)) ok &= fprintf(out, "env cpu=\"%s\" source=/proc/cpuinfo\n", model) > 0;
    else ok &= fprintf(out, "env cpu=unknown source=/proc/cpuinfo\n") > 0;
    uint64_t res = 0;
    if (mono_resolution_ns(&res)) ok &= fprintf(out, "env clock=CLOCK_MONOTONIC resolution_ns=%llu source=clock_getres\n", (unsigned long long)res) > 0;
    else ok &= fprintf(out, "env clock=CLOCK_MONOTONIC resolution_ns=unknown source=clock_getres\n") > 0;
    return ok;
}

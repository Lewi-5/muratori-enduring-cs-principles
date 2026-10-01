#include "project.h"
MachineResult project_run(const CodeImage *image, size_t budget, Machine *m)
{
    MachineResult result={M_ARGUMENT,0,0};
    if (!image || !m || !budget || image->length>65535 || (!image->bytes && image->length)) return result;
    if (m->cpu.ip>image->length || !image->boundary[m->cpu.ip]) {
        result.status=M_TARGET;result.offset=m->cpu.ip;return result;
    }
    Machine candidate=*m;
    while (candidate.cpu.ip!=image->length) {
        result.offset=candidate.cpu.ip;
        if (result.steps==budget) { result.status=M_LIMIT;return result; }
        result.status=project_step(image,&candidate);
        if (result.status!=M_OK) return result;
        ++result.steps;
    }
    result.status=M_OK;result.offset=image->length;
    *m=candidate;
    return result;
}

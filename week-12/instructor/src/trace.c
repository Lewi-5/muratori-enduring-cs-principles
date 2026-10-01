#include "project.h"
MachineResult project_trace(const CodeImage *image, size_t budget, Machine *m,
                            TraceRecord *records, size_t capacity, size_t *count)
{
    MachineResult result={M_ARGUMENT,0,0};
    if (!m || !count || (!records && capacity)) return result;
    Machine checked=*m;
    result=project_run(image,budget,&checked);
    if (result.status!=M_OK) return result;
    if (result.steps>capacity) { result.status=M_CAPACITY;return result; }
    Machine replay=*m;
    for (size_t k=0;k<result.steps;++k) {
        Machine before=replay;
        TraceRecord record={0};record.before_ip=before.cpu.ip;
        /* All execution/boundary/stack checks passed against the same initial
           state and immutable image. No fallible caller output begins earlier. */
        (void)project_step(image,&replay);
        record.after=replay.cpu;
        for (unsigned a=0;a<65536;++a) if (before.memory[a]!=replay.memory[a]) {
            record.addresses[record.changed_count]=(uint16_t)a;
            record.values[record.changed_count]=replay.memory[a];
            ++record.changed_count; /* <=2 for every instruction in this subset */
        }
        records[k]=record;
    }
    *count=result.steps;
    *m=checked;
    return result;
}

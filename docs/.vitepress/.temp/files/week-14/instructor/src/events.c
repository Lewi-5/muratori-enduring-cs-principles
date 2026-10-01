#include "profile.h"
ProfileStatus profile_begin(Profile *p,unsigned id,uint64_t now)
{
    if (!p || id>=PROFILE_IDS) return P_ARGUMENT;
    if (p->depth==PROFILE_DEPTH) return P_CAPACITY;
    if (p->has_time && now<p->last) return P_ORDER;
    Profile next=*p;Frame frame={id,now,0};next.stack[next.depth++]=frame;
    next.last=now;next.has_time=1;*p=next;return P_OK;
}
ProfileStatus profile_end(Profile *p,unsigned id,uint64_t now)
{
    if (!p || id>=PROFILE_IDS) return P_ARGUMENT;
    if (!p->depth || p->stack[p->depth-1].id!=id) return P_NEST;
    if (now<p->last) return P_ORDER;
    Profile next=*p;Frame frame=next.stack[next.depth-1];uint64_t elapsed=now-frame.begin;
    if (frame.children>elapsed) return P_ORDER;
    ProfileStatus s=profile_accumulate(&next.totals[id],elapsed,elapsed-frame.children);
    if (s!=P_OK) return s;
    --next.depth;
    if (next.depth) {
        Frame *parent=&next.stack[next.depth-1];
        if (parent->children>UINT64_MAX-elapsed) return P_OVERFLOW;
        parent->children+=elapsed;
    }
    Frame cleared={0};next.stack[next.depth]=cleared;next.last=now;next.has_time=1;
    *p=next;return P_OK;
}

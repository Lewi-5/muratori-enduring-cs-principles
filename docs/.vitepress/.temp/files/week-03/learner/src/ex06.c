/* E06: segment intersection. Learner scaffold. */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

typedef enum { SEG_NONE, SEG_POINT, SEG_OVERLAP } SegKind;
typedef struct { SegKind kind; Vec2 a; Vec2 b; } SegResult;

/* Domain: every coordinate finite with |c| <= 2^25 (see learner/exercises.md, E06.C). */
int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)p0;
    (void)p1;
    (void)q0;
    (void)q1;
    (void)out;
    return 0;
}

static const char *kind_name(SegKind k) { return k == SEG_NONE ? "none" : (k == SEG_POINT ? "point" : "overlap"); }

int main(void)
{
    static const struct { const char *name; Vec2 p0, p1, q0, q1; } cases[] = {
        {"crossing",             {0, 0}, {2, 2}, {0, 2}, {2, 0}},
        {"endpoint_touch",       {0, 0}, {1, 1}, {1, 1}, {2, 0}},
        {"t_junction",           {0, 0}, {2, 0}, {1, 0}, {1, 2}},
        {"parallel_disjoint",    {0, 0}, {2, 0}, {0, 1}, {2, 1}},
        {"collinear_disjoint",   {0, 0}, {1, 0}, {2, 0}, {3, 0}},
        {"collinear_touching",   {0, 0}, {1, 0}, {1, 0}, {2, 0}},
        {"collinear_overlap",    {0, 0}, {2, 0}, {3, 0}, {1, 0}},
        {"point_on_segment",     {1, 1}, {1, 1}, {0, 0}, {2, 2}},
        {"point_off_segment",    {1, 2}, {1, 2}, {0, 0}, {2, 2}},
        {"same_points",          {1, 1}, {1, 1}, {1, 1}, {1, 1}},
        {"different_points",     {1, 1}, {1, 1}, {2, 2}, {2, 2}},
        {"non_integer_crossing", {0, 0}, {3, 1}, {0, 1}, {3, 0}},
    };
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        SegResult r;
        if (!segment_intersect(cases[i].p0, cases[i].p1, cases[i].q0, cases[i].q1, &r)) return 1;
        printf("case=%s kind=%s a=(%g,%g) b=(%g,%g)\n", cases[i].name, kind_name(r.kind), r.a.x, r.a.y, r.b.x, r.b.y);
    }
    return 0;
}

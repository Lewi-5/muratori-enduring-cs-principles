/* E06: segment intersection. Reference solution. */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

typedef enum { SEG_NONE, SEG_POINT, SEG_OVERLAP } SegKind;
typedef struct { SegKind kind; Vec2 a; Vec2 b; } SegResult;

/* Domain: every coordinate finite with |c| <= 2^25. For integer-valued coordinates in that domain
   a difference is at most 2^26, a product of two differences at most 2^52, and a cross product
   (difference of two such products) at most 2^53 in magnitude: every value is an exact integer
   below 2^53, so the signs used below are exactly correct. */
#define SEG_LIMIT 33554432.0 /* 2^25 */

static int in_domain(Vec2 p) { return fabs(p.x) <= SEG_LIMIT && fabs(p.y) <= SEG_LIMIT; } /* false for NaN */
static Vec2 sub(Vec2 a, Vec2 b) { Vec2 r = {a.x - b.x, a.y - b.y}; return r; }
static double cross2(Vec2 a, Vec2 b) { return a.x * b.y - a.y * b.x; }
static int same(Vec2 a, Vec2 b) { return a.x == b.x && a.y == b.y; }
static int lex_less(Vec2 a, Vec2 b) { return a.x < b.x || (a.x == b.x && a.y < b.y); }

static SegResult none(void) { SegResult r = {SEG_NONE, {0, 0}, {0, 0}}; return r; }
static SegResult point(Vec2 p) { SegResult r = {SEG_POINT, p, p}; return r; }

/* Is p on the closed segment s0-s1 (s0 != s1)? */
static int on_segment(Vec2 s0, Vec2 s1, Vec2 p)
{
    if (cross2(sub(s1, s0), sub(p, s0)) != 0.0) return 0;
    Vec2 lo = lex_less(s0, s1) ? s0 : s1, hi = lex_less(s0, s1) ? s1 : s0;
    return !lex_less(p, lo) && !lex_less(hi, p); /* lexicographic order is monotone along a line */
}

int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out)
{
    if (out == NULL || !in_domain(p0) || !in_domain(p1) || !in_domain(q0) || !in_domain(q1)) return 0;
    int p_point = same(p0, p1), q_point = same(q0, q1);
    SegResult r;
    if (p_point && q_point) r = same(p0, q0) ? point(p0) : none();
    else if (p_point) r = on_segment(q0, q1, p0) ? point(p0) : none();
    else if (q_point) r = on_segment(p0, p1, q0) ? point(q0) : none();
    else {
        Vec2 d1 = sub(p1, p0), d2 = sub(q1, q0), w = sub(q0, p0);
        double denom = cross2(d1, d2);
        if (denom != 0.0) {
            /* p0 + t d1 = q0 + u d2  =>  t = cross(w, d2)/denom, u = cross(w, d1)/denom. */
            double tn = cross2(w, d2), un = cross2(w, d1);
            if (denom < 0.0) { denom = -denom; tn = -tn; un = -un; }
            if (tn < 0.0 || tn > denom || un < 0.0 || un > denom) r = none();
            else if (tn == 0.0) r = point(p0);          /* endpoints are returned exactly, */
            else if (tn == denom) r = point(p1);        /* never recomputed */
            else if (un == 0.0) r = point(q0);
            else if (un == denom) r = point(q1);
            else {
                Vec2 x = {(p0.x * denom + tn * d1.x) / denom, (p0.y * denom + tn * d1.y) / denom};
                r = point(x);                           /* one division: correctly rounded */
            }
        } else if (cross2(w, d1) != 0.0) {
            r = none();                                  /* parallel, distinct lines */
        } else {
            Vec2 a1 = lex_less(p0, p1) ? p0 : p1, b1 = lex_less(p0, p1) ? p1 : p0;
            Vec2 a2 = lex_less(q0, q1) ? q0 : q1, b2 = lex_less(q0, q1) ? q1 : q0;
            Vec2 lo = lex_less(a1, a2) ? a2 : a1, hi = lex_less(b1, b2) ? b1 : b2;
            if (lex_less(hi, lo)) r = none();
            else if (same(lo, hi)) r = point(lo);
            else { r.kind = SEG_OVERLAP; r.a = lo; r.b = hi; }
        }
    }
    *out = r; /* commit last */
    return 1;
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

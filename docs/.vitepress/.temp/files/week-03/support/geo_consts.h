#ifndef WEEK03_GEO_CONSTS_H
#define WEEK03_GEO_CONSTS_H
/* Supplied constants and types only; no exercise answer lives here.
   GEO_PI is a decimal literal (M_PI is POSIX, not ISO C): the compiler rounds
   it to the nearest double, which is NOT the real number pi.
   GEO_EARTH_RADIUS_KM is a model constant for a sphere, not a geodesy claim. */
#define GEO_PI 3.14159265358979323846
#define GEO_EARTH_RADIUS_KM 6371.0088

typedef struct { double x, y; } Vec2;
typedef struct { double x, y, z; } Vec3;
#endif

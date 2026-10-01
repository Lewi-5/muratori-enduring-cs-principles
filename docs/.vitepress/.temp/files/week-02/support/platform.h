#ifndef WEEK02_PLATFORM_H
#define WEEK02_PLATFORM_H
/* Test-only override exercises the skip path; it does not emulate another ABI. */
#if defined(__linux__) && defined(__x86_64__) && !defined(__ILP32__) && !defined(W02_PORTABLE_ONLY)
#define REFERENCE_ABI 1
#else
#define REFERENCE_ABI 0
#endif
#endif

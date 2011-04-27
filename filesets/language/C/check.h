#ifndef CHECK_INCLUDED
#define CHECK_INCLUDED

#include <stdbool.h>
#include <stdio.h>

#define CHECK_EQ(type,expected,actual)   \
    do \
    { \
        type x = expected; \
        type a = actual; \
        CHECK_INNER(type ## _equal(x,a), "EQ", \
            type, x, #expected, a, #actual, \
            __FILE__, __LINE__, __func__); \
    } while (0)

#define CHECK_NE(type,expected,actual)   \
    do \
    { \
        type x = expected; \
        type a = actual; \
        CHECK_INNER(!type ## _equal(x,a), "NE", \
            type, x, #expected, a, #actual, \
            __FILE__, __LINE__, __func__); \
    } while (0)

#define CHECK_INNER(tf, ass, type, e, expected, a, actual, file, line, func) \
    if (tf) \
        pass_count++; \
    else \
    { \
        FILE * err = stderr; \
        fail_count++; \
        fprintf(err, "%s:%lu: %s: Assertion `CHECK_%s(%s, %s, %s)' failed.\n", \
            file, (unsigned long)line, func, \
            ass, #type, expected, actual); \
        fprintf(err, "    %s == ", expected); \
        type ## _print(err, x); \
        fputc('\n', err); \
        fprintf(err, "    %s == ", actual); \
        type ## _print(err, a); \
        fputc('\n', err); \
    }

extern int pass_count;
extern int fail_count;

extern bool int_equal(int lhs, int rhs);
extern void int_print(FILE * err, int value);

extern void check_report(void);

#endif


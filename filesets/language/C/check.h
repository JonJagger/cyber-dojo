#ifndef CHECK_INCLUDED
#define CHECK_INCLUDED

#include <stdbool.h>
#include <stdio.h>

/*
 * CHECK_EQ(type, expected, actual) 
 * CHECK_NE(type, expected, actual)
 *
 * The 1st type parameter is the type name of the 2nd and 3rd
 * parameters. Suppose the first parameter is fubar, then the 
 * macros assume the existence of two functions:
 * 
 *   bool wibble_equal(wibble expected, wibble actual);
 *   void wibble_print(FILE *, wibble to_print);
 *
 * If the type of the parameter includes symbols such as * ()
 * you will need to create a typedef.
 */

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
    do { \
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
        } \
    } while (0)

#define RUN_ALL(tests) \
    do { \
        for (int at = 0; at != sizeof tests / sizeof tests[0]; at++) \
            tests[at](); \
    } while (0)

extern int pass_count;
extern int fail_count;

extern bool int_equal(int lhs, int rhs);
extern void int_print(FILE * err, int value);

extern void check_report(void);

#endif


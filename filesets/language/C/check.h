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
 *   bool check_fubar_equal(fubar expected, fubar actual);
 *   void check_fubar_print(FILE *, fubar to_print);
 *
 * If the type of the parameter includes symbols such as * ()
 * you will need to create a typedef.
 */

#define CHECK_EQ(type,expected,actual)   \
    do \
    { \
        if (#expected[0] != 'x') \
        { \
            type x0 = expected; \
            type x1 = actual; \
            CHECK_INNER( \
                check_ ## type ## _print, \
                check_ ## type ## _equal(x0,x1), "EQ", \
                type, x0, #expected, x1, #actual, \
                __FILE__, __LINE__, __func__); \
        } \
        else \
        { \
            type y0 = expected; \
            type y1 = actual; \
            CHECK_INNER( \
                check_ ## type ## _print, \
                check_ ## type ## _equal(y0,y1), "EQ", \
                type, y0, #expected, y1, #actual, \
                __FILE__, __LINE__, __func__); \
        } \
    } while (0)


#define CHECK_NE(type,expected,actual)   \
    do \
    { \
        if (#expected[0] != 'x') \
        { \
            type x0 = expected; \
            type x1 = actual; \
            CHECK_INNER( \
                check_ ## type ## _print, \
                !check_ ## type ## _equal(x0,x1), "NE", \
                type, x0, #expected, x1, #actual, \
                __FILE__, __LINE__, __func__); \
        } \
        else \
        { \
            type y0 = expected; \
            type y1 = actual; \
            CHECK_INNER( \
                check_ ## type ## _print, \
                !check_ ## type ## _equal(y0,y1), "NE", \
                type, y0, #expected, y1, #actual, \
                __FILE__, __LINE__, __func__); \
        } \
    } while (0)


#define CHECK_INNER(pf, tf, ass, type, e, expected, a, actual, file, line, func) \
    do { \
        if (tf) \
            check_pass_count++; \
        else \
        { \
            check_fail_count++; \
            fprintf(check_log, "%s:%lu: %s: Assertion `CHECK_%s(%s, %s, %s)' failed.\n", \
                file, (unsigned long)line, func, \
                ass, #type, expected, actual); \
            fprintf(check_log, "    %s == ", expected); \
            pf(check_log, e); \
            fputc('\n', check_log); \
            fprintf(check_log, "    %s == ", actual); \
            pf(check_log, a); \
            fputc('\n', check_log); \
        } \
    } while (0)

#define RUN_ALL(tests) \
    do { \
        for (int at = 0; at != sizeof tests / sizeof tests[0]; at++) \
            tests[at](); \
    } while (0)


extern FILE * check_log;

extern int check_pass_count;
extern int check_fail_count;

extern bool check_int_equal(int lhs, int rhs);
extern void check_int_print(FILE *, int value);

extern bool check_bool_equal(bool lhs, bool rhs);
extern void check_bool_print(FILE *, bool value);

extern void check_log_print(void);

#endif




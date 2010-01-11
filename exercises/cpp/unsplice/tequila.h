#ifndef TEQUILA_INCLUDED
#define TEQUILA_INCLUDED

/*
 *-----------------------------------------------------------------------
 * TEQUILA: A C unit testing framework by Jon Jagger (jon@jaggersoft.com)
 *-----------------------------------------------------------------------
 *
 * 1. Writing Your Tests
 * =====================
 * In Tequila a named block is the basic unit of test granularity
 * (not an individual function). Many named test blocks live inside a 
 * function and when the function is called by the tequila framework
 * one and only one of the named test blocks executes. To ensure all the 
 * named test blocks execute tequila simply calls the function many 
 * times. It looks this:
 *
 * void example(void)
 * {
 *     TEST("one add one is two")
 *     { ...
 *     }
 *     TEST("empty container has size of zero")
 *     { ...
 *     }
 * }
 *
 * Requirements:
 * o) TEST's parameter must be non-empty string literal
 *    This is checked at runtime
 * o) TEST's parameters must be unique within its containing function
 *    This is checked at runtime
 * 
 * 2. Making Your Assertions
 * =========================
 * Tequila assertions use the ARE_EQUAL macro to make
 * equality assertions. 
 *
 * ARE_EQUAL
 * ---------
 * This macro takes three arguments
 *
 *   1) the name of the type, eg int
 *
 *      This must be a legal identifier. If the type you
 *      wish to test for equality is not a simple identifier
 *      (eg char*) then you must use a typedef to create an
 *      identifier alias for it.
 *
 *   2) the expected value (of type specified in the first argument)
 *
 *   3) the actual value (of type specified in the first argument)
 *
 *      The second and third arguments can be any expression that
 *      can initialize a variable of the type given in the
 *      first argument.
 *        
 *
 * The macro expansion relies on two functions. If the type named
 * as the first argument of ARE_EQUAL is X then the two functions
 * will be called
 *
 *             tequila_equal_X 
 *             tequila_diff_print_X
 *
 * tequila_equal_X
 * ---------------
 * This function accepts two arguments both of type X
 * and must return a value which can be interpreted as a
 * boolean to indicate if the two arguments are equal or
 * not (true if they are equal, false if they are not).
 *
 * For example:
 *
 *   ARE_EQUAL(int, 2, 1+1); relies on the presence of
 *
 *     bool tequila_equal_int(int lhs, int rhs);
 *
 * tequila_diff_print_X
 * --------------------
 * This function is called if tequila_equal_X returns a value
 * interpreted as false. You should try and print information
 * on exactly where the two values differ as precisely as 
 * possible. It does not need to return anything and must 
 * accept five arguments:
 *
 *    o) The 1st is X converted to a string literal
 *    o) The 2nd is the 2nd argument to ARE_EQUAL 
 *         (the expected value, of type X)
 *    o) The 3rd is the 3rd argument to ARE_EQUAL 
 *         (the actual value, of type X)
 *    o) The 4th is the 2nd argument to ARE_EQUAL 
 *         converted to a string literal.
 *    o) The 5th is the 3rd argument to ARE_EQUAL
 *         converted to a string literal.
 *
 * For example:
 *
 *   ARE_EQUAL(int, 2, 1+1); relies on the presence of
 *
 *     void tequila_diff_print_int(const char *, 
 *                                 int, int, 
 *                                 const char *, const char *);
 *
 *   and the actual call will be
 *
 *          tequila_diff_print_int("int", 2, 1+1, "2", "1+1");
 * 
 * 
 * 3. Executing Your Tests
 * =======================
 * In Tequila manual registration is minimized since only functions
 * containing named test blocks are registered into an array which
 * is then dispatched to the tequila framework. 
 *
 * #define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))
 *
 * const tequila_test_function slammers[] =
 * {
 *     TEQUILA(example),
 *     TEQUILA(...),
 * };
 *
 * int main(void)
 * {
 *     ...
 *	   tequila_test_suite suite;
 *     tequila_block_count count;
 *
 *	   tequila_init(&suite);
 *	   tequila_add(&suite, ARRAY_SIZE(slammers), slammers);
 *     count = tequila_run(&suite);
 *	   tequila_report(&count); 
 *
 *     return tequila_outcome(&count);
 * }
 *
 *
 * 4. Extra Features
 * =================
 * o) SetUp and TearDown for free - TODOC
 * o) TEQUILA_IGNORE
 * o) TEQUILA_ONLY - TODOC
 * o) TEST_IGNORE
 * o) TEST_ONLY - TODOC
 *
 * 
 * 5. Advanced Features
 * ====================
 * o) TEST outside of a test function  TODOC
 *
 *
 */

#include <stdbool.h>
#include <stddef.h> /* size_t */

#define TEST(name)     			TEST_BLOCK(name, tequila_mode_run)
#define TEST_ONLY(name)			TEST_BLOCK(name, tequila_mode_only)
#define TEST_SKIP(name)  		TEST_BLOCK(name, tequila_mode_skip)
#define TEST_IGNORE(name)  		TEST_BLOCK(name, tequila_mode_ignore)

#define TEQUILA(name)			TEQUILA_FN(name, tequila_mode_run)
#define TEQUILA_ONLY(name)      TEQUILA_FN(name, tequila_mode_only)
#define TEQUILA_SKIP(name)		TEQUILA_FN(name, tequila_mode_skip)
#define TEQUILA_IGNORE(name)	TEQUILA_FN(name, tequila_mode_ignore)

#define TEST_BLOCK(name,mode)	if (tequila_run_test_block(\
									#name, mode, \
									__FILE__, (size_t)__LINE__))

#define TEQUILA_FN(name,mode)	{ name, #name, mode }

#define ARE_EQUAL(type,e,a)  \
	do \
	{ \
		type t_expected = e; \
		type t_actual = a; \
        bool tequila_equal_ ## type(type, type); \
		if (tequila_equal_ ## type(t_expected, t_actual)) \
		{ \
            tequila_get_test_block()->pass_count++; \
        } \
		else \
		{ \
			tequila_get_test_block()->fail_count++; \
			if (tequila_get_test_block()->mode != tequila_mode_ignore) \
            { \
                void tequila_diff_print_ ## type( \
                    const char *, type, type, const char *, const char *); \
				tequila_diff_print_ ## type(#type, t_expected, t_actual, #e, #a); \
            } \
		} \
	} \
	while (0)

/*--------------Tequila types-----------------*/

//TODO: option to show all TEST's even if empty,ignored,etc.

typedef struct tequila_test_suite tequila_test_suite;

typedef enum
{
    tequila_mode_run,
    tequila_mode_skip,
    tequila_mode_ignore,
    tequila_mode_only, /*TODO:*/

} tequila_mode;

typedef struct 
{
    void (*call)();
    const char * name;
    tequila_mode mode;	

} tequila_test_function;

typedef struct 
{
    const tequila_test_function * function;
    const char * name;
    tequila_mode mode;
    const char * filename;
    size_t line_number;
    size_t pass_count; 
    size_t fail_count;

} tequila_test_block;

enum { tequila_max_functions = 1024 };
enum { tequila_max_blocks = 64*1024 };

struct tequila_test_suite
{
    size_t test_function_index;
    size_t test_function_size;
    tequila_test_function test_functions[tequila_max_functions];

    size_t test_block_index;
    size_t test_block_size;
    tequila_test_block test_blocks[tequila_max_blocks];

    bool populate;
    size_t errors;
    bool only;
};

typedef struct
{
    size_t passed;
    size_t failed;
    size_t unknown;

    size_t ignored_passed;
    size_t ignored_failed;
    size_t ignored_unknown;

    size_t errors;

} tequila_test_count;

/*--------------Tequila functions-----------------*/

tequila_test_suite * tequila_get_test_suite(void);
tequila_test_block * tequila_get_test_block(void);

bool tequila_run_test_block(const char * str_name,
	   	                    tequila_mode mode,
	                        const char * filename,
	                        size_t line_number);

void tequila_init(tequila_test_suite * suite);

void tequila_add(tequila_test_suite * suite, 
                 size_t size, const tequila_test_function * functions);

tequila_test_count tequila_run(tequila_test_suite * suite);

void tequila_report(const tequila_test_count * count);
int tequila_outcome(const tequila_test_count * count);

tequila_test_count tequila(size_t size, const tequila_test_function * slammers);

#endif

        
        

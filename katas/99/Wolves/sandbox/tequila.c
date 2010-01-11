#include "tequila.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static tequila_test_suite * jsl_test_suite = 0;

/*
 * If you want a thread safe version of tequila you need
 * to reimplement the get and set functions below with
 * thread local storage.
 */

tequila_test_suite * tequila_get_test_suite(void)
{
    return jsl_test_suite;
}

void tequila_set_test_suite(tequila_test_suite * suite)
{
	jsl_test_suite = suite;
}

tequila_test_block * tequila_get_test_block(void)
{
	tequila_test_suite * suite = tequila_get_test_suite();
	return &suite->test_blocks[suite->test_block_index];	
}

/*----------------------------------------------------------- */


static 
void tequila_print_test_case_error(FILE * out,
                                   const tequila_test_block * test_block,
                                   const char * message)
{
	fprintf(out, "%s:%zd: error: %s TEST(%s) %s\n", 
		test_block->filename, test_block->line_number,
		test_block->function->name, test_block->name, message);
}

static 
bool tequila_valid_block_name(const tequila_test_block * test_block) 
{
	if (test_block->name[0] != '"' || strlen(test_block->name) == 2) 
	{
		tequila_print_test_case_error(stderr, test_block, 
			"expecting a non-empty string literal");
		return false;
	}
	else
		return true;
}

static
bool tequila_valid_block_names(tequila_test_suite * suite)
{
	size_t errors = 0;

	for (size_t at = 0; at != suite->test_block_size; at++)
		if (!tequila_valid_block_name(&suite->test_blocks[at]))
			errors++;
	
	suite->errors += errors;

	return errors == 0;
}


//----------------------------------------------------------------

typedef struct 
{
    const tequila_test_function * function;	
	const char * name;
	size_t index;
} block;

static 
int tequila_block_cmp(const void * x, const void * y)
{
	const block * lhs = (const block *)x;
	const block * rhs = (const block *)y;

	// function name dominates block name
	const int fn_cmp = strcmp(lhs->function->name, rhs->function->name);
	if (fn_cmp != 0)
		return fn_cmp;
	else
		return strcmp(lhs->name, rhs->name);
}

static 
bool tequila_unique_block_names(tequila_test_suite * suite)
{
	block blocks[tequila_max_blocks];
	for (size_t at = 0; at != suite->test_block_size; at++)
	{
		blocks[at].function = suite->test_blocks[at].function;
		blocks[at].name = suite->test_blocks[at].name;
		blocks[at].index = at;
	}
	qsort(blocks, suite->test_block_index, sizeof blocks[0], tequila_block_cmp);

	for (size_t at = 1; at != suite->test_block_size; at++)
	{
		if (blocks[at-1].function->call == blocks[at].function->call 
			&& strcmp(blocks[at-1].name, blocks[at].name) == 0)
		{
			FILE * out = stderr;

			const tequila_test_block * lhs = 
				&suite->test_blocks[blocks[at-1].index];

			const tequila_test_block * rhs = 
				&suite->test_blocks[blocks[at  ].index];

			const char * duplicate = "duplicate block name";
			tequila_print_test_case_error(out, lhs, duplicate);
			tequila_print_test_case_error(out, rhs, duplicate);

			suite->errors += 2;
			return false;
		}
	}
	return true;
}

//----------------------------------------------------------------

bool tequila_run_test_block(const char * str_name,
					   	    tequila_mode mode,
	                        const char * filename,
	                        size_t line_number)
{
	tequila_test_suite * suite = tequila_get_test_suite();

	if (!suite || suite->errors)
		return false;

	if (suite->populate)
    {
		if (suite->test_block_size == tequila_max_blocks)
		{	
			// TODO: print blocks[] full diagnostic here?
			suite->errors++;;
		}
		else
		{
			tequila_test_block * test_block = 
				&suite->test_blocks[suite->test_block_size];

		    test_block->function = 
				&suite->test_functions[suite->test_function_index];

		    test_block->name = str_name;
			test_block->mode = mode;
			test_block->filename = filename;
		    test_block->line_number = line_number;
			suite->test_block_size++;

			if (test_block->mode == tequila_mode_only)
				suite->only = true;
		}
	    return false;
    }
	else
	{
		const tequila_test_block * test_block = 
			&suite->test_blocks[suite->test_block_index];
			
		//TODO: ONLY at function level...
		if (suite->only && test_block->mode != tequila_mode_only)
			return false;
		else
		    return test_block->mode != tequila_mode_skip 
				&& test_block->function->mode != tequila_mode_skip
				&& strcmp(test_block->name, str_name) == 0;
	}
}

/* ------------------------------------------------------ */

void tequila_init(tequila_test_suite * suite)
{
	suite->test_function_size = 0;
	suite->test_block_size = 0;
	suite->errors = 0;
	suite->only = false;
}

/* ------------------------------------------------------ */

void tequila_add(tequila_test_suite * suite, 
                 size_t size, const tequila_test_function * functions) 
{
	if (!suite || suite->errors)
		return;

	const size_t function_slots_left = 
		tequila_max_functions - suite->test_function_size;

	if (function_slots_left < size)
	{
		fprintf(stderr, "ERROR: too many functions for suite->test_functions[]\n");
		suite->errors++;
	}
	else
	{
		memcpy(&suite->test_functions[suite->test_function_size],
			   functions, size * sizeof functions[0]);

		suite->test_function_size += size;
	}
}

/* ------------------------------------------------------ */

tequila_test_count tequila_gather_test_count(const tequila_test_suite * suite)
{
    tequila_test_count count = { 0 };
    
	if (!suite || suite->errors)
	{
		count.errors += suite->errors;
		return count;
	}

	for (size_t at = 0; at != suite->test_block_size; at++)
	{
		const tequila_test_block * test_block = &suite->test_blocks[at];

		if (test_block->mode == tequila_mode_ignore 
		 || test_block->function->mode == tequila_mode_ignore)
		{
			if (test_block->pass_count > 0 && test_block->fail_count == 0)
				count.ignored_passed++;
			else if (test_block->fail_count > 0)
				count.ignored_failed++;
			else
				count.ignored_unknown++;
		}
		else if (test_block->pass_count > 0 && test_block->fail_count == 0)
			count.passed++;
		else if (test_block->fail_count > 0)
			count.failed++;
		else
			count.unknown++;
	}

	return count;	   
}

/* ------------------------------------------------------ */

tequila_test_count tequila_run(tequila_test_suite * suite)
{
    tequila_test_count count = { 0 };

	if (!suite || suite->errors)
	{
		count.errors += suite->errors;
		return count;
	}

    tequila_set_test_suite(suite);

	suite->populate = true;		
	for (size_t at = 0; at != suite->test_function_size; at++)
	{
		suite->test_function_index = at;
		suite->test_functions[at].call();
	}

	if (suite->errors)
	{
		if (suite->test_block_size == tequila_max_blocks)
			fprintf(stderr, "ERROR: too many blocks for suite->test_blocks[]\n");
		//TODO: reset block_size?
		count.errors += suite->errors;
		return count;
	}		

	if (!tequila_valid_block_names(suite) 
     || !tequila_unique_block_names(suite))
	{
		//TODO: make sure suite->errors is set
		count.errors += suite->errors;
		return count;
	}
	else
	{
		suite->populate = false;
		for (size_t at = 0; at != suite->test_block_size; at++)
		{
			tequila_test_block * test_block = &suite->test_blocks[at];

		   	suite->test_block_index = at;
			test_block->pass_count = 0;
			test_block->fail_count = 0;			
			test_block->function->call();
		}
	}

	return tequila_gather_test_count(suite);
}

int tequila_outcome(const tequila_test_count * count)
{
	return count->passed > 0 && count->failed == 0 && count->errors == 0
		? EXIT_SUCCESS : EXIT_FAILURE;
}

void tequila_report(const tequila_test_count * count)
{
	if (count)
	{
		if (!count->errors)
		{
			const char * overall = (count->passed > 0 && count->failed == 0)
				? "PASSED" : "FAILED";

			fprintf(stdout, "TEQUILA %s: "
					"%zd passed, %zd failed, %zd unknown, ignored(%zd+%zd+%zd)\n",
				overall, 
				count->passed, count->failed, count->unknown, 
				count->ignored_passed, count->ignored_failed, count->ignored_unknown);
		}
		else
		{
			const char * plural = count->errors != 1 ? "s" : "";

			fprintf(stdout, "TEQUILA FAILED: %zd error%s\n",
				count->errors, plural);
		}
	}
}

/* 
 * helper function for single function array; TODO: DROP? 
 */

tequila_test_count tequila(size_t size, const tequila_test_function * slammers)
{
	tequila_test_suite suite;

	tequila_init(&suite);
	tequila_add(&suite, size, slammers);
    return tequila_run(&suite);
}


                

#include "unsplice.h"
#include "tequila.h"
#include <stdio.h>
#include <string.h>

#define SPLICE "\\\n"

void unsplice_tests(void)
{
    typedef const char * string;        
    TEST("that line with no splices is unchanged")
    {
        const char * expected = "abc";
        char actual[] = "abc";
        unsplice(actual);
        ARE_EQUAL(string, actual, expected);
    }
    TEST("a line starting with splice")
    {
        const char * expected = "abc";
        char actual[] = SPLICE "abc";
        unsplice(actual);
        ARE_EQUAL(string, actual, expected);
    }    
}

const tequila_test_function slammers[] =
{
    TEQUILA(unsplice_tests),
};

#define ARRAY_SIZE(array) (sizeof(array) / sizeof(array[0]))

int main()
{
    tequila_test_suite suite;
    tequila_test_count count;

    tequila_init(&suite);
    tequila_add(&suite, ARRAY_SIZE(slammers), slammers);
    count = tequila_run(&suite);
    tequila_report(&count);
    
    return tequila_outcome(&count);
}

//------------------------------------------------------------

bool tequila_equal_string(const char * lhs, const char * rhs)
{
    return (lhs == NULL && rhs == NULL) ||
           (lhs != NULL && rhs != NULL && strcmp(lhs, rhs) == 0);
}

#define STR(s) "[" #s "]"

//TODO: make this the only function the user needs to supply.
void tequila_print_string(FILE * out, const char * s)
{
    if (s == NULL)
        fprintf(out, "NULL");
    else if (strlen(s) == 0)
        fprintf(out, "\"\"");
    else
        for (size_t at = 0; at != strlen(s); at++)
        {
            char c = s[at];
            // TODO: refactor to table driven
            switch (c)
            {
                case '\\': fprintf(out, STR('\\')); break;
                case '\a': fprintf(out, STR('\a')); break;
                case '\b': fprintf(out, STR('\b')); break;
                case '\f': fprintf(out, STR('\f')); break;
                case '\n': fprintf(out, STR('\n')); break;
                case '\r': fprintf(out, STR('\r')); break;
                case '\t': fprintf(out, STR('\t')); break;
                case '\v': fprintf(out, STR('\v')); break;
                // TODO: check if isprint(c) if not print int value
                default  : fprintf(out, "['%c' ]", c); break;
            }       
        }
}

// TODO: push this inside the framework
void tequila_diff_print_string(
        const char * s_type,
        const char * expected, const char * actual,
        const char * e_str, const char * a_str)
{
    FILE * out = stderr;

    tequila_test_block * test_block = tequila_get_test_block();

    const char * tab = "    ";
    fprintf(out, "%s:%zd: %s() TEST(%s)\n", 
        test_block->filename, test_block->line_number, 
        test_block->function->name, test_block->name);

    fprintf(out, "%sARE_EQUAL(%s, %s, %s);\n",
        tab, s_type, e_str, a_str);

    fprintf(out, "%s%s\n", tab, e_str);
    fprintf(out, "%s%s== ", tab, tab);
    tequila_print_string(out, expected);
    fprintf(out, "\n");

    fprintf(out, "%s%s\n", tab, a_str);
    fprintf(out, "%s%s== ", tab, tab);
    tequila_print_string(out, actual);
    fprintf(out, "\n");
    fprintf(out, "\n");
}
       
        

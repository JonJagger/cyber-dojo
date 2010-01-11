#include "unsplice.h"

void unsplice(char line[])
{
    char * src = &line[0];
    char * dst = &line[0];
    while (*src != '\0')
    {
        *dst++ = *src++;
    }
    *dst = '\0';
}


#include "unsplice.h"

void unsplice(char line[])
{
    char * src = &line[0];
    char * dst = &line[0];
    while (*src != '\0')
    {
        if (*src == '\\' && *(src + 1) == '\n')
            src += 2;
        else
            *dst++ = *src++;
    }
    *dst = '\0';
}


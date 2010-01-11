#include "unsplice.h"

void unsplice(char * line)
{
    char * src = line;
    char * dst = line;
    while (*src != '\0')
    {
        if (*src == '\\' && *(src + 1) == '\n')
            src += 2;
        else
            *dst++ = *src++;
    }
    *dst = '\0';
}


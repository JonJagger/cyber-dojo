#include "unsplice.h"

void unsplice(char * dst)
{
    const char * src = dst;
    while (*src != '\0')
    {
        if (*src == '\\' && *(src + 1) == '\n')
            src += 2;
        else
            *dst++ = *src++;
    }
    *dst = '\0';
}


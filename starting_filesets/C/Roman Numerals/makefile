CC=gcc
CFLAGS=-std=c99 -Wall -Werror -O

test.specification : specification.tests
	./specification.tests

specification.tests : *.c 
	$(CC) $(CFLAGS) -o $@ $^



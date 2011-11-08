CC=gcc
CFLAGS=-std=c99 -Wall -Werror -O

run.tests.output : run.tests
	./run.tests

run.tests : *.c 
	$(CC) $(CFLAGS) -o $@ $^



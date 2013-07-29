run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.c *.h
	gcc -Wall -Werror -O -std=c99 *.c -o run.tests

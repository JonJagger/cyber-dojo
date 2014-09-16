run.tests.output : makefile run.tests
	./run.tests

run.tests : makefile *.c *.h
	gcc -Wall -Wextra -Werror -O -std=c99 *.c -o run.tests

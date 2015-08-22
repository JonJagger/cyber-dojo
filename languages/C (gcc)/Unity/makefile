
run.tests.output : makefile create.tests.main run.tests
	@./run.tests

create.tests.main :
	@ruby /unity/auto/generate_test_runner.rb hiker.tests.c tests.main.c

run.tests : makefile *.c *.h
	@gcc -Wall -Wextra -Werror -O -std=c99 -DTEST -DUNITY_SUPPORT_64 -DUNITY_INCLUDE_DOUBLE -I /unity/src/ *.c /unity/src/unity.c -o run.tests

CFLAGS += -I. -std=c99 -Wall -Wextra -Werror \
	-Wstrict-prototypes -Wmissing-prototypes \
	-Wshadow -Wfloat-equal -O

H_FILES = $(wildcard *.h)
COMPILED_H_FILES = $(patsubst %.h,%.compiled_h,$(H_FILES))
C_FILES = $(wildcard *.c)

run.test.output: run.test
	@./run.test

run.test: makefile $(C_FILES) $(COMPILED_H_FILES)
	@gcc $(CFLAGS) $(C_FILES) -o $@

# This rule ensures header files build in their own right.
# The quality of header files is important because header files
# are #included from other files and thus have a large span
# of influence (unlike .c files which are not #included).

%.compiled_h: %.h
	@gcc -x c $(CFLAGS) -c -o $@ $<

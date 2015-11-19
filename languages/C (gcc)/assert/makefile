CFLAGS += -I. -Wall -Wextra -Werror -std=c11
CFLAGS +=	-Wsequence-point
CFLAGS +=	-Wstrict-prototypes
CFLAGS +=	-Wmissing-prototypes
CFLAGS +=	-Wshadow -Wfloat-equal -O

H_FILES = $(wildcard *.h)
COMPILED_H_FILES = $(patsubst %.h,%.compiled_h,$(H_FILES))
C_FILES = $(wildcard *.c)


.PHONY: test.output
test.output: test makefile
	@./$<

test: makefile $(C_FILES) $(COMPILED_H_FILES)
	@gcc $(CFLAGS) $(C_FILES) -o $@

# This rule ensures header files build in their own right.
# The quality of header files is important because header files
# are #included from other files and thus have a large span
# of influence (unlike .c files which are not #included).

%.compiled_h: %.h
	@gcc -x c $(CFLAGS) -c -o $@ $<

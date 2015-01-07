CFLAGS += -I. -std=c99 -Wall -Wextra -Werror \
	-Wstrict-prototypes -Wmissing-prototypes \
	-Wshadow -Wfloat-equal -O

H_FILES = $(wildcard *.h)
COMPILED_H_FILES = $(patsubst %.h,%.compiled_h,$(H_FILES))
C_FILES = $(wildcard *.c)
ASM_FILES = $(wildcard *.asm)
COMPILED_ASM_FILES = $(patsubst %.asm,%.asm_o,$(ASM_FILES))

test: makefile $(COMPILED_H_FILES) $(C_FILES) $(COMPILED_ASM_FILES)
	@gcc $(C_FLAGS) $(C_FILES) $(COMPILED_ASM_FILES) -o $@
	@./$@

%.compiled_h: %.h
	@gcc -x c $(CFLAGS) -c -o $@ $<

%.asm_o: %.asm
	@nasm -f elf64 -o $@ $<

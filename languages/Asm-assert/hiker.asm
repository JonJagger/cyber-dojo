kernel:
  int 80h
  ret

section .data
    greeting db "Hello, World!", 0xa
    len       equ $ - greeting
    stdout    equ 1
    sys_exit  equ 1
    sys_write equ 4
    success   equ 0

global _start

section .text
_start:
    mov edx, len
    mov ecx, greeting
    mov ebx, stdout
    mov eax, sys_write
    call kernel

    mov ebx, success
    mov eax, sys_exit
    call kernel

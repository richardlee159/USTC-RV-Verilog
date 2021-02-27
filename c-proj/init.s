    .section .text.entry
    .globl _start
_start:
    la sp, _stack_top
    call main

    .section .stack
    .globl _stack
_stack:
    .space 4096 * 1
    .globl _stack_top
_stack_top:

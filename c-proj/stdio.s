    .section .text
    .global getchar
getchar:
    li t0, 0x10000000
1:  
    lbu t1, 4(t0)
    andi t1, t1, 2
    beq t1, zero, 1b
    lbu a0, 2(t0)
    ret

    .global putchar
putchar:
    li t0, 0x10000000
2:  
    lb t1, 4(t0)
    andi t1, t1, 1
    beq t1, zero, 2b
    sb a0, 0(t0)
    ret

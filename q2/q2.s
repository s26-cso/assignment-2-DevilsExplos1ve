.section .rodata
fmt_int: .asciz "%d "
fmt_nl:  .asciz "\n"

.text
.globl main
main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp) # n (count of numbers)
    sd s1, 40(sp) # argv pointer
    sd s2, 32(sp) # arr pointer (input values)
    sd s3, 24(sp) # result pointer (indices)
    sd s4, 16(sp) # stack pointer (manual stack)
    sd s5, 8(sp)  # top (stack size)

    addi s0, a0, -1      # n = argc - 1
    ble s0, zero, .L_exit # if no numbers, exit
    mv s1, a1            # save argv

    # Allocate memory for 3 arrays (arr, result, stack)
    slli a0, s0, 2       
    call malloc
    mv s2, a0            # s2 = arr
    slli a0, s0, 2
    call malloc
    mv s3, a0            # s3 = result
    slli a0, s0, 2
    call malloc
    mv s4, a0            # s4 = stack

    li s6, 0             # i = 0
.L_parse_loop:
    beq s6, s0, .L_solve_init
    addi t0, s6, 1       
    slli t0, t0, 3       
    add t0, s1, t0       
    ld a0, 0(t0)         # a0 = argv[i+1]
    call atoi
    slli t1, s6, 2
    add t1, s2, t1
    sw a0, 0(t1)         # arr[i] = atoi
    addi s6, s6, 1
    j .L_parse_loop

.L_solve_init:
    li s5, 0             # top = 0
    addi s6, s0, -1      # i = n - 1 (loop backwards)
.L_solve_loop:
    blt s6, zero, .L_print_init
    
.L_pop_loop:
    beqz s5, .L_set_result
    addi t0, s5, -1      # peek top index
    slli t0, t0, 2
    add t0, s4, t0
    lw t1, 0(t0)         # t1 = stack[top-1]
    
    slli t2, t1, 2
    add t2, s2, t2
    lw t2, 0(t2)         # t2 = arr[stack_top]
    
    slli t3, s6, 2
    add t3, s2, t3
    lw t3, 0(t3)         # t3 = arr[i]
    
    bgt t2, t3, .L_set_result # if arr[top] > arr[i], stop
    addi s5, s5, -1      # pop stack
    j .L_pop_loop

.L_set_result:
    slli t0, s6, 2
    add t0, s3, t0
    beqz s5, .L_no_greater
    addi t1, s5, -1
    slli t1, t1, 2
    add t1, s4, t1
    lw t2, 0(t1)         # t2 = stack.top() index
    sw t2, 0(t0)         # result[i] = index
    j .L_push_stack
.L_no_greater:
    li t1, -1
    sw t1, 0(t0)         # result[i] = -1

.L_push_stack:
    slli t0, s5, 2
    add t0, s4, t0
    sw s6, 0(t0)         # stack[top] = current index i
    addi s5, s5, 1       # top++
    addi s6, s6, -1      # i--
    j .L_solve_loop

.L_print_init:
    li s6, 0             # i = 0
.L_print_loop:
    beq s6, s0, .L_print_nl
    slli t0, s6, 2
    add t0, s3, t0
    lw a1, 0(t0)         # load result[i]
    la a0, fmt_int
    call printf
    addi s6, s6, 1
    j .L_print_loop

.L_print_nl:
    la a0, fmt_nl
    call printf

.L_exit:
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    addi sp, sp, 64
    li a0, 0
    ret
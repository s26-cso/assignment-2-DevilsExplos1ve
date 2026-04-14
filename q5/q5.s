.section .rodata
filename: .asciz "input.txt"
yes_msg:  .asciz "Yes\n"
no_msg:   .asciz "No\n"

.text
.globl main
main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp) # fd
    sd s1, 40(sp) # file size
    sd s2, 32(sp) # left index
    sd s3, 24(sp) # right index

    # open file
    la a0, filename
    li a1, 0           
    call open
    mv s0, a0          

    # get file size
    mv a0, s0
    li a1, 0
    li a2, 2           
    call lseek
    mv s1, a0          

    li s2, 0           
    addi s3, s1, -1    

.L_loop:
    bge s2, s3, .L_is_palindrome
    
    mv a0, s0
    mv a1, s2
    li a2, 0           
    call lseek
    mv a0, s0
    addi a1, sp, 8     
    li a2, 1
    call read
    lbu t0, 8(sp)      

    li t1, 97          
    blt t0, t1, .L_skip_left
    li t1, 122         
    bgt t0, t1, .L_skip_left
    
    mv a0, s0
    mv a1, s3
    li a2, 0           
    call lseek
    mv a0, s0
    addi a1, sp, 9     
    li a2, 1
    call read
    lbu t1, 9(sp)      

    li t2, 97          
    blt t1, t2, .L_skip_right
    li t2, 122         
    bgt t1, t2, .L_skip_right

    bne t0, t1, .L_not_palindrome
    
    addi s2, s2, 1     
    addi s3, s3, -1    
    j .L_loop

.L_skip_left:
    addi s2, s2, 1
    j .L_loop

.L_skip_right:
    addi s3, s3, -1
    j .L_loop

.L_is_palindrome:
    la a0, yes_msg
    call printf
    j .L_cleanup

.L_not_palindrome:
    la a0, no_msg
    call printf

.L_cleanup:
    mv a0, s0
    call close
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    addi sp, sp, 64
    ret
.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node: # creates a new node
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)
    mv s0, a0          
    li a0, 24          
    call malloc
    sw s0, 0(a0)       
    sd zero, 8(a0)     
    sd zero, 16(a0)    
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret

insert: # adds a value to the tree
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    mv s0, a0          
    mv s1, a1          
    bnez a0, .L_find_pos
    mv a0, s1
    call make_node
    j .L_insert_exit
.L_find_pos:
    lw t0, 0(s0)       
    blt s1, t0, .L_go_left
    ld a0, 16(s0)      
    mv a1, s1
    call insert
    sd a0, 16(s0)
    mv a0, s0
    j .L_insert_exit
.L_go_left:
    ld a0, 8(s0)       
    mv a1, s1
    call insert
    sd a0, 8(s0)
    mv a0, s0
.L_insert_exit:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret

get: # searches for a value
.L_get_loop:
    beqz a0, .L_get_notfound
    lw t0, 0(a0)
    beq a1, t0, .L_get_found
    blt a1, t0, .L_get_left
    ld a0, 16(a0)      
    j .L_get_loop
.L_get_left:
    ld a0, 8(a0)       
    j .L_get_loop
.L_get_found:
    ret                
.L_get_notfound:
    li a0, 0
    ret

getAtMost: # returns largest value <= val
    li t0, -1          
.L_atmost_loop:
    beqz a1, .L_atmost_exit
    lw t1, 0(a1)       
    bgt t1, a0, .L_atmost_go_left
    mv t0, t1          
    ld a1, 16(a1)      
    j .L_atmost_loop
.L_atmost_go_left:
    ld a1, 8(a1)       
    j .L_atmost_loop
.L_atmost_exit:
    mv a0, t0
    ret
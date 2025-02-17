# fir.S 
# assembly language of Finite Impulse Response (FIR)

// a0: base address of x
// a1: base address of c
// a2: base address of y, later used as pointer to y[j] in j loop
// a3: n
// a4: m

// t0: &y[n-m] to check termination of j loop
// t1: &c[m] to check termination of i loop
// t2: &x[j+m-1]

// t3: sum
// t4: pointer to c[i] in i loop
// t5: pointer to x[j-i+(m-1)] 
// t6: value of c[i]
// a5: value of x[j-i+(m-1)]

.global fir
.extern mul_q31
.extern add_q31

fir:
    # n-m+1
    add t0, a4, -1
    sub t0, a3, t0
    slli t0, t0, 2 # t0 = (n - m + 1) * 4 (byte offset)
    add t0, t0, a2 # t0 = &y[n-m+1]
    
    slli t1, a4, 2 # t1 = m * 4 (byte offset)
    add t1, t1, a1 # t1 = &c[m]

    addi t2, a4, -1
    slli t2, t2, 2
    add t2, t2, a0

    add a0, a2, zero

    j forj1

forj1:
    
    bge a2, t0, donej # Checking if we're at the last index
    add t3, zero, zero # sum = 0 
    add t4, a1, zero # Saving base address c to t4
    add t5, t2, zero # x[j-i+(m-1)]

    j fori
    
fori:
    bge t4, t1, forj2 # Checking if c[i] is at last index

    # y[j] = add_q31(y[j], mul_q31(c[i], x[j-i+(m-1)]));

    # mul_q31(c[i], x[j-i+(m-1)]) #####################################

    lw t6, 0(t4) # value of c[i]
    lw a5, 0(t5) # value of x[j-i+(m-1)]

    # mul a6, a5, t6
    # srli a6, a6, 31

    mv a6, a0
    mv a7, a1
    mv a0, t6
    mv a1, a5

    # Saving ra to stack 
    addi sp, sp, -4
    sw ra, 0(sp)
    # calling function
    jal mul_q31
    # Loading ra from stack
    lw ra, 0(sp)
    # Shifting ra left by 32 and right by 32 to fix sign extension bs
    sll ra, ra, 32
    srl ra, ra, 32
    # Getting rid of space used on stack
    addi sp, sp, 4

    # add_q31(y[j], a0) ###############################################

    # add t3, t3, a6

    mv a1, a0 
    mv a0, t3

    # Saving ra to stack
    addi sp, sp, -4
    sw ra, 0(sp)
    # calling function
    jal add_q31
    # Loading ra from stack
    lw ra, 0(sp)
    # Shifting ra left by 32 and right by 32 to fix sign extension bs
    sll ra, ra, 32
    srl ra, ra, 32
    # Getting rid of space used on stack
    addi sp, sp, 4

    mv t3, a0
    addi t4, t4, 4
    addi t5, t5, -4

    mv a0, a6
    mv a1, a7

    j fori

forj2:
    sw t3, 0(a2)
    addi a2, a2, 4
    addi t2, t2, 4

    j forj1

donej:
    ret                 # all done; return	
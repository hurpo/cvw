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
// a5: value of x[j-1+(m-1)]

.global fir
.extern mul_q31
.extern add_q31

# This is increasing the address to the next index in the array
# and setting the value to 42
# ##testing##################
#     li s0, 42
#     addi a2, a2, 4
#     sw s0, 0(a2)
# ############################


fir:
    # n-m+1
    sub t0, a3, a4 # t0 = n - m
    addi t0, t0, 1 # t0 = n - m + 1
    slli t0, t0, 2 # t0 = (n - m + 1) * 4 (byte offset)
    add t0, t0, a2 # t0 = &y[n-m+1]

    li t3, 0 # initialize accumlating sum j=0
    
    slli t1, a4, 2 # t1 = m * 4 (byte offset)
    add t1, t1, a1 # t1 = &c[m]

    add t2, a2, a4 # t2 = j + m
    addi t2, t2, -1 # t2 = j + m - 1
    slli t2, t2, 2 # t2 = (j + m -1) * 4 (byte offset)
    add t2, t2, a0 # t2 = &x[j+m-1]

    j forj1

forj1:
    
    bge a2, t0, donej # Checking if we're at the last index
    sw zero, 0(a2) # y[j]=0

    mv t4, a1 # t4=&c[0]
    li t5, 0 # i=0

    j fori
    
fori:
    
    bge a1, t1, forj2
    # y[j] = add_q31(y[j], mul_q31(c[i], x[j-i+(m-1)]));

    mv t3, a0 # Saving current value of a0 to t3
    mv t4, a1 # Saving current value of a1 to t4
    mv t6, ra # Saving return address (ra gets modified by jal)

    # t5: pointer to x[j-i+(m-1)] 
    sub t5, a2, a1  # t5 = j - i
    add t5, t5, a4  # t5 = j - i + (m-1)
    slli t5, t5, 2  # Convert to byte offset
    add t5, t5, a0  # t5 = &x[j-i+(m-1)]

    # Call mul_q31
    mv a0, t4   # Load c[i]
    lw a1, 0(t5)  # Load x[j-i+(m-1)]
    jal mul_q31  # Call mul_q31 (result in a0)

    # Save result of multiplication
    mv t5, a0  

    # Restore registers before calling add_q31
    mv a0, a2   # Load y[j]
    mv a1, t5   # Load mul_q31 result

    jal add_q31  # Call add_q31 (result in a0)

    # Store result in y[j]

    sll a0, a0, 32
    sw a0, 0(a2) 

    # Restore saved registers after function calls
    mv ra, t6   # Restore return address
    mv a0, t3   # Restore base address of x
    mv a1, t4   # Restore base address of c 

    ####################################################################
    #mv a1, t5
    #mv t5, ra # storing current address at ra to t5, mul_q31 changes ra

    #jal mul_q31 # mul_q31(c[i], x[j-i+(m-1)])

    #mv a1, a0 # Saving current value of a0 to a1
    #mv a0, a2 # Saving current value of t4 to a0

    #jal add_q31 # add_q31(y[j], mul_q31(c[i], x[j-i+(m-1)]));

    #mv ra, t5 # returning ra to original address held at t5, otherwise we get a forever loop

    #sw a0, 0(a2)

    #mv a1, t4
    #mv a0, t3

    #addi a1, a1, 4
    ######################################################################

    addi a1, a1, 4  # Move to next c[i]
    j fori

forj2:
    addi a2, a2, 4 #move to next y[j]
    addi t3, t3, 1 #increment j
    j forj1

donej:
    ret                 # all done; return
# fir.S 
# assembly language of Finite Impulse Response (FIR)

# a0: base address of x
# a1: base address of c
# a2: base address of y, later used as pointer to y[j] in j loop
# a3: n
# a4: m

# t0: &y[n-m] to check termination of j loop
# t1: &c[m] to check termination of i loop
# t2: &x[j+m-1]

# t3: sum
# t4: pointer to c[i] in i loop
# t5: pointer to x[j-i+(m-1)] 
# t6: value of c[i]
# a5: value of x[j-i+(m-1)]

.global fir
.extern mul_q31
.extern add_q31

fir:
    # Calculate n - m + 1
    add t0, a3, zero
    sub t0, t0, a4
    addi t0, t0, 1
    slli t0, t0, 2 # t0 = (n - m + 1) * 4 (byte offset)
    add t0, t0, a2 # t0 = &y[n-m+1]

    slli t1, a4, 2 # t1 = m * 4 (byte offset)
    add t1, t1, a1 # t1 = &c[m]

    j forj1

forj1:
    bge a2, t0, donej # Check if we're at the last index
    li t3, 0 # sum = 0 
    sw zero, 0(a2) # y[j] = 0

    add t2, a2, a4 # t2 = j + m
    addi t2, t2, -1 # t2 = j + m - 1
    slli t2, t2, 2 # t2 = (j + m -1) * 4 (byte offset)
    add t2, t2, a0 # t2 = &x[j+m-1]

    mv t4, a1 # Save base address c to t4
    j fori

fori:
    bge t4, t1, forj2 # Check if c[i] is at last index

    # Calculate x[j-i+(m-1)]
    sub t5, t2, t4
    slli t5, t5, 2
    add t5, t5, a0

    # Call mul_q31(c[i], x[j-i+(m-1)])
    lw a0, 0(t4)
    lw a1, 0(t5)
    jal mul_q31

    # Call add_q31(y[j], result of mul_q31)
    lw a1, 0(a2)
    jal add_q31

    # Store result back to y[j]
    sw a0, 0(a2)

    addi t4, t4, 4
    j fori

forj2:
    addi a2, a2, 4
    j forj1

donej:
    ret # all done; return

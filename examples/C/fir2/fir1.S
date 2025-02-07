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

fir:
    # s0 = i, s1 = j

    addi s0, zero, 0 # i = 0
    addi s1, zero, 0 # j = 0

    # # Idk if this is gonna work
    # sub s2, a3, a4 # s2 = n - m
    # add s2, s2, 1 # s2 = s2 + 1

forj1:
    bge s1, t0, donej
    addi a2, zero, 0 # y[j] = 0
    j fori
    
forj2:
    addi s1, s1, 1 # j++ 
    j forj1

fori:
    bge s0, t1, forj2
    # y[j] = add_q31(y[j], mul_q31(c[i], x[j-i+(m-1)]));
    addi a2, a2, 1
    addi s0, s0, 1 # i++
    j fori

donej:
    ret                 # all done; return	
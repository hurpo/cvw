.global fir

fir:
    # Prologue
    add t0, a3, zero         # t0 = n
    sub t0, t0, a4           # t0 = n - m
    addi t0, t0, 1           # t0 = n - m + 1 (loop limit)

    add t1, a1, a4           # t1 = &c[m] (end of c array)
    
forj1:
    bge s1, t0, donej        # if j >= (n - m + 1), exit loop
    addi s0, zero, 0         # i = 0
    add a2, a2, s1           # y[j] pointer update
    sw zero, 0(a2)           # y[j] = 0 (initialize sum)

fori:
    bge s0, a4, forj2        # if i >= m, go to next j iteration

    # Load c[i]
    add t4, a1, s0           # t4 = &c[i]
    lw t6, 0(t4)             # t6 = c[i]

    # Compute x[j - i + (m - 1)]
    sub t5, s1, s0           # t5 = j - i
    add t5, t5, a4           # t5 = j - i + m
    addi t5, t5, -1          # t5 = j - i + (m - 1)
    add t5, a0, t5           # t5 = &x[j - i + (m - 1)]
    lw a5, 0(t5)             # a5 = x[j - i + (m - 1)]

    # Multiply and accumulate: y[j] = add_q31(y[j], mul_q31(c[i], x[j-i+(m-1)]));
    call mul_q31             # Call mul_q31 (t6 = c[i], a5 = x[j-i+(m-1)])
    mv t3, a0                # Store result of mul_q31 in t3
    lw a5, 0(a2)             # Load current y[j]
    call add_q31             # Call add_q31 (a5 = y[j], t3 = mul result)
    sw a0, 0(a2)             # Store updated y[j]

    addi s0, s0, 1           # i++
    j fori                   # Continue i loop

forj2:
    addi s1, s1, 1           # j++
    j forj1                  # Restart j loop

donej:
    ret                      # Return

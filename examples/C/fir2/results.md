-O
riscv64-unknown-elf-gcc -o fir1 -gdwarf-2 -O\
  -march=rv64gc -mabi=lp64d -mcmodel=medany \
  -nostdlib -static -lm -fno-tree-loop-distribute-patterns \
  -T../common/test.ld -I../common \
  fir1.c fir1.S ../common/crt.S ../common/syscalls.c 
riscv64-unknown-elf-objdump -S -D fir1 > fir1.objdump
spike fir1
y[0] = 4fad3f2f
y[1] = 627c6236
y[2] = 4fad3f32
y[3] = 1e6f0e17
y[4] = e190f1eb
y[5] = b052c0ce
y[6] = 9d839dc6
y[7] = b052c0cb
y[8] = e190f1e6
y[9] = 1e6f0e12
y[10] = 4fad3f2f
y[11] = 627c6236
y[12] = 4fad3f32
y[13] = 1e6f0e17
y[14] = e190f1eb
y[15] = b052c0ce
y[16] = 9d839dc6
mcycle = 2580
minstret = 2587

| Optimization Level | Compiler Command                                                                                             | Test Name | y[0]       | y[1]       | y[2]       | y[3]       | y[4]       | y[5]       | y[6]       | y[7]       | y[8]       | y[9]       | y[10]      | y[11]      | y[12]      | y[13]      | y[14]      | y[15]      | y[16]      | mcycle | minstret |
|--------------------|------------------------------------------------------------------------------------------------------------|-----------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|--------|---------|
| -O               | `riscv64-unknown-elf-gcc -o fir1 -gdwarf-2 -O -march=rv64gc -mabi=lp64d -mcmodel=medany -nostdlib -static -lm -fno-tree-loop-distribute-patterns -T../common/test.ld -I../common fir1.c fir1.S ../common/crt.S ../common/syscalls.c riscv64-unknown-elf-objdump -S -D fir1 > fir1.objdump spike fir1` | Spike      | 4fad3f2f   | 627c6236   | 4fad3f32   | 1e6f0e17   | e190f1eb   | b052c0ce   | 9d839dc6   | b052c0cb   | e190f1e6   | 1e6f0e12   | 4fad3f2f   | 627c6236   | 4fad3f32   | 1e6f0e17   | e190f1eb   | b052c0ce   | 9d839dc6   | 2580   | 2587    |
| -O2              | `riscv64-unknown-elf-gcc -o fir1 -gdwarf-2 -O2 -march=rv64gc -mabi=lp64d -mcmodel=medany -nostdlib -static -lm -fno-tree-loop-distribute-patterns -T../common/test.ld -I../common fir1.c fir1.S ../common/crt.S ../common/syscalls.c riscv64-unknown-elf-objdump -S -D fir1 > fir1.objdump spike fir1` | Spike      | 4fad3f2f   | 627c6236   | 4fad3f32   | 1e6f0e17   | e190f1eb   | b052c0ce   | 9d839dc6   | b052c0cb   | e190f1e6   | 1e6f0e12   | 4fad3f2f   | 627c6236   | 4fad3f32   | 1e6f0e17   | e190f1eb   | b052c0ce   | 9d839dc6   | 2579   | 2584    |

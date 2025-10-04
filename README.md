# BorusCPU
**Experimental RISC CPU core prototype**

### Instruction Set

| Instruction | Code | Result |
|-------------|------|--------|
| LOAD A      | 0x0  | Load ROM data into register A |
| LOAD B      | 0x1  | Load ROM data into register B |
| ADD         | 0x2  | A = A + B |
| SUB         | 0x3  | A = A - B |
| AND         | 0x4  | A = A & B (bitwise AND) |
| OR          | 0x5  | A = A \| B (bitwise OR) |
| STORE       | 0x6  | Output register A to LEDs |
| JMP         | 0x7  | Unconditional jump to operand address |
| JZ          | 0x8  | Jump to operand address if A == 0 |
| HLT         | 0xF  | Halt processor execution |

## Example program in ROM
```sh
See: rom.v

                                              |OPER|DATA|
    mem[8'h00] = 8'h03; // LOAD A, 0x03       [0000 0011]
    mem[8'h01] = 8'h11; // LOAD B, 0x11       [0001 0001]
    mem[8'h02] = 8'h30; // SUB     0x30       [0011 0000]
    mem[8'h03] = 8'h60; // STORE   0x60       [0110 0000]
    mem[8'h04] = 8'hf0; // HLT     0xf0       [1111 0000]

    Program steps: 
    Load value 3 to register A
    Load value 1 to register B
    Subtract A - B and store the result in register A
    Store register A value to output
    Halt program execution

```
## Evironment
```
Software:
Quartus Prime 22.1std Build 915 10/25/2022 SC Lite Edition

Hardware:
DE0-Nano FPGA Development and Education Kit [https://www.terasic.com.tw/cgi-bin/page/archive.pl?No=593]
Cyclone® IV EP4CE22F17C6N FPGA

```
## License

**BSD 3-Clause License**
<br/>Copylefts 2025, Janusz Wolak
<br/>No rights reserved

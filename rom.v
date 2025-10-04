    /* 8-bit address, 8-bit data output */
module rom (
    /* input addr - address to read from */
    input [7:0] addr,
    /* output data - data read from memory */
    output reg [7:0] data
);

    /*
    * Simple ROM for predefined program
    * 256 bytes of memory
    * Each instruction is 1 byte (4 bits opcode + 4 bits operand)
    */
    reg [7:0] mem [0:255];

    /* Example (predefined) program to load into ROM
    * Program: 
    * LOAD A, 0x03
    * LOAD B, 0x11
    * SUB
    * STORE to output
    * HLT
    */
    initial begin             //                    |OPER|DATA|
          mem[8'h00] = 8'h03; // LOAD A, 0x03       [0000 0011]
          mem[8'h01] = 8'h11; // LOAD B, 0x11       [0001 0001]
          mem[8'h02] = 8'h30; // SUB     0x30       [0011 0000]
          mem[8'h03] = 8'h60; // STORE   0x60       [0110 0000]
          mem[8'h04] = 8'hf0; // HLT     0xf0       [1111 0000]
    end

    always @(*) begin
        /* Put data from memory to output
        * This is a combinational block that outputs the data from the ROM
        * based on the address input.
        * Example: If addr = 0x00, data = mem[0x00] = 0x03
        */
        data = mem[addr];
    end

endmodule

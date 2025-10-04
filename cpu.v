module BorusCpuCore (
    input clk,
    input rst,
    output reg [7:0] out_port,
    output reg halted
);

    reg [7:0] pc;         // Program Counter
    reg [7:0] a, b;       // registers A and B
    reg [7:0] ir;         // Instruction Register
    wire [7:0] instr;     // Current instruction
    wire [7:0] operand;   // Current operand

    wire [7:0] rom_data;   // ROM data output wire

    /* Create ROM instance
    *  Connect pc to addr input of ROM (current instruction address)
    *  Connect data output of ROM to rom_data wire (current instruction data)
    */
    rom progmem (
        .addr(pc),
        .data(rom_data)
    );

    /* Decode instruction and operand from instruction register 
    * Instruction is upper 4 bits, operand is lower 4 bits
    */
    assign instr = rom_data[7:4];
    assign operand = rom_data[3:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
        /* On reset, initialize PC, registers, and halted flag */
            pc <= 8'd0;
            a <= 0;
            b <= 0;
            halted <= 0;    // Clear halted flag on reset
        end else if (!halted) begin
            ir <= rom_data;

            case (instr)
                4'h0: a <= rom_data;                // LOAD A
                4'h1: b <= rom_data;                // LOAD B
                4'h2: a <= a + b;                   // ADD
                4'h3: a <= a - b;                   // SUB
                4'h4: a <= a & b;                   // AND
                4'h5: a <= a | b;                   // OR
                4'h6: out_port <= a;                // STORE to output
                4'h7: pc <= operand;                // JMP (unconditional jump)
                4'h8: if (a == 0) pc <= operand;    // JZ  (jump if zero)
                4'hF: halted <= 1;                  // HLT
                default: ;
            endcase

            /* Increment PC to point to next instruction
            * Except for JMP and JZ (if condition met), which set PC directly
            */
            if (!(instr == 4'h7 || (instr == 4'h8 && a == 0)))
                pc <= pc + 1;
        end
    end

endmodule

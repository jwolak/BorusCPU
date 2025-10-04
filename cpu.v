module BorusCpuCore (
    input clk,
    input rst,
    output reg [7:0] out_port,
    output reg halted
);

    reg [7:0] program_counter;          // Program Counter
    reg [7:0] reg_a, reg_b;             // registers A and B
    reg [7:0] instruction_register;     // Instruction Register
    wire [7:0] current_instruction;     // Current instruction
    wire [7:0] operand;                 // Current operand

    wire [7:0] rom_data;                // ROM data output wire

    /* Create ROM instance
    *  Connect program_counter to addr input of ROM (current instruction address)
    *  Connect data output of ROM to rom_data wire (current instruction data)
    */
    rom program_memory (
        .addr(program_counter),
        .data(rom_data)
    );

    /* Decode instruction and operand from instruction register 
    * Instruction is upper 4 bits, operand is lower 4 bits
    */
    assign current_instruction = rom_data[7:4];
    assign operand = rom_data[3:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
        /* On reset, initialize program counter, registers, and halted flag */
            program_counter <= 8'd0;
            reg_a <= 0;
            reg_b <= 0;
            halted <= 0;    // Clear halted flag on reset
        end else if (!halted) begin
            instruction_register <= rom_data;

            case (current_instruction)
                4'h0: reg_a <= rom_data;                            // LOAD A
                4'h1: reg_b <= rom_data;                            // LOAD B
                4'h2: reg_a <= reg_a + reg_b;                       // ADD
                4'h3: reg_a <= reg_a - reg_b;                       // SUB
                4'h4: reg_a <= reg_a & reg_b;                       // AND
                4'h5: reg_a <= reg_a | reg_b;                       // OR
                4'h6: out_port <= reg_a;                            // STORE to output
                4'h7: program_counter <= operand;                   // JMP (unconditional jump)
                4'h8: if (reg_a == 0) program_counter <= operand;   // JZ  (jump if zero)
                4'hF: halted <= 1;                                  // HLT
                default: ;
            endcase

            /* Increment program counter to point to next instruction
            * Except for JMP and JZ (if condition met), which set program counter directly
            */
            if (!(current_instruction == 4'h7 || (current_instruction == 4'h8 && reg_a == 0)))
                program_counter <= program_counter + 1;
        end
    end

endmodule

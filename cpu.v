module cpu (
    input clk,
    input rst,
    output reg [7:0] out_port,
    output reg halted
);

    reg [7:0] pc;         // Program Counter
    reg [7:0] a, b;       // Rejestry
    reg [7:0] ir;         // Instruction Register
    wire [7:0] instr;
    wire [7:0] operand;

    wire [7:0] rom_data;

    // ROM
    rom progmem (
        .addr(pc),
        .data(rom_data)
    );

    assign instr = rom_data[7:4];
    assign operand = rom_data[3:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 8'd0;
            a <= 0;
            b <= 0;
            halted <= 0;
        end else if (!halted) begin
            ir <= rom_data;

            case (instr)
                4'h0: a <= rom_data;                // LOAD A, imm
                4'h1: b <= rom_data;                // LOAD B, imm
                4'h2: a <= a + b;                   // ADD
                4'h3: a <= a - b;                   // SUB
                4'h4: a <= a & b;                   // AND
                4'h5: a <= a | b;                   // OR
                4'h6: out_port <= a;                // STORE to output
                4'h7: pc <= operand;                // JMP
                4'h8: if (a == 0) pc <= operand;    // JZ
                4'hF: halted <= 1;                  // HLT
                default: ;
            endcase

            if (!(instr == 4'h7 || (instr == 4'h8 && a == 0)))
                pc <= pc + 1;
        end
    end

endmodule

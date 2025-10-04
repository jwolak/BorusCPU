module rom (
    input [7:0] addr,
    output reg [7:0] data
);

    reg [7:0] mem [0:255];

    initial begin
        //$readmemh("program.mem", mem);
		  mem[8'h00] = 8'h03;
		  mem[8'h01] = 8'h11;
		  mem[8'h02] = 8'h30;
		  mem[8'h03] = 8'h60;
		  mem[8'h04] = 8'hf0;
    end

    always @(*) begin
        data = mem[addr];
    end

endmodule

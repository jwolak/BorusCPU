module borus_cpu (
    input clk_50,
    input rst_n,
    output [7:0] leds
);

    wire clk = clk_50;
    wire rst = ~rst_n;

    wire [7:0] out_data;
    wire halted;

    /* Connect CPU output port to out_data wire */
    BorusCpuCore cpu_inst (
        .clk(clk),
        .rst(rst),
        .out_port(out_data),
        .halted(halted)
    );

    /* Connect CPU output to LEDs */
    assign leds = out_data;

endmodule

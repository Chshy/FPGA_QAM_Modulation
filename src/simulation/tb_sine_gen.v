`timescale 1 ns / 1 ns
module tb_sine_gen ();
    
// 产生时钟和reset信号
reg clk;
reg rst_n;
initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    
    #1000
    rst_n = 1'b1;
end
// T = 90.422453703703703703703703703704 ns
always #45.211226851851851851851851851852 clk = ~clk; 

// 载波生成
wire [31:0] carrier_i;
wire [31:0] carrier_q;
carrier_gen carrier_gen(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .freq(16'd65_000),
    .carrier_i(carrier_i),
    .carrier_q(carrier_q)
);

endmodule
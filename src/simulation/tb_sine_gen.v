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

reg [15:0] freq;
initial freq <= 16'd10_000;
always begin
    // # 100000
    # 200000
    if(freq >= 16'd65_000) begin
        freq <= 16'd10_000;
    end else begin
        freq <= freq + 16'd5000;
    end
end

// 产生时钟信号
wire clk_bitstream;     // 比特速率
wire clk_symbol;        // 符号速率
wire clk_filter_sample; // 滤波器(采样)频率
wire clk_analog_sample; // 载波(采样)频率
clk_gen clk_generate(
    .clk_in(clk),
    .rst_n(rst_n),
    .mod_type(1'b0),
    .baud_rate(2'b00),
    .clk_bitstream(clk_bitstream),
    .clk_symbol(clk_symbol),
    .clk_filter_sample(clk_filter_sample),
    .clk_analog_sample(clk_analog_sample)
);

// 载波生成
wire [31:0] carrier_i;
wire [31:0] carrier_q;
carrier_gen carrier_gen(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .freq(freq),
    .carrier_i(carrier_i),
    .carrier_q(carrier_q)
);

endmodule
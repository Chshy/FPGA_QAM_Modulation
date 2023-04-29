`timescale 1 ns / 1 ns
module tb_m_seq ();
    
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

// 产生时钟信号
wire clk_bitstream;     // 比特速率
wire clk_symbol;        // 符号速率
wire clk_filter_sample; // 滤波器(采样)频率
wire clk_analog_sample; // 载波(采样)频率
clk_gen clk_generate(
    .clk_in(clk),
    .rst_n(rst_n),
    .mod_type(1'b1),
    .baud_rate(2'b00),
    .clk_bitstream(clk_bitstream),
    .clk_symbol(clk_symbol),
    .clk_filter_sample(clk_filter_sample),
    .clk_analog_sample(clk_analog_sample)
);

// 产生比特流
wire m_seq_out;
defparam m_seq_gen_inst.REG_LEN = 13;
m_seq_gen m_seq_gen_inst(
    .clk(clk_bitstream),
    .rst_n(rst_n),
    .m_seq_out(m_seq_out)
);

// 串并转换
wire [3:0] parellel_output;
serial_to_parellel serial_to_parellel_inst(
    .clk(clk_bitstream),
    .rst_n(rst_n),
    .mod_type(1'b1),
    .serial_input(m_seq_out),
    .parellel_output(parellel_output)
);

endmodule
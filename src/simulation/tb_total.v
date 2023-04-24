module tb_total ();

// 产生时钟和reset信号
reg clk;
reg rst_n;
initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    
    #1000
    rst_n = 1'b1;
end
// T = 90.421963133157191349149943124585 ns
always #45.210981566578595674574971562293 clk = ~clk; 

// 总配置信号
wire mod_type;
wire [1:0] baud_rate;
wire filter_enable;
wire [15:0] carrier_freq_set;
assign mod_type = 1'b1;
assign baud_rate = 2'b00; // 00 = 1200  01 = 2400  10 = 4800  11 = 9600
assign filter_enable = 1'b1;
assign carrier_freq_set = 16'd50_000;






// 产生时钟信号
wire clk_bitstream;     // 比特速率
wire clk_symbol;        // 符号速率
wire clk_filter_sample; // 滤波器(采样)频率
wire clk_analog_sample; // 载波(采样)频率

clk_gen clk_generate(
    .clk_in(clk),
    .rst_n(rst_n),
    .mod_type(mod_type),
    .baud_rate(baud_rate),
    .clk_bitstream(clk_bitstream),
    .clk_symbol(clk_symbol),
    .clk_filter_sample(clk_filter_sample),
    .clk_analog_sample(clk_analog_sample)
);

// 产生比特流
wire m_seq_out;
m_seq_gen bit_src(
    .clk(clk_bitstream),
    .rst_n(rst_n),
    .m_seq_out(m_seq_out)
);

// 串并转换
wire [3:0] parellel_output;
serial_to_parellel s2p_conv(
    .clk(clk_bitstream),
    .rst_n(rst_n),
    .mod_type(mod_type),
    .serial_input(m_seq_out),
    .parellel_output(parellel_output)
);

// 并行结果下采样
wire [3:0] parellel_output_downsamp;
defparam parellel_downsamp_u.WIDTH = 4;
defparam parellel_downsamp_u.SAMPLE_TYPE = 0;
samples parellel_downsamp_u(
    .clk(clk_symbol),
    .rst_n(rst_n),
    .data_in(parellel_output),
    .data_out(parellel_output_downsamp)
);

// 符号映射
wire [31:0] symb_i;
wire [31:0] symb_q;
constellation_map constellation_map_inst(
    .clk(clk_symbol),
    .rst_n(rst_n),
    .parellel_input(parellel_output_downsamp),
    .symbol_I(symb_i),
    .symbol_Q(symb_q)
);

// IQ符号上采样
wire [31:0] symb_i_upsamp;
defparam symb_i_upsamp_u.WIDTH = 32;
defparam symb_i_upsamp_u.SAMPLE_TYPE = 1;
samples symb_i_upsamp_u(
    .clk(clk_filter_sample),
    .rst_n(rst_n),
    .data_in(symb_i),
    .data_out(symb_i_upsamp)
);
wire [31:0] symb_q_upsamp;
defparam symb_q_upsamp_u.WIDTH = 32;
defparam symb_q_upsamp_u.SAMPLE_TYPE = 1;
samples symb_q_upsamp_u(
    .clk(clk_filter_sample),
    .rst_n(rst_n),
    .data_in(symb_q),
    .data_out(symb_q_upsamp)
);

// 成型滤波器
wire [67:0] filter_out_i;
wire [67:0] filter_out_q;
filter_top filter(
    .clk(clk_filter_sample),
    .rst_n(rst_n),
    .enable(filter_enable),
    .baud_rate(baud_rate),
    .filter_in_i(symb_i_upsamp),
    .filter_in_q(symb_q_upsamp),
    .filter_out_i(filter_out_i),
    .filter_out_q(filter_out_q)
);

// 滤波器结果上采样
wire [67:0] filter_out_i_upsamp;
defparam filter_out_i_upsamp_u.WIDTH = 68;
defparam filter_out_i_upsamp_u.SAMPLE_TYPE = 0;
samples filter_out_i_upsamp_u(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .data_in(filter_out_i),
    .data_out(filter_out_i_upsamp)
);

wire [67:0] filter_out_q_upsamp;
defparam filter_out_q_upsamp_u.WIDTH = 68;
defparam filter_out_q_upsamp_u.SAMPLE_TYPE = 0;
samples filter_out_q_upsamp_u(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .data_in(filter_out_q),
    .data_out(filter_out_q_upsamp)
);

// 载波生成
wire [31:0] carrier_i;
wire [31:0] carrier_q;
carrier_gen carrier_gen(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .freq(carrier_freq_set),
    .carrier_i(carrier_i),
    .carrier_q(carrier_q)
);

// IQ调制
wire [76:0] mod_iq;
IQ_mod IQ_mod(
    .carrier_i(carrier_i),
    .carrier_q(carrier_q),
    .baseband_i(filter_out_i_upsamp),
    .baseband_q(filter_out_q_upsamp),
    .mod_iq(mod_iq)
);

endmodule

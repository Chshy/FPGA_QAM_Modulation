module top (
    // 时钟和Reset
    input        clk,                // 主时钟 11059200 Hz
    input        rst_n,              // Reset
    // 参数配置端口
    input        mod_type,           // 调制方式   QPSK(0) / 16QAM(1)
    input [ 1:0] baud_rate,          // 符号波特率 2400(00) / 4800(01) / 9600(10) / 19200(11)
    input        filter_enable,      // 使能成型滤波器
    input        use_sqrt_rcos,      // 滤波器使用根升余弦
    input [15:0] carrier_freq_set,   // 设置载波频率 (0-65535 Hz)
    // 调制结果输出
    output [31:0] mod_iq    
);

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
    .clk_bitstream(clk_bitstream),         // 比特流速率
    .clk_symbol(clk_symbol),               // 波特速率
    .clk_filter_sample(clk_filter_sample), // 滤波器采样速率
    .clk_analog_sample(clk_analog_sample)  // 载波采样速率
);

// 产生比特流
wire m_seq_out;
wire random_data_gen; // 比特流产生请求(Pilot发送完毕后置1)
defparam m_seq_gen_inst.REG_LEN = 13;
m_seq_gen m_seq_gen_inst(
    .clk(clk_bitstream),
    .rst_n(rst_n & random_data_gen),
    .m_seq_out(m_seq_out)
);

// 串并转换
wire [3:0] parellel_output;
serial_to_parellel serial_to_parellel_inst(
    .clk(clk_bitstream),
    .rst_n(rst_n),
    .mod_type(mod_type),
    .serial_input(m_seq_out),         // 串行输入
    .parellel_output(parellel_output) // 并行输出
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

// 导频插入
wire [3:0] data_parellel;
pilot_insert pilot_insert_inst(
    .clk_symbol(clk_symbol),
    .rst_n(rst_n),
    .mod_type(mod_type),
    .data_in(parellel_output_downsamp),
    .random_data_gen(random_data_gen),
    .data_out(data_parellel)
);

// 符号映射
wire [31:0] symb_i;
wire [31:0] symb_q;
constellation_map constellation_map_inst(
    .clk(clk_symbol),
    .rst_n(rst_n),
    .mod_type(mod_type),
    .parellel_input(data_parellel), // 并行输入
    .symbol_I(symb_i),              // I路符号
    .symbol_Q(symb_q)               // Q路符号
);

// IQ符号上采样
wire [31:0] symb_i_upsamp;
wire [31:0] symb_q_upsamp;
filter_in_upsamp filter_in_upsamp_inst(
    .clk_filter_sample(clk_filter_sample),
    .clk_symbol(clk_symbol),
    .rst_n(rst_n),
    .baud_rate(baud_rate),
    .symb_i(symb_i),
    .symb_q(symb_q),
    .symb_i_upsamp(symb_i_upsamp),
    .symb_q_upsamp(symb_q_upsamp)
);

// 成型滤波器
wire [64:0] filter_out_i;
wire [64:0] filter_out_q;
filter_top filter_top_inst(
    .clk(clk_filter_sample),
    .rst_n(rst_n),
    .enable(filter_enable),
    .baud_rate(baud_rate),
    .use_sqrt_rcos(use_sqrt_rcos),
    .filter_in_i(symb_i_upsamp),
    .filter_in_q(symb_q_upsamp),
    .filter_out_i(filter_out_i),
    .filter_out_q(filter_out_q)
);

// 滤波器结果上采样(CIC插值)
wire [34:0] CIC_i_out;
wire [34:0] CIC_q_out;
CIC_upsamp CIC_upsamp_inst (
    .clk(clk),
    .rst_n(rst_n),
    .baud_rate(baud_rate),
    .filter_out_i(filter_out_i),
    .filter_out_q(filter_out_q),
    .CIC_i_out(CIC_i_out),
    .CIC_q_out(CIC_q_out)
);

// CIC输出结果上采样
wire [34:0] CIC_i_out_upsamp;
defparam CIC_i_out_upsamp_u.WIDTH = 35;
defparam CIC_i_out_upsamp_u.SAMPLE_TYPE = 0;
samples CIC_i_out_upsamp_u(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .data_in(CIC_i_out),
    .data_out(CIC_i_out_upsamp)
);
wire [34:0] CIC_q_out_upsamp;
defparam CIC_q_out_upsamp_u.WIDTH = 35;
defparam CIC_q_out_upsamp_u.SAMPLE_TYPE = 0;
samples CIC_q_out_upsamp_u(
    .clk(clk_analog_sample),
    .rst_n(rst_n),
    .data_in(CIC_q_out),
    .data_out(CIC_q_out_upsamp)
);

// 载波生成
wire [31:0] carrier_i;
wire [31:0] carrier_q;
carrier_gen carrier_gen_inst(
    .clk(clk_analog_sample),
    .clk_calc(clk),
    .rst_n(rst_n),
    .freq(carrier_freq_set),
    .carrier_i(carrier_i), // I路载波
    .carrier_q(carrier_q)  // Q路载波
);

// IQ调制
wire [68:0] mod_iq_raw;
IQ_mod IQ_mod_inst(
    .carrier_i(carrier_i),
    .carrier_q(carrier_q),
    .baseband_i(CIC_i_out_upsamp),
    .baseband_q(CIC_q_out_upsamp),
    .mod_iq(mod_iq_raw)
);
assign mod_iq = {mod_iq_raw[68], mod_iq_raw[65:35]};

endmodule

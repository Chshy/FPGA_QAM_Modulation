module tb_top ();


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

// 产生配置信号
wire mod_type;
wire [1:0] baud_rate;
wire filter_enable;
wire [15:0] carrier_freq_set;
assign mod_type = 1'b1; // 0 = QPSK , 1 = 16QAM
assign baud_rate = 2'b00; // 00 = 1200  01 = 2400  10 = 4800  11 = 9600
assign filter_enable = 1'b1;
assign carrier_freq_set = 16'd65_000;

// 输出 
wire [31:0] mod_iq;

top top_inst(
    // 时钟和Reset
    .clk(clk),                // 主时钟 11059200 Hz
    .rst_n(rst_n),              // Reset
    // 参数配置端口
    .mod_type(mod_type),           // 调制方式   QPSK(0) / 16QAM(1)
    .baud_rate(baud_rate),          // 符号波特率 2400(00) / 4800(01) / 9600(10) / 19200(11)
    .filter_enable(filter_enable),      // 使能成型滤波器
    .carrier_freq_set(carrier_freq_set),   // 设置载波频率 (0-65535 Hz, Step = 338 Hz)
    // 调制结果输出
    .mod_iq(mod_iq)
);

endmodule
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
// T = 90.421963133157191349149943124585 ns
always #45.210981566578595674574971562293 clk = ~clk; 

// 产生配置信号
wire mod_type;
wire [1:0] baud_rate;
wire filter_enable;
wire [15:0] carrier_freq_set;
assign mod_type = 1'b1;
assign baud_rate = 2'b00; // 00 = 1200  01 = 2400  10 = 4800  11 = 9600
assign filter_enable = 1'b1;
assign carrier_freq_set = 16'd50_000;





endmodule
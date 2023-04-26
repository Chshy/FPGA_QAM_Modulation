module filter_top #(
    // parameters
) (
    input         clk, // 76800 Designed
    input         rst_n,
    input         enable, // high effect
    input  [ 1:0] baud_rate, // 符号波特率 2400(00) 4800(01) 9600(10) 19200(11)

    input  [31:0] filter_in_i,
    input  [31:0] filter_in_q,
    output [65:0] filter_out_i,
    output [65:0] filter_out_q
);



// 产生各滤波器对应的Fs
wire clk_76800;
wire clk_38400;
wire clk_19200;
wire clk_9600;
assign clk_76800 = clk;
reg [2:0] clk_filter_down_cnt;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        clk_filter_down_cnt <= 3'b0;
    end else begin
        clk_filter_down_cnt <= clk_filter_down_cnt + 1'b1;
    end
end
assign clk_38400 = clk_filter_down_cnt[0];
assign clk_19200 = clk_filter_down_cnt[1];
assign clk_9600 = clk_filter_down_cnt[2];






// [31:0] / [65:0]

/*
符号速率 Baud    奈奎斯特带宽 Hz   根升余弦滤波器Fn Hz
  2400            1200                
  4800            2400
  9600            4800
 19200            9600
*/

// 滤波器使能信号
wire filter_en_1200;
wire filter_en_2400;
wire filter_en_4800;
wire filter_en_9600;
assign filter_en_1200 = (baud_rate == 2'b00) ? 1'b1 : 1'b0;
assign filter_en_2400 = (baud_rate == 2'b01) ? 1'b1 : 1'b0;
assign filter_en_4800 = (baud_rate == 2'b10) ? 1'b1 : 1'b0;
assign filter_en_9600 = (baud_rate == 2'b11) ? 1'b1 : 1'b0;

// 滤波器输入/输出
wire [31:0]  fin_1200_i;
wire [65:0] fout_1200_i;
wire [31:0]  fin_1200_q;
wire [65:0] fout_1200_q;
wire [31:0]  fin_2400_i;
wire [65:0] fout_2400_i;
wire [31:0]  fin_2400_q;
wire [65:0] fout_2400_q;
wire [31:0]  fin_4800_i;
wire [65:0] fout_4800_i;
wire [31:0]  fin_4800_q;
wire [65:0] fout_4800_q;
wire [31:0]  fin_9600_i;
wire [65:0] fout_9600_i;
wire [31:0]  fin_9600_q;
wire [65:0] fout_9600_q;

assign fin_1200_i = filter_in_i;
assign fin_2400_i = filter_in_i;
assign fin_4800_i = filter_in_i;
assign fin_9600_i = filter_in_i;
assign fin_1200_q = filter_in_q;
assign fin_2400_q = filter_in_q;
assign fin_4800_q = filter_in_q;
assign fin_9600_q = filter_in_q;

wire [65:0] f_mux_i;
wire [65:0] f_mux_q;

assign f_mux_i = 
    baud_rate == 2'b00 ? {fout_1200_i[66:0], 1'b0} :
    baud_rate == 2'b01 ? {fout_2400_i[66:0], 1'b0} :
    baud_rate == 2'b10 ? fout_4800_i :
    baud_rate == 2'b11 ? fout_9600_i : 68'b0;

assign f_mux_q = 
    baud_rate == 2'b00 ? {fout_1200_q[66:0], 1'b0} :
    baud_rate == 2'b01 ? {fout_2400_q[66:0], 1'b0} :
    baud_rate == 2'b10 ? fout_4800_q :
    baud_rate == 2'b11 ? fout_9600_q : 68'b0;

// 不启用滤波器时进行插值
reg [31:0] i_hold;
reg [31:0] q_hold;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_hold <= 32'b0;
        q_hold <= 32'b0;
    end else begin
        if(filter_in_i != 32'b0) begin
            i_hold <= filter_in_i;
        end
        if(filter_in_q != 32'b0) begin
            q_hold <= filter_in_q;
        end
    end
end

assign filter_out_i = enable ? f_mux_i : {{(3){q_hold[31]}}, i_hold[30:0], 32'b0};
assign filter_out_q = enable ? f_mux_q : {{(3){q_hold[31]}}, q_hold[30:0], 32'b0};


// 1200
FIR_RCos_1200Hz f1200_i
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200),
    .reset(~rst_n),
    .filter_in(fin_1200_i),
    .filter_out(fout_1200_i)
);
FIR_RCos_1200Hz f1200_q
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200),
    .reset(~rst_n),
    .filter_in(fin_1200_q),
    .filter_out(fout_1200_q)
);

// 2400
FIR_RCos_2400Hz f2400_i
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400),
    .reset(~rst_n),
    .filter_in(fin_2400_i),
    .filter_out(fout_2400_i)
);
FIR_RCos_2400Hz f2400_q
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400),
    .reset(~rst_n),
    .filter_in(fin_2400_q),
    .filter_out(fout_2400_q)
);

// 4800
FIR_RCos_4800Hz f4800_i
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800),
    .reset(~rst_n),
    .filter_in(fin_4800_i),
    .filter_out(fout_4800_i)
);
FIR_RCos_4800Hz f4800_q
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800),
    .reset(~rst_n),
    .filter_in(fin_4800_q),
    .filter_out(fout_4800_q)
);

// 9600
FIR_RCos_9600Hz f9600_i
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600),
    .reset(~rst_n),
    .filter_in(fin_9600_i),
    .filter_out(fout_9600_i)
);
FIR_RCos_9600Hz f9600_q
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600),
    .reset(~rst_n),
    .filter_in(fin_9600_q),
    .filter_out(fout_9600_q)
);

    
endmodule
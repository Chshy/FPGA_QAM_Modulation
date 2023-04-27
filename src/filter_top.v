module filter_top (
    input         clk, // 76800 Designed
    input         rst_n,
    input         enable, // high effect
    input  [ 1:0] baud_rate, // 符号波特率 2400(00) 4800(01) 9600(10) 19200(11)
    input         use_sqrt_rcos, // 0=不开根号,1=开根号
    input  [31:0] filter_in_i,
    input  [31:0] filter_in_q,
    output [64:0] filter_out_i,
    output [64:0] filter_out_q
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






// [31:0] / [64:0]

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
wire [64:0] fout_1200_i;
wire [31:0]  fin_1200_q;
wire [64:0] fout_1200_q;
wire [31:0]  fin_2400_i;
wire [64:0] fout_2400_i;
wire [31:0]  fin_2400_q;
wire [64:0] fout_2400_q;
wire [31:0]  fin_4800_i;
wire [64:0] fout_4800_i;
wire [31:0]  fin_4800_q;
wire [64:0] fout_4800_q;
wire [31:0]  fin_9600_i;
wire [64:0] fout_9600_i;
wire [31:0]  fin_9600_q;
wire [64:0] fout_9600_q;

assign fin_1200_i = filter_in_i;
assign fin_2400_i = filter_in_i;
assign fin_4800_i = filter_in_i;
assign fin_9600_i = filter_in_i;
assign fin_1200_q = filter_in_q;
assign fin_2400_q = filter_in_q;
assign fin_4800_q = filter_in_q;
assign fin_9600_q = filter_in_q;

wire [64:0] f_mux_i;
wire [64:0] f_mux_q;

assign f_mux_i = 
    baud_rate == 2'b00 ? fout_1200_i :
    baud_rate == 2'b01 ? fout_2400_i :
    baud_rate == 2'b10 ? fout_4800_i :
    baud_rate == 2'b11 ? fout_9600_i : 68'b0;

assign f_mux_q = 
    baud_rate == 2'b00 ? fout_1200_q :
    baud_rate == 2'b01 ? fout_2400_q :
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

assign filter_out_i = enable ? f_mux_i : {{(2){i_hold[31]}}, i_hold[30:0], 32'b0};
assign filter_out_q = enable ? f_mux_q : {{(2){q_hold[31]}}, q_hold[30:0], 32'b0};


// 是使用升余弦还是根升余弦的mux
wire [64:0] fout_1200_i_sqrt;
wire [64:0] fout_1200_i_no_sqrt;
wire [64:0] fout_1200_q_sqrt;
wire [64:0] fout_1200_q_no_sqrt;
wire [64:0] fout_2400_i_sqrt;
wire [64:0] fout_2400_i_no_sqrt;
wire [64:0] fout_2400_q_sqrt;
wire [64:0] fout_2400_q_no_sqrt;
wire [64:0] fout_4800_i_sqrt;
wire [64:0] fout_4800_i_no_sqrt;
wire [64:0] fout_4800_q_sqrt;
wire [64:0] fout_4800_q_no_sqrt;
wire [64:0] fout_9600_i_sqrt;
wire [64:0] fout_9600_i_no_sqrt;
wire [64:0] fout_9600_q_sqrt;
wire [64:0] fout_9600_q_no_sqrt;
assign fout_1200_i = (use_sqrt_rcos == 1'b0) ? fout_1200_i_no_sqrt : fout_1200_i_sqrt;
assign fout_1200_q = (use_sqrt_rcos == 1'b0) ? fout_1200_q_no_sqrt : fout_1200_q_sqrt;
assign fout_2400_i = (use_sqrt_rcos == 1'b0) ? fout_2400_i_no_sqrt : fout_2400_i_sqrt;
assign fout_2400_q = (use_sqrt_rcos == 1'b0) ? fout_2400_q_no_sqrt : fout_2400_q_sqrt;
assign fout_4800_i = (use_sqrt_rcos == 1'b0) ? fout_4800_i_no_sqrt : fout_4800_i_sqrt;
assign fout_4800_q = (use_sqrt_rcos == 1'b0) ? fout_4800_q_no_sqrt : fout_4800_q_sqrt;
assign fout_9600_i = (use_sqrt_rcos == 1'b0) ? fout_9600_i_no_sqrt : fout_9600_i_sqrt;
assign fout_9600_q = (use_sqrt_rcos == 1'b0) ? fout_9600_q_no_sqrt : fout_9600_q_sqrt;


// 1200
FIR_RCos_1200Hz f1200_i_no_sqrt
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_1200_i),
    .filter_out(fout_1200_i_no_sqrt)
);
FIR_RCos_1200Hz f1200_q_no_sqrt
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_1200_q),
    .filter_out(fout_1200_q_no_sqrt)
);
FIR_sqrtRCos_1200Hz f1200_i_sqrt
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_1200_i),
    .filter_out(fout_1200_i_sqrt)
);
FIR_sqrtRCos_1200Hz f1200_q_sqrt
(
    .clk(clk_9600),
    .clk_enable(filter_en_1200 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_1200_q),
    .filter_out(fout_1200_q_sqrt)
);

// 2400
FIR_RCos_2400Hz f2400_i_no_sqrt
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_2400_i),
    .filter_out(fout_2400_i_no_sqrt)
);
FIR_RCos_2400Hz f2400_q_no_sqrt
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_2400_q),
    .filter_out(fout_2400_q_no_sqrt)
);
FIR_sqrtRCos_2400Hz f2400_i_sqrt
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_2400_i),
    .filter_out(fout_2400_i_sqrt)
);
FIR_sqrtRCos_2400Hz f2400_q_sqrt
(
    .clk(clk_19200),
    .clk_enable(filter_en_2400 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_2400_q),
    .filter_out(fout_2400_q_sqrt)
);

// 4800
FIR_RCos_4800Hz f4800_i_no_sqrt
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_4800_i),
    .filter_out(fout_4800_i_no_sqrt)
);
FIR_RCos_4800Hz f4800_q_no_sqrt
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_4800_q),
    .filter_out(fout_4800_q_no_sqrt)
);
FIR_sqrtRCos_4800Hz f4800_i_sqrt
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_4800_i),
    .filter_out(fout_4800_i_sqrt)
);
FIR_sqrtRCos_4800Hz f4800_q_sqrt
(
    .clk(clk_38400),
    .clk_enable(filter_en_4800 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_4800_q),
    .filter_out(fout_4800_q_sqrt)
);


// 9600
FIR_RCos_9600Hz f9600_i_no_sqrt
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_9600_i),
    .filter_out(fout_9600_i_no_sqrt)
);
FIR_RCos_9600Hz f9600_q_no_sqrt
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600 & ~use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_9600_q),
    .filter_out(fout_9600_q_no_sqrt)
);
FIR_sqrtRCos_9600Hz f9600_i_sqrt
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_9600_i),
    .filter_out(fout_9600_i_sqrt)
);
FIR_sqrtRCos_9600Hz f9600_q_sqrt
(
    .clk(clk_76800),
    .clk_enable(filter_en_9600 & use_sqrt_rcos),
    .reset(~rst_n),
    .filter_in(fin_9600_q),
    .filter_out(fout_9600_q_sqrt)
);

    
endmodule
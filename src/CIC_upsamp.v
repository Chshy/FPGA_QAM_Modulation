module CIC_upsamp (
    input         clk,
    input         rst_n,
    input  [ 1:0] baud_rate,
    input  [64:0] filter_out_i,
    input  [64:0] filter_out_q,
    output [34:0] CIC_i_out,
    output [34:0] CIC_q_out
);
    
// 产生clk_CIC_sample 
wire clk_CIC_sample;
wire [12:0] div_CIC_sample;
assign div_CIC_sample = 13'd18; // 144 / 8
clk_div clk_filter_sample_gen(
    .clk_in(clk),
    .rst_n(rst_n),
    .div_factor(div_CIC_sample),
    .clk_out(clk_CIC_sample)
);

// 再分出4种频率
wire clk_76800x8;
wire clk_38400x8;
wire clk_19200x8;
wire clk_9600x8;
assign clk_76800x8 = clk_CIC_sample;
reg [2:0] clk_CIC_down_cnt;
always @(posedge clk_76800x8 or negedge rst_n) begin
    if(~rst_n) begin
        clk_CIC_down_cnt <= 3'b0;
    end else begin
        clk_CIC_down_cnt <= clk_CIC_down_cnt + 1'b1;
    end
end
assign clk_38400x8 = clk_CIC_down_cnt[0];
assign clk_19200x8 = clk_CIC_down_cnt[1];
assign clk_9600x8 = clk_CIC_down_cnt[2];

// 选择CIC驱动频率
wire clk_CIC;
assign clk_CIC = 
    baud_rate == 2'b00 ? clk_9600x8  :
    baud_rate == 2'b01 ? clk_19200x8 :
    baud_rate == 2'b10 ? clk_38400x8 :
    baud_rate == 2'b11 ? clk_76800x8 : clk_9600x8;

// CIC滤波器
wire [31:0] CIC_i_in;
// wire [34:0] CIC_i_out;
assign CIC_i_in = {filter_out_i[64], filter_out_i[35:4]};
CIC_Interpolator8 CIC_i_upsamp (
    .clk(clk_CIC),
    .clk_enable(1'b1),
    .reset(~rst_n),
    .filter_in(CIC_i_in),
    .filter_out(CIC_i_out),
    .ce_out()
);

wire [31:0] CIC_q_in;
// wire [34:0] CIC_q_out;
assign CIC_q_in = {filter_out_q[64], filter_out_q[35:4]};
CIC_Interpolator8 CIC_q_upsamp (
    .clk(clk_CIC),
    .clk_enable(1'b1),
    .reset(~rst_n),
    .filter_in(CIC_q_in),
    .filter_out(CIC_q_out),
    .ce_out()
);

endmodule
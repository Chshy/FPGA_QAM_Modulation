module filter_in_upsamp (
    input         clk_filter_sample,
    input         rst_n,
    input  [ 1:0] baud_rate,
    input  [31:0] symb_i,
    input  [31:0] symb_q,
    output [31:0] symb_i_upsamp,
    output [31:0] symb_q_upsamp
);

// 产生采样时钟
wire clk_76800;
wire clk_38400;
wire clk_19200;
wire clk_9600;
assign clk_76800 = clk_filter_sample;
reg [2:0] clk_filter_down_cnt;
always @(posedge clk_76800 or negedge rst_n) begin
    if(~rst_n) begin
        clk_filter_down_cnt <= 3'b0;
    end else begin
        clk_filter_down_cnt <= clk_filter_down_cnt + 1'b1;
    end
end
assign clk_38400 = clk_filter_down_cnt[0];
assign clk_19200 = clk_filter_down_cnt[1];
assign clk_9600 = clk_filter_down_cnt[2];

wire clk_samp;
assign clk_samp = 
    (baud_rate == 2'b00) ? clk_9600  : 
    (baud_rate == 2'b01) ? clk_19200 : 
    (baud_rate == 2'b10) ? clk_38400 : 
    (baud_rate == 2'b11) ? clk_76800 : 
                           clk_9600  ;



// wire [31:0] symb_i_upsamp;
defparam symb_i_upsamp_u.WIDTH = 32;
defparam symb_i_upsamp_u.SAMPLE_TYPE = 1;
samples symb_i_upsamp_u(
    .clk(clk_samp),
    .rst_n(rst_n),
    .data_in(symb_i),
    .data_out(symb_i_upsamp)
);

// wire [31:0] symb_q_upsamp;
defparam symb_q_upsamp_u.WIDTH = 32;
defparam symb_q_upsamp_u.SAMPLE_TYPE = 1;
samples symb_q_upsamp_u(
    .clk(clk_samp),
    .rst_n(rst_n),
    .data_in(symb_q),
    .data_out(symb_q_upsamp)
);

endmodule
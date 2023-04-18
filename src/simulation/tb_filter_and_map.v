module tb_filter_and_map (
);

reg clk;
reg rst_n;

// localparam carrier_width = 8;
// reg [carrier_width - 1: 0] carrier;
// wire [carrier_width + 1: 0] out_i;
// wire [carrier_width + 1: 0] out_q;
reg [3:0] symb;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    symb = 4'b0;
    // carrier = -127;
    #1000
    rst_n = 1'b1;
end
// always carrier = ~(0);
always #20 clk = ~clk;
always #1000 symb = symb + 1'b1;

wire [31:0] symb_i;
wire [31:0] symb_q;

constellation_map constellation_map_inst(
    .clk(clk),
    .rst_n(rst_n),
    .parellel_input(symb),
    .symbol_I(symb_i),
    .symbol_Q(symb_q)
);

wire [2:0]i_debug;
wire [2:0]q_debug;
assign i_debug = symb_i[31:29];
assign q_debug = symb_q[31:29];

wire [63:0]filter_out_i;
wire [63:0]filter_out_q;

filter u_filter_I
(
    .clk(clk),
    .clk_enable(1'b1),
    .reset(~rst_n),
    .filter_in(symb_i),
    .filter_out(filter_out_i)
);

filter u_filter_Q
(
    .clk(clk),
    .clk_enable(1'b1),
    .reset(~rst_n),
    .filter_in(symb_q),
    .filter_out(filter_out_q)
);


endmodule
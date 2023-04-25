module constellation_map (
    input         clk,
    input         rst_n,
    input         mod_type,
    input  [ 3:0] parellel_input,
    output [31:0] symbol_I, // signed 
    output [31:0] symbol_Q // signed
);

wire s3, s2, s1, s0;
assign s3 = parellel_input[3];
assign s2 = parellel_input[2];
assign s1 = parellel_input[1];
assign s0 = parellel_input[0];

wire [2:0] symbol_I_3bit;
wire [2:0] symbol_Q_3bit;
assign symbol_I_3bit = s3 == 1'b0 ? {1'b0, s1, 1'b1} : ~{1'b0, s1, 1'b1} + 1'b1;
assign symbol_Q_3bit = s2 == 1'b0 ? {1'b0, s0, 1'b1} : ~{1'b0, s0, 1'b1} + 1'b1;

// 符号位扩展
assign symbol_I = {{(32 - 3){symbol_I_3bit[3 - 1]}}, symbol_I_3bit};
assign symbol_Q = {{(32 - 3){symbol_Q_3bit[3 - 1]}}, symbol_Q_3bit};



    
endmodule
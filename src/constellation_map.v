module constellation_map #(
    parameter MOD_TYPE = 1 // 调制方式
) (
    input         clk,
    input         rst_n,
    input  [ 3:0] parellel_input,
    output [31:0] symbol_I, // signed
    output [31:0] symbol_Q // signed
);

wire s3, s2, s1, s0;
assign s3 = parellel_input[3];
assign s2 = parellel_input[2];
assign s1 = parellel_input[1];
assign s0 = parellel_input[0];

// assign symbol_I[31]    = s3;
// assign symbol_I[30:29] = {s1, 1};
// assign symbol_I[28: 0] = 29'b0;
assign symbol_I = {s3, s1, 1'b1, 29'b0};

// assign symbol_Q[31]    = s2;
// assign symbol_Q[30:29] = {s0, 1};
// assign symbol_Q[28: 0] = 29'b0;
assign symbol_Q = {s2, s0, 1'b1, 29'b0};



// always @(posedge clk, negedge rst_n) begin
//     if (!rst_n) begin
        
//     end else begin


//     end

// endmodule




    
endmodule
module tb_clk_gen (
);

reg clk;
reg rst_n;



initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    
    #1000
    rst_n = 1'b1;
end

always #45.210981566578595674574971562293 clk = ~clk;

wire clk_b, clk_s, clk_c;

clk_gen clk_gen_inst(
    .clk_in(clk),
    .rst_n(rst_n),
    .mod_type(1'b1),
    .baud_rate(2'b11),
    .clk_bitstream(clk_b),
    .clk_symbol(clk_s),
    .clk_analog_sample(clk_c)
);

endmodule
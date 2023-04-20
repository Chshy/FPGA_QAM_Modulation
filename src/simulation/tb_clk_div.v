module tb_clk_div (
);

reg clk;
reg rst_n;



initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    
    #1000
    rst_n = 1'b1;
end

always #20 clk = ~clk;

wire w_div1;
defparam div1.DIV_FACTOR = 13'd1;
clk_div div1(
    .clk_in(clk),
    .rst_n(rst_n),
    .clk_out(w_div1)
);
wire w_div2;
defparam div2.DIV_FACTOR = 13'd2;
clk_div div2(
    .clk_in(clk),
    .rst_n(rst_n),
    .clk_out(w_div2)
);
wire w_div3;
defparam div3.DIV_FACTOR = 13'd3;
clk_div div3(
    .clk_in(clk),
    .rst_n(rst_n),
    .clk_out(w_div3)
);
wire w_div4;
defparam div4.DIV_FACTOR = 13'd4;
clk_div div4(
    .clk_in(clk),
    .rst_n(rst_n),
    .clk_out(w_div4)
);

endmodule
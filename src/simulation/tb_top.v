module tb_top (
);

reg clk;
reg rst_n;

reg gen_bit_req;
wire m_seq_out;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    gen_bit_req = 1'b0;
    #1000
    rst_n = 1'b1;
end
always #20 clk = ~clk;
always #200 gen_bit_req = ~gen_bit_req;

m_seq_gen m_seq_gen_inst(
    .clk(clk),
    .rst_n(rst_n),
    .gen_bit_req(gen_bit_req),
    .m_seq_out(m_seq_out)
);






// top top_inst(


// );
    


    
endmodule
module clk_div (
    input        clk_in,
    input        rst_n,
    input [12:0] div_factor, // 分频系数1代表频率变为1/2
    output   reg clk_out
);

reg [12:0] cnt_reg;

always @(posedge clk_in or negedge rst_n) begin
    if(~rst_n) begin
        cnt_reg <= ~(0);
        clk_out <= 1'b0;
    end else begin
        cnt_reg <= cnt_reg + 1'd1;
        if(cnt_reg == (div_factor >> 1)) begin // flip to pos
            clk_out <= 1'b1;
        end
        if(cnt_reg >= div_factor) begin // flip to neg
            clk_out <= 1'b0;
            cnt_reg <= 13'd0;
        end
    end
end
    
endmodule
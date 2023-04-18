module global_ctrl (
    input clk,
    input rst_n,
    input mod_type,
    output parellel_width, // 串并转换的宽度
);
    


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin

    end else begin

    end
end
endmodule
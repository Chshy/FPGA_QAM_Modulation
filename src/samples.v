module samples #(
    parameter WIDTH = 1,
    parameter SAMPLE_TYPE = 0
) (
    input                    clk,
    input                    rst_n,
    input      [WIDTH - 1:0] data_in,
    output reg [WIDTH - 1:0] data_out
);
    
// 采样模块

reg [WIDTH - 1:0] data_last;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_out <= 0;
        data_last <= 0;
    end else begin
        if(SAMPLE_TYPE == 0) begin // 直接上采样
            data_out <= data_in;
        end else begin // 填充0(也就是变成Impulse)
            if(data_last == data_in) begin
                data_out <= {(WIDTH){1'b0}};
            end else begin
                data_out <= data_in;
                data_last <= data_in;
            end
        end
    end
end

endmodule
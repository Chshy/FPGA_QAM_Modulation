module read_file #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8,
    parameter INIT_ADDR  = 12'h001,
    parameter FILE_PATH  = "file_data.txt",
    parameter READ_MODE  = 1'b0 // 0=循环,1=读完一次就停止
) (
    input                         clk,
    input                         rst_n,
    output reg [DATA_WIDTH - 1:0] out_data,
    output reg                    EOF // End Of File
);

reg [DATA_WIDTH - 1:0] data[2 ** (ADDR_WIDTH):1];
reg [ADDR_WIDTH    :0] addr;

initial begin
    $readmemb(FILE_PATH, data);
    addr <= {{(ADDR_WIDTH){1'b0}}, 1'b1};
    out_data <= data[1];
    EOF <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        addr <= {{(ADDR_WIDTH){1'b0}}, 1'b1};
        out_data <= data[1];
        EOF <= 1'b0;
    end else begin
        if(EOF == 1'b1 && READ_MODE == 1'b1) begin
            // Do Nothing ...
        end else begin
            out_data <= data[addr];
            addr <= addr + 1'b1;
            EOF <= 1'b0;
            if(addr >= {1'b1, {(ADDR_WIDTH){1'b0}}}) begin // At End Of File
                EOF <= 1'b1;
                addr <= {{(ADDR_WIDTH){1'b0}}, 1'b1};
            end
        end
    end
end

endmodule

module sine_gen #(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 32,
    parameter INIT_ADDR  = 12'h001,
    parameter FILE_PATH  = "sine_data.mif"
) (
    input                         clk,
    input                         rst_n,
    input      [ADDR_WIDTH - 3:0] step,
    output reg [DATA_WIDTH - 1:0] sine_wav // signed
);


reg [DATA_WIDTH - 1:0] sine_data[2**(ADDR_WIDTH):1]; // 补码
reg [ADDR_WIDTH - 1:0] addr;


initial $readmemh(FILE_PATH, sine_data);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        addr <= INIT_ADDR;
        sine_wav <= sine_data[INIT_ADDR];
    end else begin
        sine_wav <= sine_data[addr];
        addr <= addr + step;
    end
end


endmodule
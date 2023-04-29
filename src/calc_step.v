module calc_step (
    input clk_calc,
    input  [15:0] freq,
    output reg [47:0] step
);

// step = 2^48 * freq / Fs

initial step <= 48'b0;
always @(posedge clk_calc) begin
    step <= {freq, {(48){1'b0}}} / 1382400;
end

endmodule
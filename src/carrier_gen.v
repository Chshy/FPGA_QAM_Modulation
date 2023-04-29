module carrier_gen(
    input         clk, // 230,401.25 Hz
    input clk_calc,
    input         rst_n,
    input  [15:0] freq, // 65535 Hz Max
    output [31:0] carrier_i,
    output [31:0] carrier_q
);
    
// 配置step 
wire [47:0] step_phase;
calc_step calc_step_u(
    .clk_calc(clk_calc),
    .freq(freq),
    .step(step_phase)
);

wire [15:0] carrier_i_16b;
wire [15:0] carrier_q_16b;
assign carrier_i = {carrier_i_16b, 16'b0};
assign carrier_q = {carrier_q_16b, 16'b0};
wave_gen wave_gen_inst (
	.clk(clk),
	.rst_n(rst_n),
	.step_phase(step_phase),
	.PhaseI(),
	.PhaseQ(),
	.I(carrier_i_16b),
	.Q(carrier_q_16b)
);

endmodule
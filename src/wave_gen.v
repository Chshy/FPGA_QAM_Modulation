module wave_gen
(
	input             clk,
	input             rst_n,
	input      [47:0] step_phase,
	output reg [ 9:0] PhaseI,
	output reg [ 9:0] PhaseQ,
	output reg [15:0] I,
	output reg [15:0] Q
);
// step_phase = 2^48 * frequency / Fs  suggestion: frequency < (Fs/4)

reg [47:0] buftemI;
reg [ 9:0] PI;
reg [ 9:0] PQ;
reg [ 1:0] state_t;
reg [15:0] sin_quarter[0:255];

initial
begin
	$readmemh("../data/sine_data_1024_quarter.mif", sin_quarter);
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		buftemI <= 48'b0;
		PI <= 10'd0;
		PQ <= 10'd255;
		PhaseI <= 10'd0;
		PhaseQ <= 10'd255;
		I <= sin_quarter[0];
		Q <= sin_quarter[255];
	end else begin
		state_t <= buftemI[47:46];
		buftemI <= buftemI + step_phase;
		PhaseI <= PI;
		PhaseQ <= PQ;
		I <= sin_quarter[PI];
		Q <= sin_quarter[PQ];
		case(buftemI[47:46])
			0:begin	
				PI <= buftemI[45:38];
				PQ <= 8'b11111111 - buftemI[45:38];
			end
			1:begin	
				PI <= 8'b11111111 - buftemI[45:38];
				PQ <= buftemI[45:38];
			end
			2:begin	
				PI <= buftemI[45:38];
				PQ <= 8'b11111111 - buftemI[45:38];
			end
			3:begin	
				PI <= 8'b11111111 - buftemI[45:38];
				PQ <= buftemI[45:38];
			end
		endcase
		case(state_t)
			0:begin	
				I <=  sin_quarter[PI];
				Q <=  sin_quarter[PQ];
			end
			1:begin	
				I <=  sin_quarter[PI];
				Q <= -sin_quarter[PQ];
			end
			2:begin	
				I <= -sin_quarter[PI];
				Q <= -sin_quarter[PQ];
			end
			3:begin
				I <= -sin_quarter[PI];
				Q <=  sin_quarter[PQ];
			end
		endcase
	end
end
endmodule

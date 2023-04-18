module tb_sine_freq (
);

reg clk;
reg rst_n;

reg [5:0]step;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    step = 6'b0;
    #1000
    rst_n = 1'b1;
end

always #20 clk = ~clk;

always #2000 step <= step + 1'b1;

wire [31:0]sine_wav;
// wire [31:0]sine_wav2;

wire [30:0] step_wire;
assign step_wire[29:6] = 24'b0;
assign step_wire[5:0] = step;

defparam sine_gen_inst.ADDR_WIDTH = 12;
defparam sine_gen_inst.DATA_WIDTH = 32;
defparam sine_gen_inst.INIT_ADDR = 12'h000;
defparam sine_gen_inst.FILE_PATH = "E:/Workspace/CurriculumDesign202304/FPGA_QAM_Modulation/sine_data.mif";
sine_gen sine_gen_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .step(step_wire),
    .sine_wav(sine_wav)
);

endmodule
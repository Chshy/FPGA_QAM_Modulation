module tb_sine_gen (
);

reg clk;
reg rst_n;

initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    #1000
    rst_n = 1'b1;
end

always #20 clk = ~clk;

wire [31:0]sine_wav;
wire [31:0]sine_wav2;

defparam sine_gen_inst.ADDR_WIDTH = 12;
defparam sine_gen_inst.DATA_WIDTH = 32;
defparam sine_gen_inst.INIT_ADDR = 12'h000;
defparam sine_gen_inst.FILE_PATH = "E:/Workspace/CurriculumDesign202304/FPGA_QAM_Modulation/sine_data.mif";
sine_gen sine_gen_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .step(1'b1),
    .sine_wav(sine_wav)
);

defparam sine_gen_inst2.ADDR_WIDTH = 12;
defparam sine_gen_inst2.DATA_WIDTH = 32;
defparam sine_gen_inst2.INIT_ADDR = 12'h400;
defparam sine_gen_inst2.FILE_PATH = "E:/Workspace/CurriculumDesign202304/FPGA_QAM_Modulation/sine_data.mif";
sine_gen sine_gen_inst2
(
    .clk(clk),
    .rst_n(rst_n),
    .step(1'b1),
    .sine_wav(sine_wav2)
);


endmodule
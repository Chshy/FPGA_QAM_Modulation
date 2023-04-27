module carrier_gen(
    input         clk, // 230,401.25 Hz
    input         rst_n,
    input  [15:0] freq, // 65065 Hz Max
    output [31:0] carrier_i,
    output [31:0] carrier_q
);
    
// 配置step 
wire [9:0] step;
calc_step calc_step_u(
    .freq(freq),
    .step(step)
);

// I路载波
defparam sine_gen_I.ADDR_WIDTH = 12;
defparam sine_gen_I.DATA_WIDTH = 32;
defparam sine_gen_I.INIT_ADDR = 12'h001;
defparam sine_gen_I.FILE_PATH = "../data/sine_data.mif";
sine_gen sine_gen_I
(
    .clk(clk),
    .rst_n(rst_n),
    .step(step),
    .sine_wav(carrier_i)
);

// Q路载波
defparam sine_gen_Q.ADDR_WIDTH = 12;
defparam sine_gen_Q.DATA_WIDTH = 32;
defparam sine_gen_Q.INIT_ADDR = 12'h401;
defparam sine_gen_Q.FILE_PATH = "../data/sine_data.mif";
sine_gen sine_gen_Q
(
    .clk(clk),
    .rst_n(rst_n),
    .step(step),
    .sine_wav(carrier_q)
);

endmodule
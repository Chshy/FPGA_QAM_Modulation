module clk_gen (
    input        clk_in,
    input        rst_n,
    input        mod_type,  // 0 = QPSK  1 = 16QAM
    input  [1:0] baud_rate, // 符号波特率 2400(00) 4800(01) 9600(10) 19200(11)
    output       clk_bitstream,
    output       clk_symbol,
    output       clk_analog_sample
);
    
/*

设计要求：符号速率1200/2400/4800/9600 Baud 
载波10K-50K,fs至少200k

*/

wire [12:0] div_bitstream;
wire [12:0] div_symbol;
wire [12:0] div_analog_sample;

assign div_bitstream = 
    (mod_type == 1'b0) ? (// QPSK
        (baud_rate == 2'b00) ? 13'd2304 :  //  QPSK( 2400Baud) BitRate =  4800bit/s
        (baud_rate == 2'b01) ? 13'd1152 :  //  QPSK( 4800Baud) BitRate =  9600bit/s
        (baud_rate == 2'b10) ? 13'd576  :  //  QPSK( 9600Baud) BitRate = 19200bit/s
        (baud_rate == 2'b11) ? 13'd288  :  //  QPSK(19200Baud) BitRate = 38400bit/s
                               13'd1    
    ) : ( // 16QAM
        (baud_rate == 2'b00) ? 13'd1152 :  // 16QAM( 2400Baud) BitRate =  9600bit/s
        (baud_rate == 2'b01) ? 13'd576  :  // 16QAM( 4800Baud) BitRate = 19200bit/s
        (baud_rate == 2'b10) ? 13'd288  :  // 16QAM( 9600Baud) BitRate = 38400bit/s
        (baud_rate == 2'b11) ? 13'd144  :  // 16QAM(19200Baud) BitRate = 76800bit/s
                               13'd1    );

// assign div_symbol = 
//     (baud_rate == 2'b00) ? 13'd4608 :
//     (baud_rate == 2'b01) ? 13'd2304 :
//     (baud_rate == 2'b10) ? 13'd1152 :
//     (baud_rate == 2'b11) ? 13'd576  : 
//                            13'd1    ;
// 如果分别用三个计数器产生，则不能保证symbol和bit的严格相位关系(在动态配置后)
// 可以用bit分频得到symbol
reg [1:0] div_symbol_cnt;
assign clk_symbol = (mod_type == 1'b0) ? div_symbol_cnt[0] : div_symbol_cnt[1];
always @(posedge clk_bitstream or negedge rst_n) begin
    if(~rst_n) begin
        div_symbol_cnt <= 2'b0;
    end else begin
        div_symbol_cnt <= div_symbol_cnt + 1'b1;
    end
end

assign div_analog_sample = 13'd48;


clk_div clk_bitstream_gen(
    .clk_in(clk_in),
    .rst_n(rst_n),
    .div_factor(div_bitstream),
    .clk_out(clk_bitstream)
);
// clk_div clk_symbol_gen(
//     .clk_in(clk_in),
//     .rst_n(rst_n),
//     .div_factor(div_symbol),
//     .clk_out(clk_symbol)
// );
clk_div clk_analog_sample_gen(
    .clk_in(clk_in),
    .rst_n(rst_n),
    .div_factor(div_analog_sample),
    .clk_out(clk_analog_sample)
);

endmodule
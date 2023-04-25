module clk_gen (
    input        clk_in,
    input        rst_n,
    input        mod_type,  // 0 = QPSK  1 = 16QAM
    input  [1:0] baud_rate, // 符号波特率 2400(00) 4800(01) 9600(10) 19200(11)
    output       clk_bitstream,
    output       clk_symbol,
    output       clk_filter_sample,
    output       clk_analog_sample
);
    
/*

设计要求：符号速率1200/2400/4800/9600 Baud 
载波10K-50K,fs至少200k

*/


// 产生clk_bitstream
wire [12:0] div_bitstream;
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
clk_div clk_bitstream_gen(
    .clk_in(clk_in),
    .rst_n(rst_n),
    .div_factor(div_bitstream),
    .clk_out(clk_bitstream)
);


// 产生clk_symbol
reg [1:0] div_symbol_cnt;
assign clk_symbol = (mod_type == 1'b0) ? div_symbol_cnt[0] : div_symbol_cnt[1];
always @(posedge clk_bitstream or negedge rst_n) begin
    if(~rst_n) begin
        div_symbol_cnt <= 2'b0;
    end else begin
        div_symbol_cnt <= div_symbol_cnt + 1'b1;
    end
end


// 产生clk_filter_sample
wire [12:0] div_filter_sample;
assign div_filter_sample = 13'd144;
clk_div clk_filter_sample_gen(
    .clk_in(clk_in),
    .rst_n(rst_n),
    .div_factor(div_filter_sample),
    .clk_out(clk_filter_sample)
);

// (baud_rate == 2'b00) ? 13'd2304 :  //  QPSK( 2400Baud) BitRate =  4800bit/s
//         (baud_rate == 2'b01) ? 13'd1152 :  //  QPSK( 4800Baud) BitRate =  9600bit/s
//         (baud_rate == 2'b10) ? 13'd576  :  //  QPSK( 9600Baud) BitRate = 19200bit/s
//         (baud_rate == 2'b11) ? 13'd288  :  //  QPSK(19200Baud) BitRate = 38400bit/s

// 产生clk_analog_sample
reg [3:0] div_analog_sample_cnt;
assign clk_analog_sample = div_analog_sample_cnt[3];
always @(posedge clk_in or negedge rst_n) begin
    if(~rst_n) begin
        div_analog_sample_cnt <= 4'b0;
    end else begin
        div_analog_sample_cnt <= div_analog_sample_cnt + 1'b1;
    end
end

endmodule
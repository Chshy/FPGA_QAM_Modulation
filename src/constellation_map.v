module constellation_map (
    input         clk,
    input         rst_n,
    input         mod_type,
    input  [ 3:0] parellel_input,
    output [31:0] symbol_I, // signed 
    output [31:0] symbol_Q // signed
);

// bit拆分
wire s3, s2, s1, s0;
assign s3 = parellel_input[3];
assign s2 = parellel_input[2];
assign s1 = parellel_input[1];
assign s0 = parellel_input[0];

// QPSK
wire [2:0] symbol_I_QPSK;
wire [2:0] symbol_Q_QPSK;


assign symbol_I_QPSK = (s0 == 1'b0) ? 3'b011 : 3'b101;
assign symbol_Q_QPSK = (s1 == 1'b0) ? 3'b011 : 3'b101;

// 16QAM
wire [2:0] symbol_I_16QAM;
wire [2:0] symbol_Q_16QAM;
assign symbol_I_16QAM = (s3 == 1'b0) ? {1'b0, s1, 1'b1} : ~{1'b0, s1, 1'b1} + 1'b1;
assign symbol_Q_16QAM = (s2 == 1'b0) ? {1'b0, s0, 1'b1} : ~{1'b0, s0, 1'b1} + 1'b1;

// MUX
wire [2:0] symbol_I_3bit;
wire [2:0] symbol_Q_3bit;
assign symbol_I_3bit = (mod_type == 1'b0) ? symbol_I_QPSK : symbol_I_16QAM;
assign symbol_Q_3bit = (mod_type == 1'b0) ? symbol_Q_QPSK : symbol_Q_16QAM;

// 符号位扩展
assign symbol_I = {{(32 - 3){symbol_I_3bit[3 - 1]}}, symbol_I_3bit};
assign symbol_Q = {{(32 - 3){symbol_Q_3bit[3 - 1]}}, symbol_Q_3bit};

endmodule

/* Constellation Diagram

           Q
           ^ 
           ┃
        01 ┃ 00
━━━━━━━━━━━╋━━━━━━━━━━━>I
        11 ┃ 10
           ┃
    映射表
symbol ┃  I ┃  Q
━━━━━━━╋━━━━╋━━━━━
   00  ┃  3 ┃  3
   01  ┃ -3 ┃  3
   10  ┃  3 ┃ -3
   11  ┃ -3 ┃ -3
 
 
00 011 011
01 111 011
10 011 111
11 111 111



           Q
           ^ 
 1011 1001 ┃ 0001 0011 
 1010 1000 ┃ 0000 0010 
━━━━━━━━━━━╋━━━━━━━━━━━>I
 1110 1100 ┃ 0100 0110 
 1111 1101 ┃ 0101 0111 
           ┃
    映射表
symbol ┃  I ┃  Q
━━━━━━━╋━━━━╋━━━━━
 0000  ┃  1 ┃  1
 0001  ┃  1 ┃  3
 0010  ┃  3 ┃  1
 0011  ┃  3 ┃  3
 0100  ┃  1 ┃ -1
 0101  ┃  1 ┃ -3
 0110  ┃  3 ┃ -1
 0111  ┃  3 ┃ -3
 1000  ┃ -1 ┃  1
 1001  ┃ -1 ┃  3
 1010  ┃ -3 ┃  1
 1011  ┃ -3 ┃  3
 1100  ┃ -1 ┃ -1
 1101  ┃ -1 ┃ -3
 1110  ┃ -3 ┃ -1
 1111  ┃ -3 ┃ -3

 记symbol为s3s2s1s0, 则归纳为:
 s3 = 0,  I  > 0 / s3 = 1,  I  < 0
 s1 = 0, |I| = 1 / s1 = 1, |3| = 3
 s2 = 0,  I  > 0 / s2 = 1,  I  < 0
 s0 = 0, |I| = 1 / s0 = 1, |3| = 3

*/



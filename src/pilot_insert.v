module pilot_insert (
    input clk_symbol,
    input rst_n,
    input mod_type,
    input [3:0] data_in,
    output random_data_gen,
    output [3:0] data_out
);

wire pilot_send_finish;
wire [1:0] pilot_QPSK_data;
wire [3:0] pilot_16QAM_data;
wire EOF_QPSK;
wire EOF_16QAM;

assign data_out = (pilot_send_finish == 1'b1) ?        data_in          :
                  (mod_type          == 1'b0) ? {2'b0, pilot_QPSK_data} : pilot_16QAM_data ;
assign pilot_send_finish = (mod_type == 1'b0) ? EOF_QPSK : EOF_16QAM;
assign random_data_gen = pilot_send_finish;

// QPSK Pilot 读取
defparam pilot_QPSK.ADDR_WIDTH = 6;
defparam pilot_QPSK.DATA_WIDTH = 2;
defparam pilot_QPSK.FILE_PATH = "../data/pilot_QPSK.txt";
defparam pilot_QPSK.READ_MODE = 1'b1;
read_file pilot_QPSK (
    .clk(clk_symbol),
    .rst_n(rst_n),
    .out_data(pilot_QPSK_data),
    .EOF(EOF_QPSK)
);
// 16QAM Pilot 读取
defparam pilot_16QAM.ADDR_WIDTH = 6;
defparam pilot_16QAM.DATA_WIDTH = 4;
defparam pilot_16QAM.FILE_PATH = "../data/pilot_16QAM.txt";
defparam pilot_16QAM.READ_MODE = 1'b1;
read_file pilot_16QAM (
    .clk(clk_symbol),
    .rst_n(rst_n),
    .out_data(pilot_16QAM_data),
    .EOF(EOF_16QAM)
);

endmodule
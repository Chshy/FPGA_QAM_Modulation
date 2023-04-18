// 这是串并转换Verilog代码，用于QAM调制
module serial_to_parellel(
    input             clk,
    input             rst_n,
    input             serial_in_req,      // 输入请求
    input             serial_input,       // 串行输入
    input      [ 3:0] parellel_width_cfg, // 配置并行输出的宽度(0-15分别代表宽度1bit-16bit, QPSK用4(cfg = 3), 16QAM用16(cfg = 15))
    output reg        complete,           // 完成一次转换的脉冲
    output reg [15:0] parellel_output     // 并行输出(right align)    
);

reg [3:0] conv_cnt; // 当前转换到一组里第几个

reg [ 3:0] cfg_reg; // 输出宽度配置信息暂存
reg [15:0] out_reg; // 输出暂存

reg serial_in_req_d0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        serial_in_req_d0 <= 1'b0;
        out_reg <= 4'b0;
        conv_cnt <= 4'b1111;
        cfg_reg <= 4'b0;

        parellel_output <= 4'b0;
        complete <= 1'b0;
    end else begin

        if(complete == 1'b1) begin
            complete <= 1'b0;
        end

        // 在serial_in_req的上升沿
        if(serial_in_req_d0 == 1'b0 && serial_in_req == 1'b1) begin
            // 每一组转换开始的时候锁存一下配置的宽度
            if(conv_cnt == 4'b0) begin 
                cfg_reg = parellel_width_cfg;
            end

            case (conv_cnt)
                4'b0000: out_reg[ 0] = serial_input;
                4'b0001: out_reg[ 1] = serial_input;
                4'b0010: out_reg[ 2] = serial_input;
                4'b0011: out_reg[ 3] = serial_input;
                4'b0100: out_reg[ 4] = serial_input;
                4'b0101: out_reg[ 5] = serial_input;
                4'b0110: out_reg[ 6] = serial_input;
                4'b0111: out_reg[ 7] = serial_input;
                4'b1000: out_reg[ 8] = serial_input;
                4'b1001: out_reg[ 9] = serial_input;
                4'b1010: out_reg[10] = serial_input;
                4'b1011: out_reg[11] = serial_input;
                4'b1100: out_reg[12] = serial_input;
                4'b1101: out_reg[13] = serial_input;
                4'b1110: out_reg[14] = serial_input;
                4'b1111: out_reg[15] = serial_input;
                default: ;
            endcase

            if(conv_cnt == 4'b1111) begin // 转换完一组
                parellel_output <= out_reg;
                complete <= 1'b1;
            end
            conv_cnt <= conv_cnt + 1'b1;
        end
        serial_in_req_d0 <= serial_in_req;

    end
end




endmodule
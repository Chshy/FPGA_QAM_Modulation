module serial_to_parellel(
    input             clk,
    input             rst_n,
    input             mod_type,        // 0 = QPSK, 1 = 16QAM
    input             serial_input,    // 串行输入
    output reg [3:0]  parellel_output   // 并行输出(right align)    
);

reg [1:0] conv_cnt; // 当前转换到一组里第几个

reg [3:0] mod_type_reg; // 配置信息暂存
reg [3:0] out_reg;      // 输出暂存

wire [1:0]cnt_max;
assign cnt_max = (mod_type_reg == 1'b0) ? 2'b01 : 2'b11;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mod_type_reg <= 4'b0;
        conv_cnt <= 2'b11;
        
        out_reg <= 4'b0;
        parellel_output <= 4'b0;
    end else begin

        if(conv_cnt == cnt_max) begin
            mod_type_reg <= mod_type;
        end

        case (conv_cnt)
            2'b00: out_reg[0] = serial_input;
            2'b01: out_reg[1] = serial_input;
            2'b10: out_reg[2] = serial_input;
            2'b11: out_reg[3] = serial_input;
            default: ;
        endcase

        if(conv_cnt == cnt_max) begin // 转换完一组
            parellel_output <= out_reg;
            conv_cnt <= 2'b00;
        end else begin
            conv_cnt <= conv_cnt + 1'b1;
        end

    end
end




endmodule
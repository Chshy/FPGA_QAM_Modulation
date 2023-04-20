module m_seq_gen #(
    parameter REG_LEN = 4
) (
    input       clk,
    input       rst_n,
    output wire m_seq_out
);

reg [(REG_LEN - 1):0] shift_reg; // 移位寄存器
    
assign m_seq_out = shift_reg[(REG_LEN - 1)];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_reg = ~(0); // 全bit置为1
    end else begin
        shift_reg <= shift_reg<<1; // 朝MSB方向移1bit
        // 填充LSB
        case (REG_LEN)
            2 : shift_reg[0] <= shift_reg[0] ^ shift_reg[1];
            3 : shift_reg[0] <= shift_reg[0] ^ shift_reg[2];
            4 : shift_reg[0] <= shift_reg[0] ^ shift_reg[3];
            5 : shift_reg[0] <= shift_reg[1] ^ shift_reg[4];
            6 : shift_reg[0] <= shift_reg[0] ^ shift_reg[5];
            7 : shift_reg[0] <= shift_reg[2] ^ shift_reg[6];
            8 : shift_reg[0] <= shift_reg[1] ^ shift_reg[2] ^ shift_reg[3] ^ shift_reg[7];
            9 : shift_reg[0] <= shift_reg[3] ^ shift_reg[8];
            10: shift_reg[0] <= shift_reg[2] ^ shift_reg[9];
            11: shift_reg[0] <= shift_reg[1] ^ shift_reg[10];
            12: shift_reg[0] <= shift_reg[0] ^ shift_reg[3] ^ shift_reg[5] ^ shift_reg[11];
            13: shift_reg[0] <= shift_reg[0] ^ shift_reg[2] ^ shift_reg[3] ^ shift_reg[12];
            default: shift_reg[0] <= shift_reg[0];
        endcase
    end
end
endmodule


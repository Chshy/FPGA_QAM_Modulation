/*
    M序列发生器
    2023/4/17 YCS
*/
module m_seq_gen #(
    parameter REG_LEN = 4
    // parametr [3:0]INITIAL_STATE = 4'b1000; // 初始状态
) (
    input       clk,
    input       rst_n,
    input       gen_bit_req,
    output wire m_seq_out
);

// 

reg [(REG_LEN - 1):0]shift_reg; // 移位寄存器
reg gen_bit_req_d0;
    
assign m_seq_out = shift_reg[(REG_LEN - 1)];


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
//        shift_reg <= INITIAL_STATE;
        gen_bit_req_d0 <= 1'b0;
        shift_reg = ~(0); // 全bit置为1
    end else begin
        if(gen_bit_req_d0 == 1'b0 && gen_bit_req == 1'b1) begin
            // 遇到gen_bit_req的上升沿

            shift_reg <= shift_reg<<1; // 朝MSB方向移1bit

            // 填充LSB
            case (REG_LEN)
                // 2 : shift_reg[0] <= shift_reg[1] ^ shift_reg[0];
                // 3 : shift_reg[0] <= shift_reg[2] ^ shift_reg[1];
                // 4 : shift_reg[0] <= shift_reg[3] ^ shift_reg[2];
                // 5 : shift_reg[0] <= shift_reg[4] ^ shift_reg[2];
                // 6 : shift_reg[0] <= shift_reg[5] ^ shift_reg[4];
                // 7 : shift_reg[0] <= shift_reg[6] ^ shift_reg[3];
                // 8 : shift_reg[0] <= shift_reg[7] ^ shift_reg[5] ^ shift_reg[4] ^ shift_reg[3];
                // 9 : shift_reg[0] <= shift_reg[8] ^ shift_reg[4];
                // 10: shift_reg[0] <= shift_reg[9] ^ shift_reg[6];
                // 11: shift_reg[0] <= shift_reg[10] ^ shift_reg[8];
                // 12: shift_reg[0] <= shift_reg[11] ^ shift_reg[10] ^ shift_reg[7] ^ shift_reg[5];
                // 13: shift_reg[0] <= shift_reg[12] ^ shift_reg[11] ^ shift_reg[9] ^ shift_reg[8];
                // 14: shift_reg[0] <= shift_reg[13] ^ shift_reg[12] ^ shift_reg[7] ^ shift_reg[3];
                // 15: shift_reg[0] <= shift_reg[14] ^ shift_reg[13];
                // 16: shift_reg[0] <= shift_reg[15] ^ shift_reg[14] ^ shift_reg[12] ^ shift_reg[3];
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
                // 14: shift_reg[0] <= shift_reg[13] ^ shift_reg[12] ^ shift_reg[7] ^ shift_reg[3];
                // 15: shift_reg[0] <= shift_reg[14] ^ shift_reg[13];
                // 16: shift_reg[0] <= shift_reg[15] ^ shift_reg[14] ^ shift_reg[12] ^ shift_reg[3];
                default: shift_reg[0] <= shift_reg[0];
            endcase
        end
        gen_bit_req_d0 <= gen_bit_req;
    end
    
end





endmodule


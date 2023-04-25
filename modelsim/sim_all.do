# 退出当前仿真
quit -sim
# 清空命令窗口
.main clear
# 编译所有代码
vlog -reportprogress 300 ../src/*.v
# 开启仿真
vsim -voptargs=+acc work.tb_top

# 添加时钟波形
add wave -color #82D3FF -radix binary top_inst/clk
add wave -color #82D3FF -radix binary top_inst/clk_bitstream
add wave -color #82D3FF -radix binary top_inst/clk_symbol
add wave -color #82D3FF -radix binary top_inst/clk_filter_sample
add wave -color #82D3FF -radix binary top_inst/clk_analog_sample

# m序列比特流
add wave -color #39FF14 -radix binary top_inst/m_seq_out

# 串并转换
add wave -color #82D3FF -radix binary top_inst/parellel_output_downsamp

# 添加IQ Symbol
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_i
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_q

# 添加IQ Symbol Upsamp
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_i_upsamp
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_q_upsamp

# 添加成型滤波器波形
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 1.55538e+010 -min -1.34293e+010 top_inst/filter_out_i
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 1.55538e+010 -min -1.34293e+010 top_inst/filter_out_q

# 添加CIC插值波形
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 1.55538e+010 -min -1.34293e+010 top_inst/CIC_i_out
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 1.55538e+010 -min -1.34293e+010 top_inst/CIC_q_out

# 添加调制结果
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 1.21127e+009 -min -1.21728e+009 top_inst/mod_iq

# 运行仿真
run 50ms

# 调整时间刻度
wave zoomfull

# 退出当前仿真
quit -sim
# 清空命令窗口
.main clear
# 编译所有代码
vlog -reportprogress 300 ../src/*.v

# 开启仿真
vsim -voptargs=+acc work.tb_top

# 添加配置
add wave -color #39FF14 -radix binary top_inst/mod_type
add wave -color #39FF14 -radix binary top_inst/baud_rate

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
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 4.55273e+009 -min -4.57542e+009 top_inst/filter_out_i
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 4.55273e+009 -min -4.57542e+009 top_inst/filter_out_q

# 添加CIC插值波形
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 2.27637e+009 -min -2.28771e+009 top_inst/CIC_i_out
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 2.27637e+009 -min -2.28771e+009 top_inst/CIC_q_out

# 添加载波
add wave -color #39FF14 -radix decimal -format Analog-Step -height 74 -max 2.33714e+009 -min -2.34748e+009 top_inst/carrier_i
add wave -color #39FF14 -radix decimal -format Analog-Step -height 74 -max 2.33714e+009 -min -2.34748e+009 top_inst/carrier_q

# 添加调制结果
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 1.81413e+008 -min -1.8054e+008 top_inst/mod_iq

# 运行仿真
run 40ms

# 调整时间刻度
wave zoomfull

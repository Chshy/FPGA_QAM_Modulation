# �˳���ǰ����
quit -sim
# ��������
.main clear
# �������д���
vlog -reportprogress 300 ../src/*.v

# ��������
vsim -voptargs=+acc work.tb_top

# �������
add wave -color #39FF14 -radix binary top_inst/mod_type
add wave -color #39FF14 -radix binary top_inst/baud_rate

# ���ʱ�Ӳ���
add wave -color #82D3FF -radix binary top_inst/clk
add wave -color #82D3FF -radix binary top_inst/clk_bitstream
add wave -color #82D3FF -radix binary top_inst/clk_symbol
add wave -color #82D3FF -radix binary top_inst/clk_filter_sample
add wave -color #82D3FF -radix binary top_inst/clk_analog_sample

# m���б�����
add wave -color #39FF14 -radix binary top_inst/m_seq_out

# ����ת��
add wave -color #82D3FF -radix binary top_inst/parellel_output_downsamp

# ���IQ Symbol
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_i
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_q

# ���IQ Symbol Upsamp
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_i_upsamp
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 3 -min -3 top_inst/symb_q_upsamp

# ��ӳ����˲�������
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 9.41634e+009 -min -9.45273e+009 top_inst/filter_out_i
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 9.41634e+009 -min -9.45273e+009 top_inst/filter_out_q

# ���CIC��ֵ����
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 4.70817e+009 -min -4.72637e+009 top_inst/CIC_i_out
add wave -color #82D3FF -radix decimal -format Analog-Step -height 74 -max 4.70817e+009 -min -4.72637e+009 top_inst/CIC_q_out

# ��ӵ��ƽ��
add wave -color #B3FFB3 -radix decimal -format Analog-Step -height 74 -max 3.89432e+008 -min -3.9129e+008 top_inst/mod_iq

# ���з���
run 20ms

# ����Analog���εķ���(����û��)
# wave -group {Test} -group {Combined Waveforms} -radix unsigned -format analogautomatic /tb_top/block_inst/combined_abc
# wave -radix decimal -format analogautomatic top_inst/mod_iq

# ����ʱ��̶�
wave zoomfull

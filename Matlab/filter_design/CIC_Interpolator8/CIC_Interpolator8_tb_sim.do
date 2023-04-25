onbreak resume
onerror resume
vsim -voptargs=+acc work.CIC_Interpolator8_tb
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/clk
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/clk_enable
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/reset
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/filter_in
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/filter_out
add wave sim:/CIC_Interpolator8_tb/filter_out_ref
add wave sim:/CIC_Interpolator8_tb/u_CIC_Interpolator8/ce_out
run -all

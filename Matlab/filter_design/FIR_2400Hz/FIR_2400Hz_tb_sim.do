onbreak resume
onerror resume
vsim -voptargs=+acc work.FIR_2400Hz_tb
add wave sim:/FIR_2400Hz_tb/u_FIR_2400Hz/clk
add wave sim:/FIR_2400Hz_tb/u_FIR_2400Hz/clk_enable
add wave sim:/FIR_2400Hz_tb/u_FIR_2400Hz/reset
add wave sim:/FIR_2400Hz_tb/u_FIR_2400Hz/filter_in
add wave sim:/FIR_2400Hz_tb/u_FIR_2400Hz/filter_out
add wave sim:/FIR_2400Hz_tb/filter_out_ref
run -all

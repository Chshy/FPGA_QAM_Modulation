onbreak resume
onerror resume
vsim -voptargs=+acc work.FIR_1200Hz_tb
add wave sim:/FIR_1200Hz_tb/u_FIR_1200Hz/clk
add wave sim:/FIR_1200Hz_tb/u_FIR_1200Hz/clk_enable
add wave sim:/FIR_1200Hz_tb/u_FIR_1200Hz/reset
add wave sim:/FIR_1200Hz_tb/u_FIR_1200Hz/filter_in
add wave sim:/FIR_1200Hz_tb/u_FIR_1200Hz/filter_out
add wave sim:/FIR_1200Hz_tb/filter_out_ref
run -all

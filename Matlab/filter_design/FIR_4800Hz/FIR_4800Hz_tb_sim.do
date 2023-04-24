onbreak resume
onerror resume
vsim -voptargs=+acc work.FIR_4800Hz_tb
add wave sim:/FIR_4800Hz_tb/u_FIR_4800Hz/clk
add wave sim:/FIR_4800Hz_tb/u_FIR_4800Hz/clk_enable
add wave sim:/FIR_4800Hz_tb/u_FIR_4800Hz/reset
add wave sim:/FIR_4800Hz_tb/u_FIR_4800Hz/filter_in
add wave sim:/FIR_4800Hz_tb/u_FIR_4800Hz/filter_out
add wave sim:/FIR_4800Hz_tb/filter_out_ref
run -all

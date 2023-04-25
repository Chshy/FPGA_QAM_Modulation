onbreak resume
onerror resume
vsim -voptargs=+acc work.FIR_RCos_9600Hz_tb
add wave sim:/FIR_RCos_9600Hz_tb/u_FIR_RCos_9600Hz/clk
add wave sim:/FIR_RCos_9600Hz_tb/u_FIR_RCos_9600Hz/clk_enable
add wave sim:/FIR_RCos_9600Hz_tb/u_FIR_RCos_9600Hz/reset
add wave sim:/FIR_RCos_9600Hz_tb/u_FIR_RCos_9600Hz/filter_in
add wave sim:/FIR_RCos_9600Hz_tb/u_FIR_RCos_9600Hz/filter_out
add wave sim:/FIR_RCos_9600Hz_tb/filter_out_ref
run -all

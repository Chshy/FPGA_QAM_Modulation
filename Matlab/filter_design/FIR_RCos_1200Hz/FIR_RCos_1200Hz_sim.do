onbreak resume
onerror resume
vsim -voptargs=+acc work.FIR_RCos_1200Hz
add wave sim:/FIR_RCos_1200Hz/u_FIR_RCos_1200Hz/clk
add wave sim:/FIR_RCos_1200Hz/u_FIR_RCos_1200Hz/clk_enable
add wave sim:/FIR_RCos_1200Hz/u_FIR_RCos_1200Hz/reset
add wave sim:/FIR_RCos_1200Hz/u_FIR_RCos_1200Hz/filter_in
add wave sim:/FIR_RCos_1200Hz/u_FIR_RCos_1200Hz/filter_out
add wave sim:/FIR_RCos_1200Hz/filter_out_ref
run -all

add wave -r sim:/mult/*
force -freeze sim:/mult/clk 1 0, 0 {50 ns} -r 100
force a_in 10#5
force b_in 10#6
force reset 1
force start 0
run 50ns
force reset 0
run 50ns
force reset 1
run 50ns
force start 1
run 50ns
force start 0
run 50ns
run 10500ns

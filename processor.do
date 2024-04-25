vcom Proccessor.vhd
vsim processor

add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/inPort
add wave -position end  sim:/processor/alu_result
add wave -position end  sim:/processor/flag
add wave -position end  sim:/processor/Registers

# ** Warning: (vsim-3473) Component instance "adds : thirtytwobitadder" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor/execute1/add/CCR1 File: D:/PROJECTS/ArchPhase1/CCR.vhd
mem load -i {D:/PROJECTS/ArchPhase1/FINALLLLLLLL isA.mem} /processor/fetch1/icache/ram
force -freeze sim:/processor/rst 1 0
run

force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
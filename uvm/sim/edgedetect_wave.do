

#add wave -noupdate -group my_uvm_tb
#add wave -noupdate -group my_uvm_tb -radix hexadecimal /my_uvm_tb/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst
add wave -noupdate -group my_uvm_tb/edgedetect_inst -radix hexadecimal /my_uvm_tb/edgedetect_inst/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst/incoming
add wave -noupdate -group my_uvm_tb/edgedetect_inst/incoming -radix hexadecimal /my_uvm_tb/edgedetect_inst/incoming/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst/gray
add wave -noupdate -group my_uvm_tb/edgedetect_inst/gray -radix hexadecimal /my_uvm_tb/edgedetect_inst/gray/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst/sobel_fifo
add wave -noupdate -group my_uvm_tb/edgedetect_inst/sobel_fifo -radix hexadecimal /my_uvm_tb/edgedetect_inst/sobel_fifo/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst/sobel_inst
add wave -noupdate -group my_uvm_tb/edgedetect_inst/sobel_inst -radix hexadecimal /my_uvm_tb/edgedetect_inst/sobel_inst/*

add wave -noupdate -group my_uvm_tb/edgedetect_inst/outgoing
add wave -noupdate -group my_uvm_tb/edgedetect_inst/outgoing -radix hexadecimal /my_uvm_tb/edgedetect_inst/outgoing/*
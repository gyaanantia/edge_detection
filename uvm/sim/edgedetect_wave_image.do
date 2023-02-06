

#add wave -noupdate -group edgedetect_tb
#add wave -noupdate -group edgedetect_tb -radix hexadecimal /edgedetect_tb/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst
add wave -noupdate -group edgedetect_tb/edgedetect_inst -radix hexadecimal /edgedetect_tb/edgedetect_inst/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/incoming
add wave -noupdate -group edgedetect_tb/edgedetect_inst/incoming -radix hexadecimal /edgedetect_tb/edgedetect_inst/incoming/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/gray
add wave -noupdate -group edgedetect_tb/edgedetect_inst/gray -radix hexadecimal /edgedetect_tb/edgedetect_inst/gray/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_fifo
add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_fifo -radix hexadecimal /edgedetect_tb/edgedetect_inst/sobel_fifo/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_inst
add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_inst -radix hexadecimal /edgedetect_tb/edgedetect_inst/sobel_inst/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_inst/sr
add wave -noupdate -group edgedetect_tb/edgedetect_inst/sobel_inst/sr -radix hexadecimal /edgedetect_tb/edgedetect_inst/sobel_inst/sr/*

add wave -noupdate -group edgedetect_tb/edgedetect_inst/outgoing
add wave -noupdate -group edgedetect_tb/edgedetect_inst/outgoing -radix hexadecimal /edgedetect_tb/edgedetect_inst/outgoing/*
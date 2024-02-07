history clear
add_file -verilog /home/gfa2226/fpga/edge_detect/uvm/sv/sobel.sv
add_file -verilog /home/gfa2226/fpga/edge_detect/uvm/sv/edgedetect.sv
add_file -verilog /home/gfa2226/fpga/edge_detect/uvm/sv/fifo.sv
add_file -verilog /home/gfa2226/fpga/edge_detect/uvm/sv/grayscale.sv
add_file -verilog /home/gfa2226/fpga/edge_detect/uvm/sv/shift_reg.sv
project -run  
project -close /home/gfa2226/fpga/edge_detect/uvm/syn/proj_1.prj

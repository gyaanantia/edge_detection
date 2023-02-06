import uvm_pkg::*;

interface my_uvm_if;
    logic        clock;
    logic        reset;
    logic        gray_wr_en;
    logic        gray_full;
    logic [23:0] gray_din;
    logic        img_rd_en;
    logic        img_empty;
    logic [7:0]  img_dout;
endinterface

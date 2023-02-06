
import uvm_pkg::*;
import my_uvm_package::*;

`include "my_uvm_if.sv"

`timescale 1 ns / 1 ns

module my_uvm_tb;

    my_uvm_if vif();

    edgedetect #(
        .IMG_HEIGHT(IMG_HEIGHT),
        .IMG_WIDTH(IMG_WIDTH),
        .REG_SIZE(REG_SIZE),
        .FIFO_BUFFER_SIZE(256),
        .IO_FIFO_DATA_WIDTH(IO_FIFO_DATA_WIDTH),
        .INTERNAL_FIFO_DATA_WIDTH(INTERNAL_FIFO_DATA_WIDTH)
    ) edgedetect_inst (
        .clock(vif.clock),
        .reset(vif.reset),
        .gray_wr_en(vif.gray_wr_en),
        .gray_full(vif.gray_full),
        .gray_din(vif.gray_din),
        .img_rd_en(vif.img_rd_en),
        .img_empty(vif.img_empty),
        .img_dout(vif.img_dout)
    );

    initial begin
        // store the vif so it can be retrieved by the driver & monitor
        uvm_resource_db#(virtual my_uvm_if)::set
            (.scope("ifs"), .name("vif"), .val(vif));

        // run the test
        run_test("my_uvm_test");        
    end

    // reset
    initial begin
        vif.clock <= 1'b1;
        vif.reset <= 1'b0;
        @(posedge vif.clock);
        vif.reset <= 1'b1;
        @(posedge vif.clock);
        vif.reset <= 1'b0;
    end

    // 10ns clock
    always
        #(CLOCK_PERIOD/2) vif.clock = ~vif.clock;
endmodule







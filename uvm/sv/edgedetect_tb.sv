
`timescale 1 ns / 1 ns

module edgedetect_tb;

localparam string IMG_IN_NAME  = "image.bmp";
localparam string IMG_OUT_NAME = "output.bmp";
localparam string IMG_CMP_NAME = "stage2_sobel.bmp";
localparam CLOCK_PERIOD = 10;

logic clock = 1'b1;
logic reset = '0;
logic start = '0;
logic done  = '0;

logic        gray_full;
logic        gray_wr_en  = '0;
logic [23:0] gray_din    = '0;
logic        img_rd_en;
logic        img_empty;
logic  [7:0] img_dout;

logic   hold_clock    = '0;
logic   in_write_done = '0;
logic   out_read_done = '0;
integer out_errors    = '0;

localparam WIDTH = 720;
localparam HEIGHT = 540;
localparam REG_SIZE = (WIDTH * 2) + 3;
localparam FIFO_BUFFER_SIZE = 256;
localparam IO_FIFO_DATA_WIDTH = 24;
localparam INTERNAL_FIFO_DATA_WIDTH = 8;
localparam BMP_HEADER_SIZE = 54;
localparam BYTES_PER_PIXEL = 3;
localparam BMP_DATA_SIZE = WIDTH*HEIGHT*BYTES_PER_PIXEL;

edgedetect #(
    .IMG_WIDTH(WIDTH),
    .IMG_HEIGHT(HEIGHT),
    .REG_SIZE(REG_SIZE),
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .IO_FIFO_DATA_WIDTH(IO_FIFO_DATA_WIDTH),
    .INTERNAL_FIFO_DATA_WIDTH(INTERNAL_FIFO_DATA_WIDTH)
) edgedetect_inst (
    .clock(clock),
    .reset(reset),
    .gray_full(gray_full),
    .gray_wr_en(gray_wr_en),
    .gray_din(gray_din),
    .img_empty(img_empty),
    .img_rd_en(img_rd_en),
    .img_dout(img_dout)
);

always begin
    clock = 1'b1;
    #(CLOCK_PERIOD/2);
    clock = 1'b0;
    #(CLOCK_PERIOD/2);
end

initial begin
    @(posedge clock);
    reset = 1'b1;
    @(posedge clock);
    reset = 1'b0;
end

initial begin : tb_process
    longint unsigned start_time, end_time;

    @(negedge reset);
    @(posedge clock);
    start_time = $time;

    // start
    $display("@ %0t: Beginning simulation...", start_time);
    start = 1'b1;
    @(posedge clock);
    start = 1'b0;

    wait(out_read_done);
    end_time = $time;

    // report metrics
    $display("@ %0t: Simulation completed.", end_time);
    $display("Total simulation cycle count: %0d", (end_time-start_time)/CLOCK_PERIOD);
    $display("Total error count: %0d", out_errors);

    // end the simulation
    $finish;
end

initial begin : img_read_process
    int i, r;
    int in_file;
    logic [7:0] bmp_header [0:BMP_HEADER_SIZE-1];

    @(negedge reset);
    $display("@ %0t: Loading file %s...", $time, IMG_IN_NAME);

    in_file = $fopen(IMG_IN_NAME, "rb");
    gray_wr_en = 1'b0;

    // Skip BMP header
    r = $fread(bmp_header, in_file, 0, BMP_HEADER_SIZE);

    // Read data from image file
    i = 0;
    while ( i < BMP_DATA_SIZE ) begin
        @(negedge clock);
        gray_wr_en = 1'b0;
        if (gray_full == 1'b0) begin
            r = $fread(gray_din, in_file, BMP_HEADER_SIZE+i, BYTES_PER_PIXEL);
            gray_wr_en = 1'b1;
            i += BYTES_PER_PIXEL;
        end
    end

    @(negedge clock);
    gray_wr_en = 1'b0;
    $fclose(in_file);
    in_write_done = 1'b1;
end

initial begin : img_write_process
    int i, r;
    int out_file;
    int cmp_file;
    logic [23:0] cmp_dout;
    logic [7:0] bmp_header [0:BMP_HEADER_SIZE-1];

    @(negedge reset);
    @(negedge clock);

    $display("@ %0t: Comparing file %s...", $time, IMG_OUT_NAME);
    
    out_file = $fopen(IMG_OUT_NAME, "wb");
    cmp_file = $fopen(IMG_CMP_NAME, "rb");
    img_rd_en = 1'b0;
    
    // Copy the BMP header
    r = $fread(bmp_header, cmp_file, 0, BMP_HEADER_SIZE);
    for (i = 0; i < BMP_HEADER_SIZE; i++) begin
        $fwrite(out_file, "%c", bmp_header[i]);
    end

    i = 0;
    while (i < BMP_DATA_SIZE) begin
        @(negedge clock);
        img_rd_en = 1'b0;
        if (img_empty == 1'b0) begin
            r = $fread(cmp_dout, cmp_file, BMP_HEADER_SIZE+i, BYTES_PER_PIXEL);
            $fwrite(out_file, "%c%c%c", img_dout, img_dout, img_dout);

            if (cmp_dout != {3{img_dout}}) begin
                out_errors += 1;
                $write("@ %0t: %s(%0d): ERROR: %x != %x at address 0x%x.\n", $time, IMG_OUT_NAME, i+1, {3{img_dout}}, cmp_dout, i);
            end
            img_rd_en = 1'b1;
            i += BYTES_PER_PIXEL;
        end
    end

    @(negedge clock);
    img_rd_en = 1'b0;
    $fclose(out_file);
    $fclose(cmp_file);
    out_read_done = 1'b1;
end

endmodule

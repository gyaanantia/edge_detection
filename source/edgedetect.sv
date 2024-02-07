module edgedetect #(
    parameter IMG_HEIGHT = 540,
    parameter IMG_WIDTH = 720,
    parameter REG_SIZE = (IMG_WIDTH * 2) + 3,
    parameter FIFO_BUFFER_SIZE = 1024,
    parameter IO_FIFO_DATA_WIDTH = 24,
    parameter INTERNAL_FIFO_DATA_WIDTH = 8
)
(
    input   logic           clock,
    input   logic           reset,

    input   logic           gray_wr_en,
    output  logic           gray_full,
    input   logic   [23:0]  gray_din,

    input   logic           img_rd_en,
    output  logic           img_empty,
    output  logic   [7:0]   img_dout
);

logic gray_rd_en;
logic [23:0] gray_dout;
logic gray_empty;
logic [7:0]sobel_din;
logic sobel_full;
logic sobel_wr_en;
logic sobel_rd_en;
logic [7:0] sobel_dout;
logic sobel_empty;
logic img_out_wr_en;
logic img_out_full;
logic [7:0] img_out_din;
logic sobel_done;

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(IO_FIFO_DATA_WIDTH)
) incoming (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(gray_wr_en),
    .din(gray_din),
    .full(gray_full),
    .rd_clk(clock),
    .rd_en(gray_rd_en),
    .dout(gray_dout),
    .empty(gray_empty)
);

grayscale gray (
    .clock(clock),
    .reset(reset),
    .in_dout(gray_dout),
    .in_rd_en(gray_rd_en),
    .in_empty(gray_empty),
    .out_din(sobel_din),
    .out_full(sobel_full),
    .out_wr_en(sobel_wr_en)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(INTERNAL_FIFO_DATA_WIDTH)
) sobel_fifo (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(sobel_wr_en),
    .din(sobel_din),
    .full(sobel_full),
    .rd_clk(clock),
    .rd_en(sobel_rd_en),
    .dout(sobel_dout),
    .empty(sobel_empty)
);

sobel #(
    .IMG_HEIGHT(IMG_HEIGHT),
    .IMG_WIDTH(IMG_WIDTH),
    .REG_SIZE(REG_SIZE)
) sobel_inst (
    .clock(clock),
    .reset(reset),
    .gray_rd_en(sobel_rd_en),
    .gray_empty(sobel_empty),
    .gray_dout(sobel_dout),
    .img_out_wr_en(img_out_wr_en),
    .img_out_full(img_out_full),
    .img_out_din(img_out_din),
    .done(sobel_done)
);

fifo #(
    .FIFO_BUFFER_SIZE(FIFO_BUFFER_SIZE),
    .FIFO_DATA_WIDTH(INTERNAL_FIFO_DATA_WIDTH)
) outgoing (
    .reset(reset),
    .wr_clk(clock),
    .wr_en(img_out_wr_en),
    .din(img_out_din),
    .full(img_out_full),
    .rd_clk(clock),
    .rd_en(img_rd_en),
    .dout(img_dout),
    .empty(img_empty)
);

endmodule
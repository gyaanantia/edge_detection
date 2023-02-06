`ifndef __GLOBALS__
`define __GLOBALS__

// UVM Globals
localparam string IMG_IN_NAME  = "image.bmp";
localparam string IMG_OUT_NAME = "output.bmp";
localparam string IMG_CMP_NAME = "stage2_sobel.bmp";
localparam int IMG_WIDTH = 720;
localparam int IMG_HEIGHT = 540;
localparam int REG_SIZE = (IMG_WIDTH * 2) + 3;
localparam int FIFO_BUFFER_SIZE = 256;
localparam int IO_FIFO_DATA_WIDTH = 24;
localparam int INTERNAL_FIFO_DATA_WIDTH = 8;
localparam int BMP_HEADER_SIZE = 54;
localparam int BYTES_PER_PIXEL = 3;
localparam int BMP_DATA_SIZE = (IMG_WIDTH * IMG_HEIGHT * BYTES_PER_PIXEL);
localparam int CLOCK_PERIOD = 10;

`endif

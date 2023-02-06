module sobel #(
    parameter IMG_HEIGHT = 720,
    parameter IMG_WIDTH = 540
)
(
    input  logic        clock,
    input  logic        reset,

    output logic        row_1_rd_en,
    input  logic        row_1_empty,
    input  logic [7:0]  row_1_dout,

    output logic        row_2_rd_en,
    input  logic        row_2_empty,
    input  logic [7:0]  row_2_dout,

    output logic        row_3_rd_en,
    input  logic        row_3_empty,
    input  logic [7:0]  row_3_dout,

    output logic        row_1_wr_en,
    input  logic        row_1_full,
    output logic [7:0]  row_1_out_din,

    output logic        row_2_wr_en,
    input  logic        row_2_full,
    output logic [7:0]  row_2_out_din,

    input  logic        row_3_full,

    output logic        img_out_wr_en,
    input  logic        img_out_full,
    output logic [7:0]  img_out_din
);

// three FIFOs -- one for each row
// each FIFO -- when all not empty -- feeds into a shift reg
// do sobel convolution for the shift reg contents
// output that convolution
// only read from the fifo when its full that way the box is in the correct position

typedef enum logic [2:0] {s0, s1, s2, s3, s4, s5} state_types;
state_types state, state_c;

logic shift_en;
logic [8:0] [7:0] sr_dout;
logic [1:0] count, count_c;

shift3_3 sr (
    .clock(clock),
    .reset(reset),
    .shift_en(shift_en),
    .pixel_in_row_1(row_1_dout),
    .pixel_in_row_2(row_2_dout),
    .pixel_in_row_3(row_3_dout),
    .pixels_out(sr_dout)
);

always_ff @(posedge clock or posedge reset) begin 
    if (reset == 1'b1) begin
        state <= s0;
        count <= '0;
    end else begin
        state <= state_c;
        count <= count_c;
    end
end

always_comb begin 
    row_1_rd_en = 1'b0;
    row_2_rd_en = 1'b0;
    row_3_rd_en = 1'b0;
    row_1_wr_en = 1'b0;
    row_1_out_din = 8'b0;
    row_2_wr_en = 1'b0;
    row_2_out_din = 8'b0;
    img_out_wr_en = 1'b0;
    img_out_din = 8'b0;

    case (state)
        s0: begin
            if (row_3_full == 1'b1) begin // might have to split this cycle and say if its full read from it then write to it
                row_3_rd_en = 1'b1;
                shift_en = 1'b1;
                count_c = count + 1;
            end
            
            state_c = (count == 2'b11) ? s1 : s0;
        end

        s1: begin
            row_2_wr_en = 1'b1;
            row_2_out_din = sr_dout[2][2];
            row_3_rd_en = 1'b1;
            shift_en = 1'b1;

            state_c = (row_2_full == 1'b1) ? s2 : s1;
        end
        
    endcase
end

endmodule
module sobel #(
    parameter IMG_HEIGHT = 720,
    parameter IMG_WIDTH = 540,
    parameter REG_SIZE = (IMG_WIDTH * 2) + 3
)
(
    input  logic        clock,
    input  logic        reset,

    output logic        gray_rd_en,
    input  logic        gray_empty,
    input  logic        gray_dout,

    output logic        img_out_wr_en,
    input  logic        img_out_full,
    output logic [7:0]  img_out_din,

    output logic        done
);

typedef enum logic [1:0] {s0, s1, s2} state_types;
state_types state, state_c;

logic shift_en, done_c;
logic [7:0] [7:0] sr_dout;
integer count = 0;
integer horiz, vert;

shift_reg sr (
    .clock(clock),
    .reset(reset),
    .shift_en(shift_en),
    .pixel_in(gray_dout),
    .pixels_out(sr_dout)
);

always_ff @(posedge clock or posedge reset) begin 
    if (reset == 1'b1) begin
        state <= s0;
        done <= 1'b0;
    end else begin
        state <= state_c;
        done <= done_c;
    end
end

always_comb begin 
    gray_rd_en = 1'b0;
    img_out_wr_en = 1'b0;
    img_out_din = 8'b0;
    done_c = 1'b0;

    case (state)
        s0: begin
            if (gray_empty == 1'b0 && img_out_full == 1'b0) begin
                done_c = 1'b0;
                gray_rd_en = 1'b1;
                shift_en = 1'b1;
                count = count + 1;
                if (count >= REG_SIZE - 2 - IMG_WIDTH) begin
                    img_out_wr_en = 1'b1;
                    img_out_din = 8'b0;
                end
                state_c = (count < REG_SIZE) ? s0 : s1;
            end
        end

        s1: begin
            if (gray_empty == 1'b0 && img_out_full == 1'b0) begin
                horiz = -sr_dout[7] + -(sr_dout[6] << 1) + -sr_dout[5] + sr_dout[2] + (sr_dout[1] << 1) + sr_dout[0];
                vert = -sr_dout[7] + sr_dout[5] + -(sr_dout[4] << 1) + (sr_dout[3] << 1) + -sr_dout[2] + sr_dout[0];
                img_out_wr_en = 1'b1;
                horiz = (horiz < 0) ? -horiz : horiz;
                vert = (vert < 0) ? -vert : vert;

                if (count % IMG_WIDTH - 1 == 0 || count % IMG_WIDTH == 0) begin
                    img_out_din = 8'b0;
                end else begin
                    img_out_din = (horiz + vert > 255) ? 8'd255 : 8'(horiz + vert);
                end
                count = count + 1;
                gray_rd_en = 1'b1;
                shift_en = 1'b1;

                state_c = (count > ((IMG_HEIGHT - 1) * IMG_WIDTH)) ? s2 : s1;
            end
        end

        s2: begin
            if (img_out_full == 1'b0) begin
                img_out_wr_en = 1'b1;
                img_out_din = 8'b0;
                count = count + 1;
                state_c = (count < (IMG_HEIGHT * IMG_WIDTH)) ? s2 : s0;
                done_c = (count < (IMG_HEIGHT * IMG_WIDTH)) ? 1'b0 : 1'b1;
            end
        end
    endcase
end

endmodule
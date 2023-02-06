module shift_reg #(
    parameter IMG_WIDTH = 540,
    parameter REG_SIZE = (IMG_WIDTH * 2) + 3
)
(
    input  logic             clock,
    input  logic             reset,
    input  logic             shift_en,
    input  logic [7:0]       pixel_in,
    output logic [7:0] [7:0] pixels_out
);

reg [REG_SIZE-1:0] [7:0] sr;

always_ff @(posedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        for (int i=0; i < REG_SIZE; i=i+1) sr[i] <= 8'b0;
    end else if (shift_en == 1'b1) begin
        sr[REG_SIZE-1:1] <= sr[REG_SIZE-2:0];
        sr[0] <= pixel_in;
    end else begin
        sr <= sr;
    end
end

assign pixels_out = '{sr[REG_SIZE-1], sr[REG_SIZE-2], sr{REG_SIZE-3},
                      sr[REG_SIZE-1-IMG_WIDTH], sr[REG_SIZE-3-IMG_WIDTH],
                      sr[2], sr[1], sr[0]};

endmodule
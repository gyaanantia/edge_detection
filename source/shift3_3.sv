module shift3_3 (
    input  logic             clock,
    input  logic             reset,
    input  logic             shift_en,
    input  logic [7:0]       pixel_in_row_1,
    input  logic [7:0]       pixel_in_row_2,
    input  logic [7:0]       pixel_in_row_3,
    output logic [8:0] [7:0] pixels_out
);

reg [2:0] [7:0] row_1, row_2, row_3;

always_ff @(posedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        row_1 <= '{'0, '0, '0};
        row_2 <= '{'0, '0, '0};
        row_3 <= '{'0, '0, '0};
    end else if (shift_en == 1'b1) begin
        row_1[2:1] <= row_1[1:0];
        row_1[0] <= pixel_in_row_1;

        row_2[2:1] <= row_2[1:0];
        row_2[0] <= pixel_in_row_2;

        row_3[2:1] <= row_3[1:0];
        row_3[0] <= pixel_in_row_3;
    end else begin
        row_1 <= row_1;
        row_2 <= row_2;
        row_3 <= row_3;
    end
end

assign pixels_out = '{'row_1, 'row_2, 'row_3};

endmodule;
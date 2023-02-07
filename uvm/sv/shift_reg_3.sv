module shift_reg_3 (
    input  logic             clock,
    input  logic             reset,
    input  logic             shift_en,
    input  logic [7:0]       pixel_in,
    output logic [7:0]       pixel_out
);

logic [2:0] [7:0] sr;

always_ff @(posedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        for (int i=0; i < 3; i=i+1) sr[i] <= 8'b0;
    end else if (shift_en == 1'b1) begin
        sr[2:1] <= sr[1:0];
        sr[0] <= pixel_in;
    end else begin
        sr <= sr;
    end
end

assign pixels_out = {sr[2], sr[1], sr[0]};

endmodule
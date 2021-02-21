`ifdef IVERILOG
`include "src/core/define.vh"
`else
`include "define.vh"
`endif

module brcomp #(
    parameter DATAW = 32
) (
    input [2:0] funct3,
    input [DATAW-1:0] a,
    input [DATAW-1:0] b,
    output taken
);

wire signed [DATAW-1:0] a_s;
wire signed [DATAW-1:0] b_s;
assign a_s = a;
assign b_s = b;

reg taken_r;
assign taken = taken_r;

always @(*) begin
    case (funct3)
        `BR_EQ  : taken_r = (a == b);
        `BR_NE  : taken_r = (a != b);
        `BR_LT  : taken_r = (a_s <  b_s);
        `BR_GE  : taken_r = (a_s >= b_s);
        `BR_LTU : taken_r = (a <  b);
        `BR_GEU : taken_r = (a >= b);
        default : taken_r = 1'b0;
    endcase
end

endmodule
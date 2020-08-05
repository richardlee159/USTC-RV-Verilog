// DATAW bits register (DFF), synchronous reset

module register #(
    parameter DATAW = 32,
    parameter RST_VALUE = 'b0
) (
    input                clk,
    input                rst,
    input                wr_en,     // write enable
    input   [DATAW-1:0]  dnxt,      // next data
    output  [DATAW-1:0]  qout       // current value
);

reg [DATAW-1:0] qout_r;
assign qout = qout_r;
always @(posedge clk) begin
    if (rst == 1'b1)
        qout_r <= RST_VALUE;
    else if (wr_en == 1'b1)
        qout_r <= dnxt;
end

endmodule
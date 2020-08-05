`include "src/core/alu.v"

module alu_tb;

reg [31:0] a, b;
reg [3:0] sel;
wire [31:0] out;
parameter PERIOD = 10;

alu alu0
(
    .a  (a),
    .b  (b),
    .sel(sel),
    .out(out)
);

initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
end

initial begin
    a = 32'hA0701581;
    b = 32'h5;
    sel = 4'h0;
    repeat(16) begin
        # PERIOD
        sel = sel + 1;
    end
    $finish;
end

endmodule
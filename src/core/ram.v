module ram #(
    parameter ADDRW = 10,
    parameter DATAW = 8
) (
    input               clk,
    input               we,
    input   [ADDRW-1:0] addr,
    input   [DATAW-1:0] wdata,
    output  [DATAW-1:0] rdata
);

localparam SIZE = 1 << ADDRW;
reg [DATAW-1:0] mem [0:SIZE-1];

assign rdata = mem[addr];
always @(posedge clk) begin
    if (we == 1'b1)
        mem[addr] <= wdata;
end

endmodule
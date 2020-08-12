// DATAW * 2^ADDRW bit RAM (default 4KB), single port,
// with byte write enable control signal (be)

`include "src/core/macro.v"

module ram #(
    parameter ADDRW = 10,
    parameter DATAW = 32,
    parameter DATAB = DATAW / `BYTEW
) (
    input               clk,
    input               we,         // write enable
    input   [DATAB-1:0] be,         // byte enable
    input   [ADDRW-1:0] addr,
    input   [DATAW-1:0] wdata,
    output  [DATAW-1:0] rdata
);

localparam SIZE = 1 << ADDRW;
reg [DATAW-1:0] mem [0:SIZE-1];

// asynchronous read
assign rdata = mem[addr];

// synchronous write
wire [DATAW-1:0] wdata_real;

genvar i;
generate
    for (i = 0; i < DATAB; i = i + 1) begin
        assign wdata_real[(i+1)*`BYTEW-1:i*`BYTEW] =
            be[i] ? wdata[(i+1)*`BYTEW-1:i*`BYTEW] :
                    rdata[(i+1)*`BYTEW-1:i*`BYTEW] ;
    end
endgenerate

always @(posedge clk) begin
    if (we == 1'b1)
        mem[addr] <= wdata_real;
end

endmodule
`ifdef IVERILOG
`include "src/config.vh"
`else
`include "config.vh"
`endif

module rom #(
    parameter DEPTH = 1024
) (
    input                   clk,
    input                   xbus_cs,
    input                   xbus_we,
    input   [`XBYTEC-1:0]   xbus_be,
    input   [`XADDRW-1:0]   xbus_addr,
    input   [`XDATAW-1:0]   xbus_wdata,
    output  [`XDATAW-1:0]   xbus_rdata
);

localparam ADDRW = $clog2(DEPTH);

reg [`XDATAW-1:0] mem [0:DEPTH-1];
`ifdef IVERILOG
initial $readmemh("src/rom.mem", mem);
`else
initial $readmemh("rom.mem", mem);
`endif

wire [ADDRW-1:0] addr = xbus_addr[ADDRW+1:2];

reg [`XDATAW-1:0] rdata;
assign xbus_rdata = rdata;

always @(posedge clk) begin
    if (xbus_cs)
        rdata <= mem[addr];
end

endmodule
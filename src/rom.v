module rom (
    input               clk,
    input               xbus_cs,
    input               xbus_we,
    input   [3:0]       xbus_be,
    input   [31:0]      xbus_addr,
    input   [31:0]      xbus_wdata,
    output  [31:0]      xbus_rdata
);

reg [31:0] mem [0:63];
`ifdef IVERILOG
initial $readmemh("src/rom.mem", mem);
`else
initial $readmemh("rom.mem", mem);
`endif

wire [5:0] addr = xbus_addr[7:2];

reg [31:0] rdata;
assign xbus_rdata = rdata;

always @(posedge clk) begin
    if (xbus_cs)
        rdata <= mem[addr];
end

endmodule
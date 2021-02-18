module rom (
    input               xbus_cs,
    input               xbus_we,
    input   [3:0]       xbus_be,
    input   [31:0]      xbus_addr,
    input   [31:0]      xbus_wdata,
    output  [31:0]      xbus_rdata
);

reg [31:0] mem [0:63];
initial $readmemh("src/rom.data", mem);

wire [5:0] addr = xbus_addr[7:2];

assign xbus_rdata = mem[addr];

endmodule
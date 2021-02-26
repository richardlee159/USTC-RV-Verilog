`ifdef IVERILOG
`include "src/config.vh"
`else
`include "config.vh"
`endif

module xbus_decoder (
    input                       xbus_as,
    input   [`XADDRW-1:0]       xbus_addr,
    output  [`XSLAVE_CH-1:0]    xbus_cs
);

reg [`XSLAVE_CH-1:0] xbus_cs_r;
assign xbus_cs = xbus_cs_r;

always @(*) begin
    xbus_cs_r = `XSLAVE_CH'b0;
    if (xbus_as) begin
        xbus_cs_r[0] = (xbus_addr >= 32'h00001000) && (xbus_addr < 32'h00001100);
        xbus_cs_r[1] = (xbus_addr >= 32'h80000000) && (xbus_addr < 32'h80010000);
        xbus_cs_r[2] = (xbus_addr >= 32'h10000000) && (xbus_addr < 32'h10000008);
        xbus_cs_r[3] = (xbus_addr >= 32'h00010000) && (xbus_addr < 32'h00010004);
    end
end
    
endmodule
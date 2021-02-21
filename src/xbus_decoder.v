`define NSLAVES 4

module xbus_decoder (
    input                   xbus_as,
    input   [31:0]          xbus_addr,
    output  [`NSLAVES-1:0]  xbus_cs
);

reg [`NSLAVES-1:0] xbus_cs_r;
assign xbus_cs = xbus_cs_r;

always @(*) begin
    xbus_cs_r = `NSLAVES'b0;
    if (xbus_as) begin
        xbus_cs_r[0] = (xbus_addr >= 32'h00001000) && (xbus_addr < 32'h00001100);
        xbus_cs_r[1] = (xbus_addr >= 32'h80000000) && (xbus_addr < 32'h80010000);
        xbus_cs_r[2] = (xbus_addr >= 32'h00010000) && (xbus_addr < 32'h00010004);
    end
end
    
endmodule
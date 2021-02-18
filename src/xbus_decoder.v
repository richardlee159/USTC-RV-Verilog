`define NSLAVES 4

module xbus_decoder (
    input                   xbus_as,
    input   [31:0]          xbus_addr,
    output  [`NSLAVES-1:0]  xbus_cs
);

reg [`NSLAVES-1:0] xbus_cs;

always @(*) begin
    xbus_cs = `NSLAVES'b0;
    if (xbus_as) begin
        xbus_cs[0] = (xbus_addr >= 32'h00001000) && (xbus_addr < 32'h00001100);
        xbus_cs[1] = (xbus_addr >= 32'h80000000) && (xbus_addr < 32'h80010000);
    end
end
    
endmodule
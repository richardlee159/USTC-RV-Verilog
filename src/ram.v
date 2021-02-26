`define BYTEW 8

module ram (
    input               clk,
    input               xbus_cs,
    input               xbus_we,
    input   [3:0]       xbus_be,
    input   [31:0]      xbus_addr,
    input   [31:0]      xbus_wdata,
    output  [31:0]      xbus_rdata
);

reg [31:0] mem [0:4095];

wire [11:0] addr = xbus_addr[13:2];

// synchronous read
reg [31:0] rdata;
assign xbus_rdata = rdata;
always @(posedge clk) begin
    if (xbus_cs)
        rdata <= mem[addr];
end

// synchronous write
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        always @(posedge clk) begin
            if (xbus_cs && xbus_we && xbus_be[i])
                mem[addr][(i+1)*`BYTEW-1:i*`BYTEW]
                <= xbus_wdata[(i+1)*`BYTEW-1:i*`BYTEW];
        end
    end
endgenerate

endmodule
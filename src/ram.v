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

// asynchronous read
assign xbus_rdata = mem[addr];

// synchronous write
wire [31:0] wdata;

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        assign wdata[(i+1)*`BYTEW-1:i*`BYTEW] = xbus_be[i] ? 
          xbus_wdata[(i+1)*`BYTEW-1:i*`BYTEW] :
          xbus_rdata[(i+1)*`BYTEW-1:i*`BYTEW] ;
    end
endgenerate

always @(posedge clk) begin
    if (xbus_cs && xbus_we)
        mem[addr] <= wdata;
end

endmodule
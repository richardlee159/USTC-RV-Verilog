`ifdef IVERILOG
`include "src/config.vh"
`else
`include "config.vh"
`endif

module sw_led (
    input                   clk,
    input                   xbus_cs,
    input                   xbus_we,
    input   [`XBYTEC-1:0]   xbus_be,
    input   [`XADDRW-1:0]   xbus_addr,
    input   [`XDATAW-1:0]   xbus_wdata,
    output  [`XDATAW-1:0]   xbus_rdata,
    input   [7:0]           sw,
    output  [7:0]           led
);

reg [7:0] sw_r;

reg [7:0] led_r;
assign led = led_r;

assign xbus_rdata = {8'b0, sw_r, 8'b0, led_r};

always @(posedge clk) begin
    sw_r <= sw;
    if (xbus_cs && xbus_we && xbus_be[0])
        led_r <= xbus_wdata[7:0];
end
    
endmodule
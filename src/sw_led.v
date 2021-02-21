module sw_led (
    input               clk,
    input               xbus_cs,
    input               xbus_we,
    input   [3:0]       xbus_be,
    input   [31:0]      xbus_addr,
    input   [31:0]      xbus_wdata,
    output  [31:0]      xbus_rdata,
    input   [7:0]       sw,
    output  [7:0]       led
);

reg [7:0] led_r;
assign led = led_r;

assign xbus_rdata = {8'b0, sw, 8'b0, led_r};

always @(posedge clk) begin
    if (xbus_cs && xbus_we && xbus_be[0])
        led_r <= xbus_wdata[7:0];
end
    
endmodule
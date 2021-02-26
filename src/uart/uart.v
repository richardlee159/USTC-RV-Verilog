`ifdef IVERILOG
`include "src/config.vh"
`include "src/uart/uart_rx.v"
`include "src/uart/uart_tx.v"
`else
`include "config.vh"
`endif

module uart (
    input                   clk,
    input                   rst,
    input                   xbus_cs,
    input                   xbus_we,
    input   [`XBYTEC-1:0]   xbus_be,
    input   [`XADDRW-1:0]   xbus_addr,
    input   [`XDATAW-1:0]   xbus_wdata,
    output  [`XDATAW-1:0]   xbus_rdata,
    input                   rx,
    output                  tx
);

wire            tx_start;
wire            tx_ready;
wire            rx_end;
wire    [7:0]   tx_data;
wire    [7:0]   rx_data;

uart_rx uart_rx(
    .clk      (clk      ),
    .rst      (rst      ),
    .rx_end   (rx_end   ),
    .rx_data  (rx_data  ),
    .rx       (rx       )
);

uart_tx uart_tx(
    .clk      (clk      ),
    .rst      (rst      ),
    .tx_start (tx_start ),
    .tx_data  (tx_data  ),
    .tx_ready (tx_ready ),
    .tx       (tx       )
);

wire addr = xbus_addr[2];

assign tx_start = xbus_cs && xbus_we && xbus_be[0] && (addr == 1'b0);
assign tx_data  = xbus_wdata[7:0];

reg rx_ready;
always @(posedge clk or posedge rst) begin
    if (rst)
        rx_ready <= 1'b0;
    else if (rx_end)
        rx_ready <= 1'b1;
    else if (xbus_cs && xbus_be[2] && (addr == 1'b0))
        rx_ready <= 1'b0;
end

reg [`XDATAW-1:0] rdata;
assign xbus_rdata = rdata;
always @(*) begin
    case (addr)
        1'b0: rdata = {8'b0, rx_data, 8'b0, tx_data};
        1'b1: rdata = {30'b0, rx_ready, tx_ready};
    endcase
end

endmodule
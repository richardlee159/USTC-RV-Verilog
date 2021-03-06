`ifdef IVERILOG
`include "src/config.vh"
`include "src/core/core.v"
`include "src/ram.v"
`include "src/rom.v"
`include "src/sw_led.v"
`include "src/uart/uart.v"
`include "src/xbus_decoder.v"
`else
`include "config.vh"
`endif

module soc (
    input           clk,
    input           rst,
    input           rx,
    output          tx,
    input   [7:0]   sw,
    output  [7:0]   led
);

reg core_clk;
initial core_clk <= 1'b0;
always @(posedge clk) core_clk <= ~core_clk;

wire                    xbus_as;
wire                    xbus_we;
wire [`XBYTEC-1:0]      xbus_be;
wire [`XADDRW-1:0]      xbus_addr;
wire [`XDATAW-1:0]      xbus_wdata;
wire [`XDATAW-1:0]      xbus_rdata;
wire [`XDATAW-1:0]      xbus_slave_rdata [0:`XSLAVE_CH-1];

wire [`XSLAVE_CH-1:0]   xbus_cs;

xbus_decoder xbus_decoder(
    .xbus_as   (xbus_as   ),
    .xbus_addr (xbus_addr ),
    .xbus_cs   (xbus_cs   )
);

assign xbus_rdata = {`XDATAW{xbus_cs[0]}} & xbus_slave_rdata[0]
                  | {`XDATAW{xbus_cs[1]}} & xbus_slave_rdata[1]
                  | {`XDATAW{xbus_cs[2]}} & xbus_slave_rdata[2]
                  | {`XDATAW{xbus_cs[3]}} & xbus_slave_rdata[3];

core #(
    .PC_RSTVAL  (32'h1000   )
)
core(
    .clk        (core_clk   ),
    .rst        (rst        ),
    .xbus_as    (xbus_as    ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_rdata )
);

rom #(
    .DEPTH      (64         )
)
rom(
    .clk        (clk        ),
    .xbus_cs    (xbus_cs[0] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_slave_rdata[0] )
);

ram #(
    .DEPTH      (4096       )
)
ram(
    .clk        (clk        ),
    .xbus_cs    (xbus_cs[1] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_slave_rdata[1] )
);

uart uart(
    .clk        (clk        ),
    .rst        (rst        ),
    .xbus_cs    (xbus_cs[2] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_slave_rdata[2] ),
    .rx         (rx         ),
    .tx         (tx         )
);

sw_led sw_led(
    .clk        (clk        ),
    .xbus_cs    (xbus_cs[3] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_slave_rdata[3] ),
    .sw         (sw         ),
    .led        (led        )
);

endmodule
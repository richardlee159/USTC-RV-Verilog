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

wire        xbus_as;
wire        xbus_we;
wire [3:0]  xbus_be;
wire [31:0] xbus_addr;
wire [31:0] xbus_wdata;
reg  [31:0] xbus_rdata;
wire [31:0] xbus_slave_rdata [0:3];

wire [`NSLAVES-1:0]xbus_cs;

xbus_decoder xbus_decoder(
    .xbus_as   (xbus_as   ),
    .xbus_addr (xbus_addr ),
    .xbus_cs   (xbus_cs   )
);

always @(*) begin
    case (xbus_cs)
        `NSLAVES'b0001: xbus_rdata = xbus_slave_rdata[0];
        `NSLAVES'b0010: xbus_rdata = xbus_slave_rdata[1];
        `NSLAVES'b0100: xbus_rdata = xbus_slave_rdata[2];
        `NSLAVES'b1000: xbus_rdata = xbus_slave_rdata[3];
        default: xbus_rdata = 0;
    endcase
end

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

rom rom(
    .clk        (clk        ),
    .xbus_cs    (xbus_cs[0] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_slave_rdata[0] )
);

ram ram(
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
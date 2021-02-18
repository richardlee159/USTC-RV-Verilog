`include "src/core/core.v"
`include "src/ram.v"
`include "src/xbus_decoder.v"

module soc (
    input       clk,
    input       rst
);

wire        xbus_as;
wire        xbus_we;
wire [3:0]  xbus_be;
wire [31:0] xbus_addr;
wire [31:0] xbus_wdata;
wire [31:0] xbus_rdata;

wire [`NSLAVES-1:0]xbus_cs;

xbus_decoder xbus_decoder(
    .xbus_as   (xbus_as   ),
    .xbus_addr (xbus_addr ),
    .xbus_cs   (xbus_cs   )
);

core #(
    .PC_RSTVAL  (32'h0000   )
)
core(
    .clk        (clk        ),
    .rst        (rst        ),
    .xbus_as    (xbus_as    ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_rdata )
);

ram ram(
    .clk        (clk        ),
    .xbus_cs    (xbus_cs[0] ),
    .xbus_we    (xbus_we    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_rdata )
);

endmodule
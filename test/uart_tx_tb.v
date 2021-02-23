`include "src/uart/uart_tx.v"

module uart_tx_tb;
reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;
wire tx_ready;
wire tx;

uart_tx uart_tx(
    .clk      (clk      ),
    .rst      (rst      ),
    .tx_start (tx_start ),
    .tx_data  (tx_data  ),
    .tx_ready (tx_ready ),
    .tx       (tx       )
);

localparam CLK_PERIOD = 10;
initial clk <= 0;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0, uart_tx_tb);
end

initial begin
    rst <= 1;
    repeat(2)  @(posedge clk);
    rst <= 0;
    repeat(8) @(posedge clk);
    tx_data <= 8'h6A;
    tx_start <= 1;
    repeat(2) @(posedge clk);
    tx_start <= 0;
    repeat(20000) @(posedge clk);
    $finish;
end

endmodule
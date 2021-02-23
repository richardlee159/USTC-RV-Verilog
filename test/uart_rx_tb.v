`include "src/uart/uart_rx.v"

module uart_rx_tb;
reg clk;
reg rst;
wire rx_end;
wire [7:0] rx_data;
reg rx;

uart_rx uart_rx(
    .clk      (clk      ),
    .rst      (rst      ),
    .rx_end   (rx_end   ),
    .rx_data  (rx_data  ),
    .rx       (rx       )
);

localparam CLK_PERIOD = 10;
initial clk <= 0;
always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0, uart_rx_tb);
end

reg [`UartDivCntW-1:0] div_cnt;
reg [`UartBitCntW-1:0] bit_cnt;
always @(posedge clk) begin
    if (div_cnt == `UartDivCnt)
        div_cnt <= 0;
    else
        div_cnt <= div_cnt + 1;
end
wire tx_pulse = (div_cnt == 0);
wire [7:0] tx_data = 8'h6A;

initial begin
    rst <= 1;
    repeat(2)  @(posedge clk);
    rst <= 0;
    rx <= 1;
    repeat(300) @(posedge clk);
    div_cnt <= 0;
    bit_cnt <= 0;
    @(posedge tx_pulse) rx <= 0;
    @(posedge tx_pulse) rx <= 0;
    @(posedge tx_pulse) rx <= 1;
    @(posedge tx_pulse) rx <= 0;
    @(posedge tx_pulse) rx <= 1;
    @(posedge tx_pulse) rx <= 0;
    @(posedge tx_pulse) rx <= 1;
    @(posedge tx_pulse) rx <= 1;
    @(posedge tx_pulse) rx <= 0;
    @(posedge tx_pulse) rx <= 1;
    repeat(2000) @(posedge clk);
    $finish;
end

endmodule
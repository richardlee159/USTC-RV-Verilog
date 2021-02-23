`ifndef __UART_VH__
`define __UART_VH__

// clk = 100mhz
// bps = 115200
// div = 868

`define     UartDivCntW     10
`define     UartDivCnt      `UartDivCntW'd867
`define     UartBitCntW     4
`define     UartBitCnt      `UartBitCntW'h9

`endif
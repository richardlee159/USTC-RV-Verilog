`ifdef IVERILOG
`include "src/uart/uart.vh"
`else
`include "uart.vh"
`endif

module uart_tx (
    input           clk,
    input           rst,
    input           tx_start,
    input   [7:0]   tx_data,
    output          tx_ready,
    output  reg     tx
);

localparam STATE_IDLE = 1'b0;
localparam STATE_TX   = 1'b1;
    
reg state;
reg [`UartDivCntW-1:0] div_cnt;
reg [`UartBitCntW-1:0] bit_cnt;
reg [7:0] tx_reg;

assign tx_ready = (state == STATE_IDLE);

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= STATE_IDLE;
    else begin
        case (state)
            STATE_IDLE:
                if (tx_start)
                    state <= STATE_TX;
            STATE_TX:
                if ((div_cnt == `UartDivCnt) && (bit_cnt == `UartBitCnt))
                    state <= STATE_IDLE;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if (rst)
        div_cnt <= `UartDivCntW'b0;
    else if (state == STATE_TX) begin
        if (div_cnt == `UartDivCnt)
            div_cnt <= `UartDivCntW'b0;
        else
            div_cnt <= div_cnt + `UartDivCntW'b1;
    end else
        div_cnt <= `UartDivCntW'b0;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        bit_cnt <= `UartBitCntW'b0;
    else if (state == STATE_TX) begin
        if (div_cnt == `UartDivCnt)
            bit_cnt <= bit_cnt + `UartBitCntW'b1;
    end else
        bit_cnt <= `UartBitCntW'b0;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        tx_reg <= 8'b0;
    else if ((state == STATE_IDLE) && (tx_start))
        tx_reg <= tx_data;
end

always @(posedge clk or posedge rst) begin
    if (rst)
        tx <= 1'b1;
    else if (state == STATE_IDLE)
        tx <= 1'b1;
    else if (div_cnt == `UartDivCntW'b0) begin
        case (bit_cnt)
            `UartBitCntW'h0: tx <= 1'b0;
            `UartBitCntW'h9: tx <= 1'b1;
            default:         tx <= tx_reg[bit_cnt-1];
        endcase
    end
end

endmodule
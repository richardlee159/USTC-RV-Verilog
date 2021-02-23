`ifdef IVERILOG
`include "src/uart/uart.vh"
`else
`include "uart.vh"
`endif

module uart_rx (
    input               clk,
    input               rst,
    output  reg         rx_end,
    output  reg  [7:0]  rx_data,
    input               rx
);

localparam STATE_IDLE = 1'b0;
localparam STATE_RX   = 1'b1;    

reg state;
reg [`UartDivCntW-1:0] div_cnt;
reg [`UartBitCntW-1:0] bit_cnt;
reg [7:0] rx_reg;
wire rx_pulse;

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= STATE_IDLE;
    else begin
        case(state)
            STATE_IDLE:
                if (div_cnt == `UartDivCnt/2)
                    state <= STATE_RX;
            STATE_RX:
                if ((div_cnt == `UartDivCnt) && (bit_cnt == `UartBitCnt))
                    state <= STATE_IDLE;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if (rst)
        div_cnt <= `UartBitCntW'b0;
    else begin 
        case (state)
            STATE_IDLE: begin
                if (rx == 1'b1)
                    div_cnt <= `UartBitCntW'b0;
                else if (div_cnt < `UartDivCnt/2)
                    div_cnt <= div_cnt + `UartBitCntW'b1;
                else
                    div_cnt <= `UartBitCntW'b0;
            end
            STATE_RX: begin
                if (div_cnt == `UartDivCnt)
                    div_cnt <= `UartBitCntW'b0;
                else
                    div_cnt <= div_cnt + `UartBitCntW'b1;
            end
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if (rst)
        bit_cnt <= `UartBitCntW'b0;
    else begin
        case (state)
            STATE_IDLE:
                if (div_cnt == `UartDivCnt/2)
                    bit_cnt <= `UartBitCntW'b1;
                else
                    bit_cnt <= `UartBitCntW'b0;
            STATE_RX:
                if (div_cnt == `UartDivCnt)
                    bit_cnt <= bit_cnt + 1'b1;
        endcase
    end
end

assign rx_pulse = (state == STATE_RX) && (div_cnt == `UartDivCnt);

always @(posedge clk) begin
    if (rx_pulse && (bit_cnt < `UartBitCnt))
        rx_reg[bit_cnt-1] <= rx;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_end <= 1'b0;
        rx_data <= 8'b0;
    end else if (rx_pulse && (bit_cnt == `UartBitCnt) && (rx == 1'b1)) begin
        rx_end <= 1'b1;
        rx_data <= rx_reg;
    end else
        rx_end <= 1'b0;
end

endmodule
`timescale 1ns/1ps

`include "src/soc.v"

`define TEST_A
`define TEST_B
`define TEST_C

module soc_tb;
reg clk;
reg rst;
reg  rx;
wire tx;
reg  [7:0] sw;
wire [7:0] led;

soc soc(
    .clk (clk ),
    .rst (rst ),
    .rx  (rx  ),
    .tx  (tx  ),
    .sw  (sw  ),
    .led (led )
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("soc_tb.vcd");
    $dumpvars(0, soc_tb);
end

initial begin

`ifdef TEST_A

    rst<=1;
    clk<=0;
    repeat(2) @(posedge clk);
    rst<=0;

    $readmemh("test/core/RISCV_RV32I_TEST/testA_InstructionStream.txt",
                soc.ram.mem);

    repeat(20000) @(posedge clk) begin
        if (soc.core.pc == 32'h800022C8) begin
            $display("### TestA FAIL! ###");
            $finish;
        end
        else if (soc.core.pc == 32'h800022CC) begin
            $display("### TestA PASS! ###");
        end
    end

`endif
`ifdef TEST_B

    rst<=1;
    clk<=0;
    repeat(2) @(posedge clk);
    rst<=0;

    $readmemh("test/core/RISCV_RV32I_TEST/testB_InstructionStream.txt",
                soc.ram.mem);

    repeat(20000) @(posedge clk) begin
        if (soc.core.pc == 32'h80002A78) begin
            $display("### TestB FAIL! ###");
            $finish;
        end
        else if (soc.core.pc == 32'h80002A7C) begin
            $display("### TestB PASS! ###");
        end
    end

`endif
`ifdef TEST_C

    rst<=1;
    clk<=0;
    repeat(2) @(posedge clk);
    rst<=0;

    $readmemh("test/core/RISCV_RV32I_TEST/testC_InstructionStream.txt",
                soc.ram.mem);

    repeat(20000) @(posedge clk) begin
        if (soc.core.pc == 32'h80002D64) begin
            $display("### TestC FAIL! ###");
            $finish;
        end
        else if (soc.core.pc == 32'h80002D68) begin
            $display("### TestC PASS! ###");
        end
    end

`endif

    $finish;
end

endmodule

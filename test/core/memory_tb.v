`include "src/core/memory.v"

module memory_tb;

localparam CLK_PERIOD = 10;
localparam ADDRW = 10;

reg              clk = 0;
reg              we;
reg              sign;
reg  [1:0]       length;
reg  [ADDRW-1:0] addr;
reg  [31:0]      wdata;
wire [31:0]      rdata;

memory 
#(
    .ADDRW (ADDRW)
)
memory0(
	.clk    (clk    ),
    .we     (we     ),
    .sign   (sign   ),
    .length (length ),
    .addr   (addr   ),
    .wdata  (wdata  ),
    .rdata  (rdata  )
);

always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("memory_tb.vcd");
    $dumpvars(0, memory_tb);
end

initial begin
    we = 1;
    sign = 1;
    length = `LEN_WORD;
    addr = 10'd0;
    wdata = 32'hA74D2F93;

    #CLK_PERIOD
    length = `LEN_BYTE;
    addr = 10'd5;
    wdata = 32'h86;

    #CLK_PERIOD
    we = 0;
    addr = 10'd0;
    
    #CLK_PERIOD
    sign = 0;

    #CLK_PERIOD
    length = `LEN_HALF;

    #CLK_PERIOD
    length = `LEN_WORD;

    #CLK_PERIOD
    $finish;
end

endmodule
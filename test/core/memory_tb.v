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

wire [2:0] funct3 = {sign, length};

memory 
#(
    .ADDRW (ADDRW)
)
memory0(
    .clk    (clk    ),
    .we     (we     ),
    .funct3 (funct3 ),
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
    length = `ML_WORD;
    addr = 10'd0;
    wdata = 32'hA74D2F93;

    #CLK_PERIOD
    length = `ML_BYTE;
    addr = 10'd5;
    wdata = 32'h86;

    #CLK_PERIOD
    we = 0;
    length = `ML_WORD;

    #CLK_PERIOD
    addr = 10'd0;
    length = `ML_BYTE;
    
    #CLK_PERIOD
    sign = 0;

    #CLK_PERIOD
    length = `ML_HALF;

    #CLK_PERIOD
    length = `ML_WORD;

    #CLK_PERIOD
    $finish;
end

endmodule
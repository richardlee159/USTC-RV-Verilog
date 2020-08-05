`include "src/core/regfile.v"

module regfile_tb;
    reg clk;
    reg [4:0] addr_a, addr_b, addr_d;
    reg wr_en;
    reg [31:0] data_d;
    wire [31:0] data_a, data_b;
    
    parameter PERIOD = 10, CYCLE = 64;
    
    regfile regfile_0(clk,wr_en,addr_d,addr_a,addr_b,data_d,data_a,data_b);
    
    initial begin
        clk = 0;
        repeat (2 * CYCLE)
            #(PERIOD/2) clk = ~clk;
        $finish;
    end
    
    initial begin
        addr_d = 0; wr_en = 1;
        addr_a = 5; addr_b = 10;
        repeat (32) begin
            data_d = addr_d * addr_d + 1;
            #PERIOD addr_d = addr_d + 1;
        end
        wr_en = 0;
        repeat (32) begin
            #PERIOD
            addr_a = addr_a + 1;
            addr_b = addr_b + 2;
        end
    end

    initial
    begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, regfile_tb);
    end

endmodule

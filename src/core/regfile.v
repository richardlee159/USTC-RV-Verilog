// 2^ADDRW x DATAW Register File (default 32 x 32)
// x0 is always zero

module regfile #(
    parameter ADDRW = 5,
    parameter DATAW = 32
)(
    input                clk,
    input                wr_en,
    input   [ADDRW-1:0]  addr_d,
    input   [ADDRW-1:0]  addr_a,
    input   [ADDRW-1:0]  addr_b,
    input   [DATAW-1:0]  data_d,
    output  [DATAW-1:0]  data_a,
    output  [DATAW-1:0]  data_b
);

parameter REGCOUNT = 1 << ADDRW;
reg [DATAW-1:0] regs [1:REGCOUNT-1];

// asynchronous read
assign data_a = (addr_a == 'b0) ? 'b0 : regs[addr_a];
assign data_b = (addr_b == 'b0) ? 'b0 : regs[addr_b];

// synchronous write
always @(posedge clk) begin
    if ((wr_en == 1'b1) && (addr_d != 'b0))
        regs[addr_d] <= data_d;
end

endmodule
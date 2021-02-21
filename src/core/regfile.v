// 2^ADDRW x DATAW Register File (default 32 x 32)
// x0 is always zero

module regfile #(
    parameter ADDRW = 5,
    parameter DATAW = 32
) (
    input                clk,
    input                wr_en,         // write enable
    input   [ADDRW-1:0]  addr_d,        // write port address
    input   [ADDRW-1:0]  addr_a,        // read port A address
    input   [ADDRW-1:0]  addr_b,        // read port B address
    input   [DATAW-1:0]  data_d,        // write port data
    output  [DATAW-1:0]  data_a,        // read port A data
    output  [DATAW-1:0]  data_b         // read port B data
);

localparam REGCOUNT = 1 << ADDRW;        // number of registers
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
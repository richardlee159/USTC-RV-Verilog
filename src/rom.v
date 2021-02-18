module rom #(
    parameter ADDRW = 10,
    parameter DATAW = 32
) (
    input   [ADDRW-1:0] addr,
    output  [DATAW-1:0] data
);

localparam SIZE = 1 << ADDRW;
reg [DATAW-1:0] mem [0:SIZE-1];

assign data = mem[addr];

endmodule
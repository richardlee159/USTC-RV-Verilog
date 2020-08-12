// 2^ADDRW Byte memory (default 4KB), single port
// Support ALIGNED read and write in 1B,2B,4B size
// Need to generate exception for unaligned access

`include "src/core/ram.v"
`include "src/core/macro.v"


module memory #(
    parameter ADDRW = 12
) (
    input               clk,
    input               we,             // write enable
    input   [2:0]       funct3,
    input   [ADDRW-1:0] addr,
    input   [31:0]      wdata,          // write data
    output  [31:0]      rdata           // read data
);

wire sign = funct3[2];
wire [1:0] length = funct3[1:0];

wire [1:0] byte_offset = addr[1:0];
wire [4:0] bit_offset = byte_offset << 3;

reg [3:0] byte_en;
always @(*) begin
    case(length)
        `ML_BYTE : byte_en = 4'b0001 << byte_offset;
        `ML_HALF : byte_en = 4'b0011 << byte_offset;
        `ML_WORD : byte_en = 4'b1111;
        default  : byte_en = 4'b0000;
    endcase
end

wire [31:0] ram_wdata;
wire [31:0] ram_rdata;

assign ram_wdata = wdata << bit_offset;

ram #(
    .ADDRW (ADDRW-2 ),
    .DATAW (32 )
)
u_ram(
    .clk   (clk             ),
    .we    (we              ),
    .be    (byte_en         ),
    .addr  (addr[ADDRW-1:2] ),
    .wdata (ram_wdata       ),
    .rdata (ram_rdata       )
);

wire [31:0] ub, uh, sb, sh;
assign ub = (ram_rdata >> bit_offset) & 32'h0000_00FF;
assign uh = (ram_rdata >> bit_offset) & 32'h0000_FFFF;
assign sb = {{24{ub[ 7]}}, ub[ 7:0]};
assign sh = {{16{uh[15]}}, uh[15:0]};

reg [31:0] rdata_r;
assign rdata = rdata_r;
always @(*) begin
    case (length)
        `ML_BYTE : rdata_r = sign ? sb : ub;
        `ML_HALF : rdata_r = sign ? sh : uh;
        `ML_WORD : rdata_r = ram_rdata;
        default  : rdata_r = 32'b0;
    endcase
end

endmodule
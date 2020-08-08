// 2^ADDRW Byte memory (default 4KB), single port
// Support ALIGNED read and write in 1B,2B,4B size
// Need to generate exception for unaligned access

`include "src/core/ram.v"

`define LEN_BYTE 2'b00
`define LEN_HALF 2'b01
`define LEN_WORD 2'b10

module memory #(
    parameter ADDRW = 12
) (
    input               clk,
    input               we,             // write enable
    input               sign,           // signed read
    input   [1:0]       length,         // r/w length (b,h,w)
    input   [ADDRW-1:0] addr,
    input   [31:0]      wdata,          // write data
    output  [31:0]      rdata           // read data
);

wire [1:0] byte_offset;
assign byte_offset = addr[1:0];

wire [4:0] bit_offset;
assign bit_offset = byte_offset << 3;

reg [3:0] byte_en;
always @(*) begin
    case(length)
        `LEN_BYTE   : byte_en = 4'b0001 << byte_offset;
        `LEN_HALF   : byte_en = 4'b0011 << byte_offset;
        `LEN_WORD   : byte_en = 4'b1111;
        default     : byte_en = 4'b0000;
    endcase
end

wire [31:0] blk_wdata;
wire [31:0] blk_rdata;

assign blk_wdata = wdata << bit_offset;
// always @(*) begin
//     case (length)
//         `LEN_BYTE   : blk_wdata = {4{wdata[ 7:0]}};
//         `LEN_HALF   : blk_wdata = {2{wdata[15:0]}};
//         `LEN_WORD   : blk_wdata = wdata;
//         default     : blk_wdata = 32'b0;
//     endcase
// end

ram #(
    .ADDRW (ADDRW-2 ),
    .DATAW (8       )
)
ram_blk_0(
	.clk   (clk             ),
    .we    (we & byte_en[0] ),
    .addr  (addr[ADDRW-1:2] ),
    .wdata (blk_wdata[7:0]  ),
    .rdata (blk_rdata[7:0]  )
),
ram_blk_1(
	.clk   (clk             ),
    .we    (we & byte_en[1] ),
    .addr  (addr[ADDRW-1:2] ),
    .wdata (blk_wdata[15:8] ),
    .rdata (blk_rdata[15:8] )
),
ram_blk_2(
	.clk   (clk             ),
    .we    (we & byte_en[2] ),
    .addr  (addr[ADDRW-1:2] ),
    .wdata (blk_wdata[23:16]),
    .rdata (blk_rdata[23:16])
),
ram_blk_3(
	.clk   (clk             ),
    .we    (we & byte_en[3] ),
    .addr  (addr[ADDRW-1:2] ),
    .wdata (blk_wdata[31:24]),
    .rdata (blk_rdata[31:24])
);

wire [31:0] ub, uh, sb, sh;
assign ub = (blk_rdata >> bit_offset) & 32'h0000_00FF;
assign uh = (blk_rdata >> bit_offset) & 32'h0000_FFFF;
assign sb = {{24{ub[ 7]}}, ub[ 7:0]};
assign sh = {{16{uh[15]}}, uh[15:0]};

reg [31:0] rdata_r;
assign rdata = rdata_r;
always @(*) begin
    case (length)
        `LEN_BYTE   : rdata_r = sign ? sb : ub;
        `LEN_HALF   : rdata_r = sign ? sh : uh;
        `LEN_WORD   : rdata_r = blk_rdata;
        default     : rdata_r = 32'b0;
    endcase
end

endmodule
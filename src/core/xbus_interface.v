`include "src/core/define.vh"

module xbus_interface (
    input   [2:0]       funct3,
    input   [31:0]      addr,
    input   [31:0]      wdata,          // write data
    output  [31:0]      rdata,          // read data

    output  [3:0]       xbus_be,
    output  [31:0]      xbus_addr,
    output  [31:0]      xbus_wdata,
    input   [31:0]      xbus_rdata
);

assign xbus_addr = addr;

wire sign = funct3[2];
wire [1:0] length = funct3[1:0];

wire [1:0] byte_offset = addr[1:0];
wire [4:0] bit_offset = byte_offset << 3;

reg [3:0] xbus_be_r;
assign xbus_be = xbus_be_r;
always @(*) begin
    case(length)
        `ML_BYTE : xbus_be_r = 4'b0001 << byte_offset;
        `ML_HALF : xbus_be_r = 4'b0011 << byte_offset;
        `ML_WORD : xbus_be_r = 4'b1111;
        default  : xbus_be_r = 4'b0000;
    endcase
end

assign xbus_wdata = wdata << bit_offset;

wire [31:0] ub, uh, sb, sh;
assign ub = (xbus_rdata >> bit_offset) & 32'h0000_00FF;
assign uh = (xbus_rdata >> bit_offset) & 32'h0000_FFFF;
assign sb = {{24{ub[ 7]}}, ub[ 7:0]};
assign sh = {{16{uh[15]}}, uh[15:0]};

reg [31:0] rdata_r;
assign rdata = rdata_r;
always @(*) begin
    case (length)
        `ML_BYTE : rdata_r = (sign == `MS_SIGN) ? sb : ub;
        `ML_HALF : rdata_r = (sign == `MS_SIGN) ? sh : uh;
        `ML_WORD : rdata_r = xbus_rdata;
        default  : rdata_r = 32'b0;
    endcase
end
    
endmodule
`define     ALU_ADD    'b0000
`define     ALU_SUB    'b1000
`define     ALU_SLL    'b0001
`define     ALU_SLT    'b0010
`define     ALU_SLTU   'b0011
`define     ALU_XOR    'b0100
`define     ALU_SRL    'b0101
`define     ALU_SRA    'b1101
`define     ALU_OR     'b0110
`define     ALU_AND    'b0111

module alu #(
    parameter DATAW = 32
) (
    input   [3:0]        sel,       // operation bits
    input   [DATAW-1:0]  a,         // operand A
    input   [DATAW-1:0]  b,         // operand B
    output  [DATAW-1:0]  out        // result = A op B
);

// shift amount
// For DATAW = 32 it's 5 bits -- Need modification for other DATAWs
wire [4:0] shamt;
assign shamt = b[4:0];

// signed version of two operands (Verilog-2001 enhancement)
wire signed [DATAW-1:0] a_s;
wire signed [DATAW-1:0] b_s;
assign a_s = a;
assign b_s = b;

reg [DATAW-1:0] out_r;
assign out = out_r;
always @(*) begin
    case (sel)
        `ALU_ADD  : out_r = a + b;
        `ALU_SUB  : out_r = a - b;
        `ALU_SLL  : out_r = a << shamt;
        `ALU_SLT  : out_r = (a_s < b_s) ? 'b1 : 'b0;
        `ALU_SLTU : out_r = (a < b) ? 'b1 : 'b0;
        `ALU_XOR  : out_r = a ^ b;
        `ALU_SRL  : out_r = a >> shamt;
        `ALU_SRA  : out_r = a_s >>> shamt;
        `ALU_OR   : out_r = a | b;
        `ALU_AND  : out_r = a & b;
        default   : out_r = 'b0;
    endcase
end

endmodule
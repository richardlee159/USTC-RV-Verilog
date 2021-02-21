`ifdef IVERILOG
`include "src/core/define.vh"
`else
`include "define.vh"
`endif

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
        `ALU_PASSB: out_r = b;
        default   : out_r = 'b0;
    endcase
end

endmodule
`include "src/core/define.vh"

module immgen (
    input   [2:0]   sel,
    input   [31:7]  inst,
    output  [31:0]  imm
);

wire sign;
assign sign = inst[31];

reg [31:0] imm_r;
assign imm = imm_r;

always @(*) begin
    case (sel)
        `IMM_I : imm_r = {{20{sign}}, inst[31:20]};
        `IMM_S : imm_r = {{20{sign}}, inst[31:25], inst[11:7]};
        `IMM_B : imm_r = {{19{sign}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        `IMM_U : imm_r = {inst[31:12], 12'b0};
        `IMM_J : imm_r = {{11{sign}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
        default: imm_r = 32'b0;
    endcase
end

endmodule
`include "src/core/macro.v"

module control (
    input   [6:0]   opcode,
    input   [2:0]   funct3,
    input   [6:0]   funct7,
    input           brtaken,
    output  [19:0]  ctrls
);

// opcode patterns
localparam  OP_LUI    = 7'b0110111;
localparam  OP_AUIPC  = 7'b0010111;
localparam  OP_JAL    = 7'b1101111;
localparam  OP_JALR   = 7'b1100111;
localparam  OP_BRANCH = 7'b1100011;
localparam  OP_LOAD   = 7'b0000011;
localparam  OP_STORE  = 7'b0100011;
localparam  OP_ALI    = 7'b0010011;
localparam  OP_ALR    = 7'b0110011;

reg         pc_sel;
reg         reg_wen;
reg         a_sel;
reg         b_sel;
reg         mem_rw;
reg         mem_sign;
reg [1:0]   mem_len;
reg [1:0]   wb_sel;
reg [2:0]   br_sel;
reg [2:0]   imm_sel;
reg [3:0]   alu_sel;

assign ctrls = {pc_sel, reg_wen, a_sel, b_sel, mem_rw, mem_sign,
                mem_len, wb_sel, br_sel, imm_sel, alu_sel};

// generation of control signals

// WARNING: IMPORTANT !!!
// To simplify the code and logic, the implementation of some signals
// (e.g. br_sel) and relevant macros take advantage of specific encoding
// of instructions. These signals are marked with ** in the comments.
// If the definition of relevant macros (e.g. BR_XXX) is changed, the
// control logic needs to be adjusted accordingly.

always @(*) begin
    // pc_sel
    case(opcode)
        OP_JAL    : pc_sel = `PC_ALU;
        OP_JALR   : pc_sel = `PC_ALU;
        OP_BRANCH : pc_sel = brtaken ? `PC_ALU : `PC_PC4;
        default   : pc_sel = `PC_PC4;
    endcase

    // imm_sel
    case(opcode)
        OP_LUI    : imm_sel = `IMM_U;
        OP_AUIPC  : imm_sel = `IMM_U;
        OP_JAL    : imm_sel = `IMM_J;
        OP_JALR   : imm_sel = `IMM_I;
        OP_BRANCH : imm_sel = `IMM_B;
        OP_LOAD   : imm_sel = `IMM_I;
        OP_STORE  : imm_sel = `IMM_S;
        OP_ALI    : imm_sel = `IMM_I;
        OP_ALR    : imm_sel = `DTCARE;
        default   : imm_sel = `DTCARE;
    endcase

    // reg_wen
    case (opcode)
        OP_LUI    : reg_wen = 1'b1;
        OP_AUIPC  : reg_wen = 1'b1;
        OP_JAL    : reg_wen = 1'b1;
        OP_JALR   : reg_wen = 1'b1;
        OP_BRANCH : reg_wen = 1'b0;
        OP_LOAD   : reg_wen = 1'b1;
        OP_STORE  : reg_wen = 1'b0;
        OP_ALI    : reg_wen = 1'b1;
        OP_ALR    : reg_wen = 1'b1;
        default   : reg_wen = 1'b0;
    endcase

    // a_sel
    case(opcode)
        OP_LUI    : a_sel = `DTCARE;
        OP_AUIPC  : a_sel = `A_PC;
        OP_JAL    : a_sel = `A_PC;
        OP_JALR   : a_sel = `A_RS1;
        OP_BRANCH : a_sel = `A_PC;
        OP_LOAD   : a_sel = `A_RS1;
        OP_STORE  : a_sel = `A_RS1;
        OP_ALI    : a_sel = `A_RS1;
        OP_ALR    : a_sel = `A_RS1;
        default   : a_sel = `DTCARE;
    endcase

    // b_sel
    case(opcode)
        OP_LUI    : b_sel = `B_IMM;
        OP_AUIPC  : b_sel = `B_IMM;
        OP_JAL    : b_sel = `B_IMM;
        OP_JALR   : b_sel = `B_IMM;
        OP_BRANCH : b_sel = `B_IMM;
        OP_LOAD   : b_sel = `B_IMM;
        OP_STORE  : b_sel = `B_IMM;
        OP_ALI    : b_sel = `B_IMM;
        OP_ALR    : b_sel = `B_RS2;
        default   : b_sel = `DTCARE;
    endcase

    // mem_rw
    case (opcode)
        OP_STORE  : mem_rw = `M_WRITE;
        default   : mem_rw = `M_READ;
    endcase

    // wb_sel
    case(opcode)
        OP_LUI    : wb_sel = `WB_ALU;
        OP_AUIPC  : wb_sel = `WB_ALU;
        OP_JAL    : wb_sel = `WB_PC4;
        OP_JALR   : wb_sel = `WB_PC4;
        OP_BRANCH : wb_sel = `DTCARE;
        OP_LOAD   : wb_sel = `WB_DM;
        OP_STORE  : wb_sel = `DTCARE;
        OP_ALI    : wb_sel = `WB_ALU;
        OP_ALR    : wb_sel = `WB_ALU;
        default   : wb_sel = `DTCARE;
    endcase

    // alu_sel **
    case (opcode)
        OP_LUI    : alu_sel = `ALU_PASSB;
        OP_AUIPC  : alu_sel = `ALU_ADD;
        OP_JAL    : alu_sel = `ALU_ADD;
        OP_JALR   : alu_sel = `ALU_ADD;
        OP_BRANCH : alu_sel = `ALU_ADD;
        OP_LOAD   : alu_sel = `ALU_ADD;
        OP_STORE  : alu_sel = `ALU_ADD;
        OP_ALI    : alu_sel = {  1'b0   , funct3};
        OP_ALR    : alu_sel = {funct7[5], funct3};
        default   : alu_sel = `DTCARE;
    endcase

    // mem_sign **
    mem_sign = funct3[2];

    // mem_len **
    mem_len  = funct3[1:0];

    // br_sel **
    br_sel   = funct3;
end

endmodule
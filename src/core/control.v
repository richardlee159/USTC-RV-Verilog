`include "src/core/macro.v"
`include "src/core/format.vh"

module control (
    input   [31:0]  inst,
    input           brtaken,
    output  [13:0]  ctrls
);

reg [13:0] cr;
assign ctrls = cr;

wire pc_br = brtaken ? `PC_ALU : `PC_PC4;

always @(*) begin
casez(inst)
//                   pc_sel reg_wen a_sel   b_sel   mem_rw    wb_sel  imm_sel  alu_sel   
//                     |       |      |       |        |        |        |        |
    `LUI    : cr = {`PC_PC4,  `Y , `A_X  , `B_IMM, `M_READ , `WB_ALU, `IMM_U, `ALU_PASSB};
    `AUIPC  : cr = {`PC_PC4,  `Y , `A_PC , `B_IMM, `M_READ , `WB_ALU, `IMM_U, `ALU_ADD  };

    `JAL    : cr = {`PC_ALU,  `Y , `A_PC , `B_IMM, `M_READ , `WB_PC4, `IMM_J, `ALU_ADD  };
    `JALR   : cr = {`PC_ALU,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_PC4, `IMM_I, `ALU_ADD  };

    `BEQ    : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };
    `BNE    : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };
    `BLT    : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };
    `BGE    : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };
    `BLTU   : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };
    `BGEU   : cr = { pc_br ,  `N , `A_PC , `B_IMM, `M_READ , `WB_X  , `IMM_B, `ALU_ADD  };

    `LB     : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_DM , `IMM_I, `ALU_ADD  };
    `LH     : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_DM , `IMM_I, `ALU_ADD  };
    `LW     : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_DM , `IMM_I, `ALU_ADD  };
    `LBU    : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_DM , `IMM_I, `ALU_ADD  };
    `LHU    : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_DM , `IMM_I, `ALU_ADD  };

    `SB     : cr = {`PC_PC4,  `N , `A_RS1, `B_IMM, `M_WRITE, `WB_X  , `IMM_S, `ALU_ADD  };
    `SH     : cr = {`PC_PC4,  `N , `A_RS1, `B_IMM, `M_WRITE, `WB_X  , `IMM_S, `ALU_ADD  };
    `SW     : cr = {`PC_PC4,  `N , `A_RS1, `B_IMM, `M_WRITE, `WB_X  , `IMM_S, `ALU_ADD  };

    `ADDI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_ADD  };
    `SLTI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_SLT  };
    `SLTIU  : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_SLTU };
    `XORI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_XOR  };
    `ORI    : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_OR   };
    `ANDI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_AND  };
    `SLLI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_SLL  };
    `SRLI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_SRL  };
    `SRAI   : cr = {`PC_PC4,  `Y , `A_RS1, `B_IMM, `M_READ , `WB_ALU, `IMM_I, `ALU_SRA  };

    `ADD    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_ADD  };
    `SUB    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SUB  };
    `SLL    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SLL  };
    `SLT    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SLT  };
    `SLTU   : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SLTU };
    `XOR    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_XOR  };
    `SRL    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SRL  };
    `SRA    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_SRA  };
    `OR     : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_OR   };
    `AND    : cr = {`PC_PC4,  `Y , `A_RS1, `B_RS2, `M_READ , `WB_ALU, `IMM_X, `ALU_AND  };

    default : cr = {`PC_PC4,  `N , `A_X  , `B_X  , `M_READ , `WB_X  , `IMM_X, `ALU_X   };
endcase
end

endmodule
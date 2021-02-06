// RISC-V CPU Core, Single-Cycle
// Support all RV32I unprivileged instructions (37 in total)

`include "src/core/control.v"

`include "src/core/alu.v"
`include "src/core/brcomp.v"
`include "src/core/immgen.v"
`include "src/core/memory.v"
`include "src/core/regfile.v"
`include "src/core/register.v"
`include "src/core/rom.v"

module core #(
    parameter PC_RSTVAL = 32'b0,
    parameter IMEM_ADDRW = 12,
    parameter DMEM_ADDRW = 12
) (
    input clk,
    input rst
);

// control signals
wire        pc_sel;
wire        reg_wen;
wire        a_sel;
wire        b_sel;
wire        mem_rw;
wire [1:0]  wb_sel;
wire [2:0]  imm_sel;
wire [3:0]  alu_sel;

wire [13:0] ctrls;
wire        br_taken;

assign {pc_sel, reg_wen, a_sel, b_sel, mem_rw,
        wb_sel, imm_sel, alu_sel} = ctrls;

wire [31:0] next_pc;
wire [31:0] pc;
wire [31:0] pc_plus_4;
wire [31:0] inst;
wire [31:0] imm;
wire [31:0] data_a;
wire [31:0] data_b;
wire [31:0] data_d;
wire [31:0] alu_a;
wire [31:0] alu_b;
wire [31:0] alu_out;
wire [31:0] mem_out;

wire [6:0] opcode = inst[ 6: 0];
wire [2:0] funct3 = inst[14:12];
wire [6:0] funct7 = inst[31:25];

control control_inst(
    .inst    (inst     ),
    .brtaken (br_taken ),
    .ctrls   (ctrls    )
);

register #(
    .DATAW     (32        ),
    .RST_VALUE (PC_RSTVAL )
)
pc_inst(
    .clk   (clk     ),
    .rst   (rst     ),
    .wr_en (1'b1    ),
    .dnxt  (next_pc ),
    .qout  (pc      )
);

assign pc_plus_4 = pc + 4;

rom #(
    .ADDRW (IMEM_ADDRW-2 ),
    .DATAW (32           )
)
imem_inst(
    .addr (pc[IMEM_ADDRW-1:2] ),
    .data (inst               )
);

// memory 
// #(
//     .ADDRW (IMEM_ADDRW )
// )
// imem_inst(
//     .clk    (clk                ),
//     .we     (1'b0               ),
//     .sign   (1'b0               ),
//     .length (`ML_WORD           ),
//     .addr   (pc[IMEM_ADDRW-1:0] ),
//     .wdata  (32'b0              ),
//     .rdata  (inst               )
// );

regfile #(
    .ADDRW (5  ),
    .DATAW (32 )
)
regfile_inst(
    .clk    (clk         ),
    .wr_en  (reg_wen     ),
    .addr_d (inst[11: 7] ),
    .addr_a (inst[19:15] ),
    .addr_b (inst[24:20] ),
    .data_d (data_d      ),
    .data_a (data_a      ),
    .data_b (data_b      )
);

immgen immgen_inst(
    .sel  (imm_sel    ),
    .inst (inst[31:7] ),
    .imm  (imm        )
);

brcomp #(
    .DATAW (32 )
)
brcomp_inst(
    .funct3(funct3   ),
    .a     (data_a   ),
    .b     (data_b   ),
    .taken (br_taken )
);

assign alu_a = (a_sel == `A_PC ) ? pc  : data_a;
assign alu_b = (b_sel == `B_IMM) ? imm : data_b;

alu #(
    .DATAW (32 )
)
alu_inst(
    .sel (alu_sel ),
    .a   (alu_a   ),
    .b   (alu_b   ),
    .out (alu_out )
);

memory #(
    .ADDRW (DMEM_ADDRW )
)
dmem_inst(
    .clk    (clk                     ),
    .we     (mem_rw == `M_WRITE      ),
    .funct3 (funct3                  ),
    .addr   (alu_out[DMEM_ADDRW-1:0] ),
    .wdata  (data_b                  ),
    .rdata  (mem_out                 )
);

assign data_d = (wb_sel == `WB_PC4) ? pc_plus_4 :
                (wb_sel == `WB_ALU) ? alu_out : mem_out;

assign next_pc = (pc_sel == `PC_ALU) ? alu_out : pc_plus_4;

endmodule
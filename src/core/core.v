// RISC-V CPU Core, Single-Cycle
// Support all RV32I unprivileged instructions (37 in total)

`include "src/core/control.v"

`include "src/core/alu.v"
`include "src/core/brcomp.v"
`include "src/core/immgen.v"
`include "src/core/regfile.v"
`include "src/core/register.v"
`include "src/core/rom.v"
`include "src/core/xbus_interface.v"

module core #(
    parameter PC_RSTVAL = 32'h0000,
    parameter IMEM_ADDRW = 14
) (
    input   clk,
    input   rst,
    output          xbus_as,
    output          xbus_we,
    output  [3:0]   xbus_be,
    output  [31:0]  xbus_addr,
    output  [31:0]  xbus_wdata,
    input   [31:0]  xbus_rdata
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

wire [6:0] opcode = inst[`OP_LOC];
wire [2:0] funct3 = inst[`F3_LOC];
wire [6:0] funct7 = inst[`F7_LOC];

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
    .clk    (clk            ),
    .wr_en  (reg_wen        ),
    .addr_d (inst[`RD_LOC]  ),
    .addr_a (inst[`RS1_LOC] ),
    .addr_b (inst[`RS2_LOC] ),
    .data_d (data_d         ),
    .data_a (data_a         ),
    .data_b (data_b         )
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

wire mem_en = 1;
assign xbus_as = mem_en;
assign xbus_we = mem_rw == `M_WRITE;

xbus_interface xbus_interface_inst(
    .funct3     (funct3     ),
    .addr       (alu_out    ),
    .wdata      (data_b     ),
    .rdata      (mem_out    ),
    .xbus_be    (xbus_be    ),
    .xbus_addr  (xbus_addr  ),
    .xbus_wdata (xbus_wdata ),
    .xbus_rdata (xbus_rdata )
);

assign data_d = (wb_sel == `WB_PC4) ? pc_plus_4 :
                (wb_sel == `WB_ALU) ? alu_out : mem_out;

assign next_pc = (pc_sel == `PC_ALU) ? alu_out : pc_plus_4;

endmodule
`ifndef __MACRO_V
`define __MACRO_V

// -------- Universal ---------
`define     BYTEW       8

// `define     N           1'b0
// `define     Y           1'b1

`define     DTCARE      'bx
// DTCARE is used to represent Don't Care Term
// It should lead to optimal circuit design with synthesis tools' support
// If the synthesis tool doesn't support it, replace 'bx with 'b0
// WARNING: May cause inconsistency between behavioral simulation and synthesis

// ----------------------------


// --------- Control ----------
`define     A_RS1       1'b0
`define     A_PC        1'b1

`define     B_RS2       1'b0
`define     B_IMM       1'b1

`define     WB_DM       2'b00
`define     WB_ALU      2'b01
`define     WB_PC4      2'b10

`define     PC_PC4      1'b0
`define     PC_ALU      1'b1
// ----------------------------


// -------- Imm Gen -----------
`define     IMM_I       3'd0
`define     IMM_S       3'd1
`define     IMM_B       3'd2
`define     IMM_U       3'd3
`define     IMM_J       3'd4
// ----------------------------


// ---------- ALU -------------
`define     ALU_ADD     4'b0000
`define     ALU_SUB     4'b1000
`define     ALU_SLL     4'b0001
`define     ALU_SLT     4'b0010
`define     ALU_SLTU    4'b0011
`define     ALU_XOR     4'b0100
`define     ALU_SRL     4'b0101
`define     ALU_SRA     4'b1101
`define     ALU_OR      4'b0110
`define     ALU_AND     4'b0111

`define     ALU_PASSB   4'b1111
// ----------------------------


// ------- Branch Comp --------
`define     BR_EQ       3'b000
`define     BR_NE       3'b001
`define     BR_LT       3'b100
`define     BR_GE       3'b101
`define     BR_LTU      3'b110
`define     BR_GEU      3'b111
// ----------------------------


// --------- Memory -----------
`define     M_READ      1'b0
`define     M_WRITE     1'b1

`define     MS_SIGN     1'b0
`define     MS_UNSIGN   1'b1

`define     ML_BYTE     2'b00
`define     ML_HALF     2'b01
`define     ML_WORD     2'b10
// ----------------------------

`endif
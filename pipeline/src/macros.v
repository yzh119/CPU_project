/*
 * Written by Zihao Ye(expye) on 2016.08.24
 */

//====================== Clock ====================================================================
`define Epsilon															2
`define HalfPeriodicity													10
`define Periodicity 													20

//====================== Miscellaneous ============================================================
`define InstAddrBus														31:0
`define RstEnable														1'b1
`define RstDisable														1'b0
`define ChipEnable														1'b1
`define ChipDisable														1'b0		
`define InstBus 														31:0
`define ZeroWord 														32'h0												
`define ALUBus															3:0
`define RegDataBus														31:0
`define RegAddrBus														4:0
`define RegAddrBits														5
`define RegNum															32
`define ForwardingBus													1:0
`define InstMemNum														15'h8000
`define InstMemNumLog													15
`define FuncBus															5:0
`define RsRtRdBus														4:0
`define ShamtBus														4:0
`define OpcodeBus 														5:0
`define ImmeBus															15:0
`define OpcodeInInst													31:26
`define RsInInst														25:21
`define RtInInst														20:16
`define RdInInst														15:11
`define ShamtInInst														10:6
`define FuncInInst														5:0
`define ImmeInInst														15:0
`define TopBitOfImmeInInst												15
`define LengthOfImmeInInst												16
`define AddressInInst													25:0
`define ConcatenateBitsForJumpInInst									31:28
`define PortSel1														2'h0
`define PortSel2														2'h1
`define PortSel3														2'h2
`define PortSel4														2'h3
`define RsRtEqual														1'b1
`define RsRtNotEqual													1'b0
`define WriteEnable														1'b1
`define WriteDisable													1'b0

//====================== Arithmetic, Shift, Condition and Logic ===================================
`define EXE_FUNC_ADD													6'h20
`define EXE_FUNC_ADDU													6'h21
`define EXE_FUNC_DIV													6'h1a
`define EXE_FUNC_DIVU													6'h1b
`define EXE_FUNC_MULT													6'h18
`define EXE_FUNC_MULTU													6'h19
`define EXE_FUNC_MUL 													6'h2
`define EXE_FUNC_AND													6'h24
`define EXE_FUNC_CLO													6'h21
`define EXE_FUNC_CLZ													6'h20
`define EXE_FUNC_MADD													6'h0
`define EXE_FUNC_MADDU													6'h1
`define EXE_FUNC_MSUB													6'h4
`define EXE_FUNC_MSUBU													6'h5
`define EXE_FUNC_NOR													6'h27
`define EXE_FUNC_OR														6'h25
`define EXE_FUNC_SLL													6'h0
`define EXE_FUNC_SLLV													6'h4
`define EXE_FUNC_SRA													6'h3
`define EXE_FUNC_SRAV													6'h7
`define EXE_FUNC_SRL													6'h2
`define EXE_FUNC_SRLV													6'h6
`define EXE_FUNC_SUB													6'h22
`define EXE_FUNC_SUBU													6'h23
`define EXE_FUNC_XOR													6'h26
`define EXE_FUNC_SLT													6'h2a
`define EXE_FUNC_SLTU													6'h2b

`define EXE_OPCODE_ADD_SUB_MULT_DIV_AND_NOR_OR_XOR_SLL_SLT				6'h0
`define EXE_OPCODE_ADDI													6'h8
`define EXE_OPCODE_ADDIU												6'h9
`define EXE_OPCODE_ANDI													6'hc
`define EXE_OPCODE_CL_MUL_MADD_MSUB										6'h1c
`define EXE_OPCODE_ORI													6'hd
`define EXE_OPCODE_XORI													6'he
`define EXE_OPCODE_LUI													6'hf
`define EXE_OPCODE_SLTI													6'ha
`define EXE_OPCODE_SLTIU												6'hb

//====================== Branch =================================================

//====================== Jump ===================================================

//====================== Trap ===================================================

//====================== Load & Store ===========================================

//====================== Movement ===============================================

//====================== Exception & Interrupt ==================================
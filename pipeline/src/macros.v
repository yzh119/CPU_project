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
`define ALUBus															4:0
`define MEMBus															2:0
`define RegDataBus														31:0
`define RegAddrBus														4:0
`define RegAddrBits														5
`define RegNum															32
`define ForwardingBus													1:0
`define InstMemNum														16'h8000
`define InstMemNumLog													16
`define DataMemNum														16'h8000
`define DataMemNumLog													16
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
`define ReadEnable														1'b1
`define ReadDisable														1'b0
`define Branch 															1'b1
`define BranchNot														1'b0
`define HighLevel														1'b1
`define LowLevel														1'b0
`define True															1'b1
`define False															1'b0
`define JumpBus															1:0
`define JumpJR															2'h2
`define JumpJ															2'h1
`define JumpB															2'h0
`define HalfWordLength													5'h10
`define HighestBit														5'h1f
`define LowHalf															15:0
`define HighHalf														31:16
`define FirstByte														31:24
`define SecondByte														23:16
`define ThirdByte														15:8
`define FourthByte														7:0

//====================== Arithmetic, Shift, Condition and Logic, Data transfer ===================================
`define FUNC_ADD													6'h20
`define FUNC_ADDU													6'h21
`define FUNC_DIV													6'h1a
`define FUNC_DIVU													6'h1b
`define FUNC_MULT													6'h18
`define FUNC_MULTU													6'h19
`define FUNC_MUL 													6'h2
`define FUNC_AND													6'h24
`define FUNC_CLO													6'h21
`define FUNC_CLZ													6'h20
`define FUNC_MADD													6'h0
`define FUNC_MADDU													6'h1
`define FUNC_MSUB													6'h4
`define FUNC_MSUBU													6'h5
`define FUNC_NOR													6'h27
`define FUNC_OR														6'h25
`define FUNC_SLL													6'h0
`define FUNC_SLLV													6'h4
`define FUNC_SRA													6'h3
`define FUNC_SRAV													6'h7
`define FUNC_SRL													6'h2
`define FUNC_SRLV													6'h6
`define FUNC_SUB													6'h22
`define FUNC_SUBU													6'h23
`define FUNC_XOR													6'h26
`define FUNC_SLT													6'h2a
`define FUNC_SLTU													6'h2b
`define FUNC_MFHI													6'h10
`define FUNC_MFLO													6'h12
`define FUNC_JR														6'h8
`define FUNC_NOP													6'h0

`define OPCODE_BEQ													6'h4
`define OPCODE_BNE													6'h5
`define OPCODE_J													6'h2
`define OPCODE_JAL													6'h3
`define OPCODE_ADDI													6'h8
`define OPCODE_ADDIU												6'h9
`define OPCODE_ANDI													6'hc
`define OPCODE_CL_MUL_MADD_MSUB										6'h1c
`define OPCODE_ORI													6'hd
`define OPCODE_XORI													6'he
`define OPCODE_LUI													6'hf
`define OPCODE_SLTI													6'ha
`define OPCODE_SLTIU												6'hb
`define OPCODE_LW 													6'h23
`define OPCODE_LH													6'h21
`define OPCODE_LHU													6'h25
`define OPCODE_LB 													6'h20
`define OPCODE_LBU 													6'h24
`define OPCODE_SW													6'h2b
`define OPCODE_SH													6'h29
`define OPCODE_SB 													6'h28
`define OPCODE_NOP													6'h0

//====================== ALU ==================================
`define ALU_ADD														5'h0
`define ALU_SUB														5'h1
`define ALU_AND														5'h2
`define ALU_OR														5'h3
`define ALU_XOR														5'h4
`define ALU_NOR														5'h5
`define ALU_SLT														5'h6
`define ALU_SLTU													5'h7
`define ALU_SLL														5'h8
`define ALU_SRL														5'h9
`define ALU_SLA														5'ha
`define ALU_SRA														5'hb
`define ALU_LUI														5'hc
`define ALU_MUL														5'hd
`define ALU_DIV														5'he
`define ALU_DIVU													5'hf
`define ALU_MFLO													5'h10
`define ALU_MFHI													5'h11
`define ALU_NOP														5'h12

//====================== MEM ==================================
`define MEM_WORD													3'h0
`define MEM_HALF													3'h1
`define MEM_BYTE													3'h2
`define MEM_EXT_HALF												3'h3
`define MEM_EXT_BYTE												3'h4

//====================== Exception & Interrupt ==================================
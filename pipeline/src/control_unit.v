`include "macros.v"

module control_unit (
	input m_mem_to_reg,				// Mem to Reg in stage MEM
	input m_write_reg,				// Write Reg in stage MEM
	input [`RegAddrBus]m_des_r,		// Destination Reg in stage MEM
	input [`RegAddrBus]e_des_r,		// Destination Reg in stage EXE
	input e_mem_to_reg,				// Mem to reg in stage EXE
	input e_write_reg,				// Write Reg in stage EXE
	input rs_rt_equ,				// rs == rt ?
	input [`FuncBus] func,			// Func
	input [`OpcodeBus] opcode, 		// Opcode
	input [`RsRtRdBus] rs,			// Rs
	input [`RsRtRdBus] rt,			// Rt

	output reg jal,						// jal ?
	output reg write_reg,				// Write Reg
	output reg mem_to_reg,				// Mem to Reg
	output reg write_mem,				// Write Mem
	output reg [`ALUBus] aluc,			// ALUcontrol
	output reg shift,					// Shift Mul
	output reg alu_imm,					// ALU Immediate
	output reg sext_signed,				// Sign extension == signed ?
	output reg reg_rt,					// Destination Reg == rt?
	output reg [`ForwardingBus] fwd_a,	// Forwarding A
	output reg [`ForwardingBus] fwd_b,	// Forwarding B
	output reg [`JumpBus]jump,					// Jump Mul
	output reg write_pc_ir,				// Write PC & IR
	output reg branch					// Branch
);

	initial begin		
		write_pc_ir = `False;
		branch 		= `False;
		fwd_a 		= `PortSel1;
		fwd_b		= `PortSel1;
		jump 		= `JumpJ;
		jal 		= `False;
	end

	always @ (*) begin
	// Arithmetic
		write_pc_ir = `False;
		branch 		= `False;
		fwd_a 		= `PortSel1;
		fwd_b		= `PortSel1;
		jump 		= `JumpJ;
		jal 		= `False;

		if (rs == m_des_r) begin
			if (m_write_reg) fwd_a = `PortSel3;
			if (m_mem_to_reg) fwd_a = `PortSel4;
		end

		if (rs == e_des_r) begin
			if (e_write_reg) fwd_a = `PortSel2;
		end

		if (rt == m_des_r) begin
			if (m_write_reg) fwd_b = `PortSel3;
			if (m_mem_to_reg) fwd_b = `PortSel4;
		end

		if (rt == e_des_r) begin
			if (e_write_reg) fwd_b = `PortSel2;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_ADD) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_ADDU) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SUB) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SUB;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SUBU) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SUB;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end 

		if (opcode == `OPCODE_ADDI) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			reg_rt		= `True;
		end

		if (opcode == `OPCODE_ADDIU) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `False;
			reg_rt		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_MULT) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_MUL;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_MULTU) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_MUL;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_DIV) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_DIV;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_DIVU) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_DIVU;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `True;
		end

	// Data Transfer
		if (opcode == `OPCODE_LW) begin 
			write_reg 	= `True;
			mem_to_reg 	= `True;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm 	= `True;
			sext_signed = `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_LH) begin 

		end

		if (opcode == `OPCODE_LHU) begin 

		end

		if (opcode == `OPCODE_LB) begin 

		end

		if (opcode == `OPCODE_LBU) begin 

		end

		if (opcode == `OPCODE_SW) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `True;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm 	= `True;
			sext_signed = `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_SH) begin 

		end

		if (opcode == `OPCODE_SB) begin 

		end

		if (opcode == `OPCODE_LUI) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_LUI;
			shift 		= `False;
			alu_imm 	= `True;
			reg_rt 		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_MFLO) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_MFLO;
			shift 		= `False;
			alu_imm 	= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_MFHI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_MFHI;
			shift 		= `False;
			alu_imm 	= `False;
			reg_rt 		= `False;
		end

	// Logical

		if (opcode == `OPCODE_NOP && func == `FUNC_AND) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_AND;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_ANDI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_AND;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			reg_rt		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_OR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_OR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_ORI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_OR;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			reg_rt		= `True;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_XOR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_XOR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_NOR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLT) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLT;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLTU) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLTU;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_SLTI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLT;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			reg_rt		= `True;
		end

	// Bitwise shift

		if (opcode == `OPCODE_NOP && func == `FUNC_SLL) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem	= `False;
			aluc 		= `ALU_SLL;
			shift 		= `True;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRL) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem	= `False;
			aluc 		= `ALU_SRL;
			shift 		= `True;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRA) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem	= `False;
			aluc 		= `ALU_SRA;
			shift 		= `True;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLLV) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLL;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRLV) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SRL;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRAV) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SRA;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `True;
			reg_rt 		= `False;
		end

	// Conditional branch

		if (opcode == `OPCODE_BEQ) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOP;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `False;
			reg_rt 		= `False;
			jump 		= `JumpB;

			if (rs_rt_equ == `True) begin
				branch 	= `True;
			end else begin
				branch 	= `False;
			end

		end

		if (opcode == `OPCODE_BNE) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOP;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `False;
			reg_rt 		= `False;
			jump 		= `JumpB;

			if (rs_rt_equ == `False) begin 
				branch 	= `True;
			end else begin 
				branch 	= `False;
			end

		end

	// Unconditional jump

		if (opcode == `OPCODE_J) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOP;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `False;
			reg_rt 		= `False;
			branch 		= `True;
			jump 		= `JumpJ;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_JR) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOP;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `False;
			branch 		= `True;
			jump 		= `JumpJR;
		end

		if (opcode == `OPCODE_JAL) begin 
			write_reg 	= `False;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOP;
			shift 		= `False;
			alu_imm 	= `False;
			sext_signed = `False;
			branch 		= `True;
			jump 		= `JumpJ;
			jal 		= `True;
		end

		if (rs == e_des_r || rt == e_des_r) begin 
			if (e_mem_to_reg == `True) begin 
				write_reg 	= `False;
				write_mem 	= `False;
				write_pc_ir = `True;
			end
		end

	end

endmodule
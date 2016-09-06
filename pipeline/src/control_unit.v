`include "macros.v"

module control_unit (
	input m_mem_to_reg,				// Mem to Reg in stage MEM
	input m_write_reg,				// Write Reg in stage MEM
	input m_des_r,					// Destination Reg in stage MEM
	input e_des_r,					// Destination Reg in stage EXE
	input e_write_reg,				// Write Reg in stage EXE
	input rs_rt_equ,				// rs == rt ?
	input [`FuncBus] func,			// Func
	input [`OpcodeBus] opcode, 		// Opcode
	input [`RsRtRdBus] rs,			// Rs
	input [`RsRtRdBus] rt,			// Rt

	output reg write_reg,				// Write Reg
	output reg mem_to_reg,				// Mem to Reg
	output reg write_mem,				// Write Mem
	output reg [`ALUBus] aluc,			// ALUcontrol
	output reg shift,					// Shift Mul
	output reg alu_imm,					// ALU Immediate
	output reg sext_signed,				// Sign extension == signed ?
	output reg reg_rt,					// Destination Reg == rt?
	output reg [`ForwardingBus] fwd_b,	// Forwarding B
	output reg [`ForwardingBus] fwd_a,	// Forwarding A
	output reg jump,					// Jump Mul
	output reg write_pc_ir,				// Write PC & IR
	output reg branch					// Branch
);

	always @ (opcode, func) begin
	// Arithmetic

		if (opcode == `OPCODE_NOP && func == `FUNC_ADD) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_ADDU) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SUB) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SUB;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SUBU) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SUB;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end 

		if (opcode == `OPCODE_ADDI) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			ret_rt		= `True;
			jump 		= `False;
			branch 	 	= `False;
		end

		if (opcode == `OPCODE_ADDIU) begin
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_ADD;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `False;
			ret_rt		= `True;
			jump 		= `False;
			branch 	 	= `False;
		end

	// Data Transfer
		if (opcode == `OPCODE_LW) begin 

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

		end

		if (opcode == `OPCODE_SH) begin 

		end

		if (opcode == `OPCODE_SB) begin 

		end

		if (opcode == `OPCODE_LUI) begin 

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
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_ANDI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_AND;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			ret_rt		= `True;
			jump 		= `False;
			branch 	 	= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_OR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_OR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_ORI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_OR;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			ret_rt		= `True;
			jump 		= `False;
			branch 	 	= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_XOR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_XOR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_NOR) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_NOR;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLT) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLT;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLTU) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLTU;
			shift 		= `False;
			alu_imm		= `False;
			reg_rt 		= `False;
			jump 		= `False;
			branch 		= `False;
		end

		if (opcode == `OPCODE_SLTI) begin 
			write_reg 	= `True;
			mem_to_reg 	= `False;
			write_mem 	= `False;
			aluc 		= `ALU_SLT;
			shift 		= `False;
			alu_imm	 	= `True;
			sext_signed = `True;
			ret_rt		= `True;
			jump 		= `False;
			branch 	 	= `False;
		end

	// Bitwise shift

		if (opcode == `OPCODE_NOP && func == `FUNC_SLL) begin 
			
		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRL) begin 

		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRA) begin

		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SLLV) begin 

		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRLV) begin 

		end

		if (opcode == `OPCODE_NOP && func == `FUNC_SRAV) begin 

		end

	// Conditional branch

		if (opcode == `OPCODE_BEQ) begin 

		end

		if (opcode == `OPCODE_BNE) begin 

		end

	// Unconditional jump

		if (opcode == `OPCODE_J) begin 

		end

		if (opcode == `OPCODE_NOP && func == `FUNC_JR) begin 

		end

		if (opcode == `OPCODE_JAL) begin 

		end
	end

endmodule
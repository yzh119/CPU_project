`include "macros.v"

module id_ex (
	input clk, 					// Clock

	input write_reg,			// Write regsiter? in ID stage.
	input mem_to_reg,			// Memory to regsiter? in ID stage.
	input write_mem,			// Write to memory? in ID stage.
	input [`ALUBus] aluc,		// ALU type in ID stage.
	input shift,				// Shift? in ID stage.
	input alu_imm,				// ALU immediate in ID stage.

	input [`RegDataBus] operand_1_i,		// Operand 1 input.
	input [`RegDataBus] operand_2_i,		// Operand 2 input.
	input [`RegDataBus] operand_imm_i,		// Operand immediate input.
	input [`InstAddrBus] des_r_i,			// Destination register input. 

	output reg exe_write_reg,		// Write register? in EXE stage.
	output reg exe_mem_to_reg,		// Memory to register? in EXE stage.
	output reg exe_write_mem,		// Write to memory? in EXE stage.
	output reg [`ALUBus] exe_aluc, 	// ALU type in EXE stage.
	output reg exe_shift,			// Shift in EXE stage.
	output reg exe_alu_imm,			// ALU immediate in EXE stage.
	
	output reg [`RegDataBus] operand_1_o, 	// Operand 1 output.
	output reg [`RegDataBus] operand_2_o, 	// Operand 2 output.
	output reg [`RegDataBus] operand_imm_o 	// Operand immediate output.
	output reg [`InstAddrBus] des_r_o,	// Destination register.
);

	always @ (*) begin
		exe_write_reg 	= write_reg;
		exe_mem_to_reg 	= mem_to_reg;
		exe_write_mem	= write_mem;
		exe_aluc		= aluc;
		exe_shift 		= shift;
		exe_alu_imm 	= alu_imm;

		operand_1_o		= operand_1_i;
		operand_2_o		= operand_2_i;
		operand_imm_o 	= operand_imm;
		des_r_o 		= des_r_i; 	
	end
endmodule
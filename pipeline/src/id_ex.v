`include "macros.v"

module id_ex (
	input clk, 					// Clock
	input rst,					// Reset

	input write_reg,			// Write regsiter? in ID stage.
	input mem_to_reg,			// Memory to regsiter? in ID stage.
	input write_mem,			// Write to memory? in ID stage.
	input [`ALUBus] aluc,		// ALU type in ID stage.
	input shift,				// Shift? in ID stage.
	input alu_imm,				// ALU immediate in ID stage.

	input [`RegDataBus] oprand_1_i,	// Oprand 1 input.
	input [`RegDataBus] oprand_2_i,	// Oprand 2 input.

	output reg exe_write_reg,		// Write register? in EXE stage.
	output reg exe_mem_to_reg,		// Memory to register? in EXE stage.
	output reg exe_write_mem,		// Write to memory? in EXE stage.
	output reg [`ALUBus] exe_aluc, 	// ALU type in EXE stage.
	output reg exe_shift,			// Shift in EXE stage.
	output reg exe_alu_imm,			// ALU immediate in EXE stage.

	output reg [`RegDataBus] oprand_1_o, // Oprand 1 output.
	output reg [`RegDataBus] oprand_2_o, // Oprand 2 output.
);

	always @ (*) begin
		exe_write_reg 	= write_reg;
		exe_mem_to_reg 	= mem_to_reg;
		exe_write_mem	= write_mem;
		exe_aluc		= aluc;
		exe_shift 		= shift;
		exe_alu_imm 	= alu_imm;

		oprand_1_o		= oprand_1_i;
		oprand_2_o		= oprand_2_i;
	end
endmodule
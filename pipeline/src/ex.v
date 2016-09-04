`include "macros.v"

module ex (
	input clk,    // Clock
	input rst, 	  // Reset

	input exe_write_reg, 	// Write register? in EXE stage.
	input exe_mem_to_reg,	// Memory to reg? in EXE stage.
	input exe_write_mem,	// Write memory? in EXE stage.
	input exe_aluc,			// ALU type in EXE stage.
	input exe_alu_imm,		// ALU immediate in EXE stage.
	input exe_shift,		// Shift? in EXE stage.
	input des_r_i,			// Input destination reg.

	input [`RegDataBus] operand_sa,	// Operand(Shift amount).
	input [`RegDataBus] operand_1,	// Operand 1.
	input [`RegDataBus] operand_imm,	// Operand(Immediate).
	input [`RegDataBus] operand_2, 	// Operand 2.

	output reg [`RegDataBus] alu_result,// Operate result.
	output reg [`RegDataBus] e_des_r,	// Destination register.
	output reg [`RegDataBus] write_mem_val			// Save value.
);

	
endmodule
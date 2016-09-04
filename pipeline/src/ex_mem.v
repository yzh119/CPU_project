`include "macros.v"

module ex_mem (
	input clk,  	// Clock
	input rst,		// Reset

	input exe_write_reg,	// Write register? in EXE stage.
	input exe_mem_to_reg,	// Write memory to register? in EXE stage.
	input exe_write_mem,	// Write memory? in EXE stage.

	input [`RegDataBus] alu_result,		// ALU result.
	input [`RegDataBus] write_mem_val,	// Write memory value.
	input [`RegDataBus] e_des_r,		// Destination reg in MEM stage.
	
	output reg mem_write_reg,  	// Write register? in EXE stage.
	output reg mem_mem_to_reg,	// Write memory to register? in MEM stage.
	output reg mem_write_mem,	// Write memory? in EXE stage.

	output reg [`RegDataBus] alu_result_o,			// ALU result.
	output reg [`RegDataBus] write_mem_val_o,		// Write memory value.
	output reg [`RegDataBus] e_des_r_o,				// Destination reg in MEM stage.
);

	always @(*) begin 
		mem_write_reg 	= exe_write_reg;
		mem_mem_to_reg	= exe_mem_to_reg;
		mem_write_mem	= exe_write_mem;

		alu_result_o  	= alu_result;
		write_mem_val_o	= write_mem_val;
		e_des_r_o		= e_des_r;
	end
endmodule
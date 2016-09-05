`include "macros.v"

module wb (
	input clk,		// Clock
	input rst,		// Reset

//	input w_write_reg,		// Write reg? in WB stage.
	input w_mem_to_reg,		// Mem to reg? in WB stage.

	input [`RegDataBus] data_from_mem,		// Data from memory.
	input [`RegDataBus]	alu_result, 		// ALU result.

	output reg [`RegDataBus] write_data
);
	
	always @(posedge clk) begin 
		if (w_mem_to_reg == `ReadEnable) 
			write_data <= data_from_mem;
		else
			write_data <= alu_result;
	end

endmodule
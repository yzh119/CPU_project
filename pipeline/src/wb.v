`include "macros.v"

module wb (
	input clk,		// Clock

	input w_write_reg_i,		// Write reg? in WB stage.
	input w_mem_to_reg_i,		// Mem to reg? in WB stage.

	input [`RegDataBus] data_from_mem,		// Data from memory.
	input [`RegDataBus]	alu_result, 		// ALU result.
	input [`RegAddrBus] des_reg_i,			// Destination register.

	output reg w_write_reg_o,
	output reg [`RegDataBus] write_data,
	output reg [`RegAddrBus] des_reg_o
);
	
	always @(posedge clk) begin 

		w_write_reg_o 	<= w_write_reg_i;
		des_reg_o 		<= des_reg_i;

		if (w_mem_to_reg_i == `True) 
			write_data <= data_from_mem;
		else
			write_data <= alu_result;
	end

endmodule
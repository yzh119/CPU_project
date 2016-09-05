`include "macros.v"

module mem_wb (
	input clk,  	// Clock.
	input rst,		// Reset.

	input m_write_reg,		// Write reg? in MEM stage.
	input m_mem_to_reg,		// Memory to reg? in MEM stage.

	input [`RegDataBus]	data_from_mem,	// Data fetched in memory.
	input [`RegDataBus] alu_result,		// ALU result.
	input [`RegDataBus] reg_des,		// Register destination.

	output reg w_write_reg,				// Write reg? in WB stage.
	output reg w_mem_to_reg,			// Memory to reg? in WB stage.

	output reg [`RegDataBus] data_from_mem_o,	// Output.
	output reg [`RegDataBus] alu_result_o,		// Output.
	output reg [`RegDataBus] reg_des_o			// Output.
);

	always @(*) begin
		w_write_reg 	= m_write_reg;
		w_mem_to_reg 	= m_mem_to_reg;

		data_from_mem_o	= data_from_mem;
		alu_result_o 	= alu_result;
		reg_des_o 		= reg_des;		
	end

endmodule
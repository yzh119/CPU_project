`include "macros.v"

module if_id (
	input clk,    							// Clock
	input rst,  							// Reset
	input write_pc_ir						// Write PC & IR

	input [`InstAddrBus] 	if_pc,			// Fetched instruction's program counter.
	input [`InstBus]		if_inst,		// Fetched instruction 

	output reg[`InstAddrBus]	id_pc,		// PC to Instruction Decoder.
	output reg[`InstBus]		id_inst		// Instruction to Instruction Decoder.
);

	always @ (posedge clk) begin 
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else begin
			if (!write_pc_ir) begin
				id_pc <= if_pc;
				id_inst <= if_inst;
			end
		end
	end
endmodule
`include "macros.v"

module if_id (
	input clk,    							// Clock
	input write_pc_ir,						// Write PC & IR
	input branch, 							// Branch

	input [`InstAddrBus] 	if_pc,			// Fetched instruction's program counter.
	input [`InstBus]		if_inst,		// Fetched instruction 

	output reg[`InstAddrBus]	id_pc,		// PC to Instruction Decoder.
	output reg[`InstBus]		id_inst		// Instruction to Instruction Decoder.
);

	initial begin 
		id_pc 	<= `ZeroWord;
		id_inst <= `ZeroWord;
	end

	always @ (*) begin 

		if (write_pc_ir == `False) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end

		if (branch == `True) begin 
			id_inst <= `ZeroWord;
		end
	
	end
endmodule
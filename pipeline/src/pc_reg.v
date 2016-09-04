`include "macros.v"
module pc_reg (
	input clk,								//Clock
	input rst,								//Reset
	input[`InstAddrBus]	next_addr_i,		//Input address.
	input write_pc_ir						//Write pc & ir, when we need to add a stall, activate it.
	output[`InstAddrBus] pc_o,				//Output address.
	output ce 								//Chip enable.
);	

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin	
			ce <= `ChipEnable;
		end
	end

	always @ (posedge clk) begin
		if (ce == `ChipEnable) begin 
			if (!write_pc_ir) pc_o <= next_addr_i;
		end else begin
			pc_o <= `ZeroWord;
	end
endmodule
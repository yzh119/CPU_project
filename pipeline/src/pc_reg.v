`include "macros.v"
module pc_reg (
	input clk,								//Clock
	input rst,								//Reset
	input [`InstAddrBus] next_addr_i,		//Input address.
	input write_pc_ir,						//Write pc & ir, when we need to add a stall, activate it.
	output reg [`InstAddrBus] pc_o			//Output address.
);	

	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if (write_pc_ir == `False) pc_o <= next_addr_i;
		end else
			pc_o <= `ZeroWord;
	end
endmodule
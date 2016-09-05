`include "macros.v"

module get_next_addr (
	input clk,								//Clock.
	input branch,							//Branch(from Ctrl_unit)
	input[`InstAddrBus] jump_addr, 			//Jump address.
	input[`InstAddrBus] pc,					//Addr from pc_reg.

	output reg [`InstAddrBus] pc_plus_4,			//pc plus 4.
	output reg [`InstAddrBus] next_addr_o		//Output next addr.						
);

	always @ (*) begin
		pc_plus_4 = pc + 32'h4;
		if (branch) 
			next_addr_o = jump_addr;
		else 
			next_addr_o = pc_plus_4;
	end
endmodule
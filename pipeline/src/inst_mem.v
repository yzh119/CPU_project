`include "macros.v"

module inst_mem (
	input [`InstAddrBus] addr, 		//Address
	output reg[`InstBus] inst 		//Instruction
);
	reg [`InstBus] inst_pool[0: `InstMemNum - 1];

	initial $readmemh( "inst.data", inst_pool);

	always @ (*) begin
		inst = inst_pool[addr[`InstMemNumLog - 1 :2]];
	end
endmodule
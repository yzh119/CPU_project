`include "macros.v"

module inst_mem (
	input [`InstAddrBus] addr, 		//Address
	output reg[`InstBus] inst 		//Instruction
);
	reg [`InstBus] inst_pool[0: `InstMemNum - 1];
	integer i;

	initial begin
		for (i = 0; i < `InstMemNum; i++)
			inst_pool[i] = `ZeroWord;
		
		$readmemh( "inst.data", inst_pool);
	end
	always @ (*) begin
		inst = inst_pool[addr[`InstMemNumLog - 1 :2]];
	end
endmodule
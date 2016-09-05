`include "macros.v"

module inst_mem (
	input clk,						//Clock
	input ce,						//Chip Enable

	input [`InstAddrBus] addr, 		//Address
	output reg[`InstBus] inst 		//Instruction
);
	reg [`InstBus] inst_pool[0: `InstMemNum - 1];

	initial $readmemb("inst.data", inst_pool);

	always @ (*) begin
		if (ce == `ChipEnable)
			inst <= inst_pool[addr[`InstMemNumLog - 1 :2]];
		else
			inst <= `ZeroWord;
	end
endmodule
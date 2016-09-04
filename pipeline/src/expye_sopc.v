`include "macros.v"

module expye_sopc (
	input clk,		// Clock
	input rst, 		// Reset Enable
);
	wire[`InstAddrBus]	inst_addr;
	wire[`InstBus]		inst_data;

	wire				inst_mem_ce;

	expye_CPU expye_CPU_0(
		.clk(clk),
		.rst(rst),
		.inst_addr_o(inst_addr),
		.inst_data_o(inst_data),
		.inst_mem_ce(inst_mem_ce)
		);

	inst_mem inst_mem_0(
		.inst_mem_ce(inst_mem_ce),
		.addr(inst_addr),
		.inst(inst_data)
		);

endmodule
`include "macros.v"
`include "pc_reg.v"
`include "get_next_addr.v"
`include "inst_mem.v"

module tb_fetch_data;
	reg clk = `LowLevel;
	reg rst = `RstEnable;
	reg branch = `BranchNot;

	initial begin
		forever #`HalfPeriodicity clk = ~clk;
	end

	initial begin
		#(3 * `Periodicity)
		rst = `RstDisable;
		#(5 * `Periodicity)
		branch = `Branch;
		#`Periodicity
		branch = `BranchNot;
	end

	initial begin 
		#(25 * `Periodicity)
		$finish;
	end

	initial begin 
		$dumpfile("fetch_data.vcd");
		$dumpvars;
	end

	wire [`InstAddrBus] pc_1;
	wire [`InstAddrBus] pc_2;
	wire write_pc_ir = `WriteDisable;

	pc_reg pc_reg_0(
		 	.clk		(clk),
		 	.rst 		(rst),
		 	.next_addr_i(pc_1),
		 	.write_pc_ir(write_pc_ir),
		 	
		 	.pc_o		(pc_2)
		);

	wire [`InstAddrBus] jump_addr = 32'h8;
	wire [`InstAddrBus] pc_plus_4;

	get_next_addr get_next_addr_0(
			.clk        (clk),
			.branch     (branch),
			.jump_addr 	(jump_addr),
			.pc 		(pc_2),

			.pc_plus_4  (pc_plus_4),
			.next_addr_o (pc_1)
		);

	wire [`InstBus] inst;

	inst_mem inst_mem_0(
			.addr 		(pc_2),
			.inst 		(inst)
		);

endmodule
`timescale 1ns/1ps
`include "expye_cpu.v"

module tb_expye_cpu;
	reg clk = `LowLevel;
	reg rst = `RstEnable; 
	integer i;

	initial begin 
		forever #`HalfPeriodicity clk = ~clk;
	end

	initial begin 
		#(1 * `Periodicity)
		rst = `RstDisable;
	end

	initial begin 
		#(90 * `Periodicity)
		$finish;
	end

	initial begin 
		$dumpfile("pipeline.vcd");
		$dumpvars;
	end

	expye_cpu expye_cpu_0(
			.clk	(clk),
			.rst 	(rst)
		);

endmodule
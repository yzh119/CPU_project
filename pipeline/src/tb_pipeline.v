/*
 * Written by Zihao Ye(expye) on 2016.08.27
 */

`include "macros.v"

`timescale 1ns/1ps

module tb_pipeline;

	reg clk;
	reg rst;

	initial begin 
		clk = 1'h0;
		forever #`HalfPeriodicity clk = ~clk;
	end

	initial begin:
		rst = `RstEnable;
		#195 rst = `RstDisable;
		#1000 $finish;
	end

	initial begin:
		$dumpfile("pipeline.vcd");
		$dumpvars;
	end

	expye_sopc expye_sopc_0(
		.clk(clk),
		.rst(rst)
	);
endmodule
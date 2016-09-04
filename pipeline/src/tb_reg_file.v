`include "reg_file.v"
`include "macros.v"

`timescale 1ns/1ps
module tb_reg_file;
	reg clk;
	reg write_reg;
	reg[`RsRtRdBus] rs;
	reg[`RsRtRdBus] rt;
	reg[`RegAddrBus] reg_des;
	reg[`RegDataBus] reg_data;

	wire[`RegDataBus] rs_o;
	wire[`RegDataBus] rt_o;

	initial begin 
		clk  		= 1'b0;
		write_reg 	= `WriteEnable;
		rs 			= 5'h11;
		rt 			= 5'h12;
		reg_des 	= 5'h11;
		reg_data 	= 32'h1324;
		forever #10 clk = ~clk;
	end

	reg_file reg_file_0(
		.clk(clk),
		.w_write_reg(write_reg),
		.rs(rs),
		.rt(rt),
		.reg_des(reg_des),
		.reg_data(reg_data),
		.rs_o(rs_o),
		.rt_o(rt_o)
		);


	initial begin
		#15
		reg_des = 5'h12;
		reg_data = 32'h1212;
		#25
		reg_des = 5'h11;
		reg_data = 32'h1242;
		#1000
		$finish;
	end


	always @(posedge clk) begin
		$display("%d %d\n", rs_o, rt_o);
	end
endmodule

`include "macros.v"

module reg_file (
	input clk, 						// Clock.

	input w_write_reg,				// Write register? in WRITE stage.
	input jal,

	input [`RegDataBus] jal_addr,
	input [`RsRtRdBus] rs, 			// rs
	input [`RsRtRdBus] rt,			// rt

	input [`RegAddrBus] reg_des,		// Written destination register.
	input [`RegDataBus] reg_data,	// Written data.	

	output reg[`RegDataBus] rs_o,	// Output the value in rs
	output reg[`RegDataBus] rt_o	// Output the value in rt
);

	reg[`RegDataBus] regs[0:`RegNum - 1];
	reg[`RegDataBus] reg0;
	reg[`RegDataBus] reg1;
	reg[`RegDataBus] reg2;
	reg[`RegDataBus] reg3;
	reg[`RegDataBus] reg4;
	reg[`RegDataBus] reg5;
	reg[`RegDataBus] reg6;
	reg[`RegDataBus] reg7;
	reg[`RegDataBus] reg8;
	reg[`RegDataBus] reg9;
	reg[`RegDataBus] reg10;
	reg[`RegDataBus] reg11;
	reg[`RegDataBus] reg12;
	reg[`RegDataBus] reg13;
	reg[`RegDataBus] reg14;
	reg[`RegDataBus] reg15;
	reg[`RegDataBus] reg16;
	reg[`RegDataBus] reg17;
	reg[`RegDataBus] reg18;
	reg[`RegDataBus] reg19;
	reg[`RegDataBus] reg20;
	reg[`RegDataBus] reg21;
	reg[`RegDataBus] reg22;
	reg[`RegDataBus] reg23;
	reg[`RegDataBus] reg24;
	reg[`RegDataBus] reg25;
	reg[`RegDataBus] reg26;
	reg[`RegDataBus] reg27;
	reg[`RegDataBus] reg28;
	reg[`RegDataBus] reg29;
	reg[`RegDataBus] reg30;
	reg[`RegDataBus] reg31;

	integer i;

	initial begin
		for (i = 0; i < `RegNum; i++)
			regs[i] = `ZeroWord;
	end

	always @ (negedge clk) begin
		
		if (w_write_reg == `WriteEnable && reg_des != 5'h0)
			regs[reg_des] <= reg_data;
		
		if (jal == `True) 
			regs[`RegNum - 1] <= jal_addr;

		reg0 <= regs[0];
		reg1 <= regs[1];
		reg2 <= regs[2];
		reg3 <= regs[3];
		reg4 <= regs[4];
		reg5 <= regs[5];
		reg6 <= regs[6];
		reg7 <= regs[7];
		reg8 <= regs[8];
		reg9 <= regs[9];
		reg10 <= regs[10];
		reg11 <= regs[11];
		reg12 <= regs[12];
		reg13 <= regs[13];
		reg14 <= regs[14];
		reg15 <= regs[15];
		reg16 <= regs[16];
		reg17 <= regs[17];
		reg18 <= regs[18];
		reg19 <= regs[19];		
		reg20 <= regs[20];
		reg21 <= regs[21];
		reg22 <= regs[22];
		reg23 <= regs[23];
		reg24 <= regs[24];
		reg25 <= regs[25];
		reg26 <= regs[26];
		reg27 <= regs[27];
		reg28 <= regs[28];
		reg29 <= regs[29];
		reg30 <= regs[30];
		reg31 <= regs[31];
	end

	always @ (negedge clk) begin
		if (rs == `RegAddrBits'h0) begin
			rs_o <= `ZeroWord;
		end else begin
			if (rs == reg_des && w_write_reg == `True)
				rs_o <= reg_data;
			else 
				rs_o <= regs[rs];
		end
	end

	always @ (negedge clk) begin 
		if (rt == `RegAddrBits'h0) begin
			rt_o <= `ZeroWord;
		end else begin
			if (rt == reg_des && w_write_reg == `True)
				rt_o <= reg_data;
			else
				rt_o <= regs[rt];
		end
	end
endmodule
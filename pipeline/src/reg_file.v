`include "macros.v"

module reg_file (
	input clk, 						// Clock.

	input w_write_reg,				// Write register? in WRITE stage.

	input[`RsRtRdBus] rs, 			// rs
	input[`RsRtRdBus] rt,			// rt

	input[`RegAddrBus] reg_des,		// Written destination register.
	input[`RegDataBus] reg_data,	// Written data.	

	output reg[`RegDataBus] rs_o,	// Output the value in rs
	output reg[`RegDataBus] rt_o	// Output the value in rt
);

	reg[`RegDataBus] regs[0:`RegNum - 1];

	always @ (posedge clk) begin
		if (w_write_reg == `WriteEnable)
			regs[reg_des] <= reg_data;
	end

	always @ (negedge clk) begin
	//	if (rs == `RegAddrBits'h0)
	//		rs_o <= `ZeroWord;
	//	else
			rs_o <= regs[rs];
	end

	always @ (negedge clk) begin 
	//	if (rt == `RegAddrBits'h0)
	//		rt_o <= `ZeroWord;
	//	else
			rt_o <= regs[rt];
	end
endmodule
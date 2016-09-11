`include "macros.v"
`include "sa.v"

module ex (
	input clk,    // Clock

	input exe_write_reg, 			// Write register? in EXE stage.
	input exe_mem_to_reg,			// Memory to reg? in EXE stage.
	input exe_write_mem,			// Write memory? in EXE stage.
	input [`ALUBus] exe_aluc,		// ALU type in EXE stage.
	input [`MEMBus] exe_memc,
	input exe_alu_imm,				// ALU immediate in EXE stage.
	input exe_shift,				// Shift? in EXE stage.
	
	input [`RegDataBus] operand_1,		// Operand 1.
	input [`RegDataBus] operand_imm,	// Operand(Immediate).
	input [`RegDataBus] operand_2, 		// Operand 2.
	input [`RegAddrBus] des_r_i,		// Input destination reg.

	output reg exe_write_reg_o,						// Write register? in EXE stage.(Output)
	output reg exe_mem_to_reg_o,					// Mem to reg? (Output)
	output reg exe_write_mem_o,						// Write memory? (Output)

	output reg [`MEMBus] mem_memc,
	output [`RegDataBus] alu_result,				// Operate result.
	output reg [`RegAddrBus] e_des_r,				// Destination register.
	output reg [`RegDataBus] write_mem_val			// Save value.
);
	
	wire [`RegDataBus] shamt;
	reg [`RegDataBus] alu_op_1;
	reg [`RegDataBus] alu_op_2;
	reg [`ALUBus] this_aluc;

	sa sa_0(
			.imme_after_extension	(operand_imm),
			.shamt					(shamt)
		);

	always @ (posedge clk) begin

		this_aluc 			<= exe_aluc;
		mem_memc 			<= exe_memc;
		exe_write_reg_o 	<= exe_write_reg;
		exe_mem_to_reg_o	<= exe_mem_to_reg;
		exe_write_mem_o		<= exe_write_mem;
		e_des_r 			<= des_r_i;
		write_mem_val		<= operand_2;

		if (exe_alu_imm == `True) 
			alu_op_2 	<= operand_imm;
		else 
			alu_op_2 	<= operand_2;

		if (exe_shift == `True)
			alu_op_1 	<= shamt;
		else
			alu_op_1 	<= operand_1;
	end

	wire [`RegDataBus] hi;
	wire [`RegDataBus] lo;

	wire [`RegDataBus] alu_hi;
	wire [`RegDataBus] alu_lo;

	wire write_hi_lo;

	alu alu_0(
			.clk 			(clk),
			.aluc      		(this_aluc),
			.alu_op_1  		(alu_op_1),
			.alu_op_2  		(alu_op_2),

			.alu_op_hi  	(alu_hi),
			.alu_op_lo  	(alu_lo),

			.write_hi_lo	(write_hi_lo),
			.alu_result 	(alu_result),
			.hi 			(hi),
			.lo    			(lo)
		);

	hi_lo hi_lo_0(
			.write_hi_lo	(write_hi_lo),
			.hi_i       	(hi),
			.lo_i	      	(lo),

			.hi_o       	(alu_hi),
			.lo_o       	(alu_lo)
		);
	
endmodule

module alu (
	input clk,

	input [`ALUBus] aluc,			// ALU type
	input [`RegDataBus] alu_op_1, 	// Operand_1
	input [`RegDataBus] alu_op_2, 	// Operand_2

	input [`RegDataBus] alu_op_hi,
	input [`RegDataBus] alu_op_lo,

	output reg write_hi_lo,
	output reg [`RegDataBus] alu_result, // ALU result.
	output reg [`RegDataBus] hi,
	output reg [`RegDataBus] lo
);

	always @ (negedge clk) begin

		write_hi_lo <= `False;

		case (aluc)
			`ALU_ADD:
				alu_result <= alu_op_1 	+ 	alu_op_2;
			`ALU_SUB:
				alu_result <= alu_op_1 	- 	alu_op_2;
			`ALU_AND:
				alu_result <= alu_op_1 	& 	alu_op_2;
			`ALU_OR:
				alu_result <= alu_op_1 	| 	alu_op_2;
			`ALU_XOR:
				alu_result <= alu_op_1 	^ 	alu_op_2;
			`ALU_NOR:
				alu_result <= alu_op_1 	~| 	alu_op_2;
			`ALU_SLT:
				alu_result <= $signed(alu_op_1) < $signed(alu_op_2);
			`ALU_SLTU:
				alu_result <= alu_op_1 	<	alu_op_2;
			`ALU_SLL:
				alu_result <= alu_op_2 	<< 	alu_op_1[`ShamtBus];
			`ALU_SRL:
				alu_result <= alu_op_2 	>> 	alu_op_1[`ShamtBus];
			`ALU_SLA:
				alu_result <= alu_op_2 	<<< alu_op_1[`ShamtBus];
			`ALU_SRA: begin
				alu_result <= $signed(alu_op_2)	>>> alu_op_1[`ShamtBus];   
			end
			`ALU_LUI:
				alu_result <= alu_op_2 	<< `HalfWordLength;
			`ALU_MUL: begin
				alu_result 	<= `ZeroWord;
				write_hi_lo	<= `True;
				{hi, lo}	<= {`ZeroWord, alu_op_1} * {`ZeroWord, alu_op_2};
			end
			`ALU_DIV: begin 
				alu_result 	<= `ZeroWord;
				write_hi_lo <= `True;
				lo 			<= $signed(alu_op_1) / $signed(alu_op_2);
				hi 			<= $signed(alu_op_1) % $signed(alu_op_2);
			end
			`ALU_DIVU: begin 
				alu_result 	<= `ZeroWord;
				write_hi_lo <= `True;
				lo 			<= alu_op_1 / alu_op_2;
				hi 			<= alu_op_1 % alu_op_2;
			end
			`ALU_MFLO:
				alu_result 	<= alu_op_lo;
			`ALU_MFHI:
				alu_result 	<= alu_op_hi;
			default : alu_result <= alu_op_1;
		endcase

	end

endmodule

module hi_lo (
	input write_hi_lo,
	input [`RegDataBus] hi_i,
	input [`RegDataBus] lo_i,

	output reg [`RegDataBus] hi_o,
	output reg [`RegDataBus] lo_o
);
	reg [`RegDataBus] hi;
	reg [`RegDataBus] lo;

	initial begin
		hi = `ZeroWord;
		lo = `ZeroWord;
	end

	always @(*) begin 
		if (write_hi_lo == `True) begin
			hi = hi_i;
			lo = lo_i;
		end
		hi_o = hi;
		lo_o = lo;
	end

endmodule
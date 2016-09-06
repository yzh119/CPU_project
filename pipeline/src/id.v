`include "macros.v"

module id (
	input clk,						// Clock

	input[`InstAddrBus] inst_addr, 	// Instruction address
	input[`InstBus] 	inst, 		// Instruction

	input[`ALUBus]	oprand_1_port_1,	// Oprand 1 port 1
	input[`ALUBus]	oprand_1_port_2, 	// Oprand 1 port 2
	input[`ALUBus]	oprand_1_port_3, 	// Oprand 1 port 3
	input[`ALUBus]	oprand_1_port_4, 	// Oprand 1 port 4

	input[`ALUBus]	oprand_2_port_1,	// Oprand 2 port 1
	input[`ALUBus]	oprand_2_port_2, 	// Oprand 2 port 2
	input[`ALUBus]	oprand_2_port_3, 	// Oprand 2 port 3
	input[`ALUBus]	oprand_2_port_4, 	// Oprand 2 port 4

	input reg_rt,					// Register destination == rt?
	input jump,						// Jump instruction ?
	input sext_signed,				// Signed or unsigned ?

	input[`ForwardingBus]	fwd_a,		// Forwarding A
	input[`ForwardingBus]	fwd_b,		// Forwarding B

	output reg [`FuncBus]	func, 			// Func
	output reg [`OpcodeBus]	opcode,			// Opcode
	output reg [`RsRtRdBus]	rs, 			// rs
	output reg [`RsRtRdBus] 	rt, 			// rt
	output reg [`RegAddrBus]	reg_des, 		// rd or rt
	output reg [`InstAddrBus] 	jump_addr,		// Jump address
	output reg [`ALUBus]		imm_after_se,	// Immediate after sign extension

	output reg [`RegDataBus]	oprand_1_o, 	// Output oprand_1
	output reg [`RegDataBus] 	oprand_2_o, 	// Output oprand_2
	output reg rs_rt_equ 						// rs == rt ?
);		

	always @ (posedge clk) begin
		
		opcode 	= inst[`OpcodeInInst];
		rs 		= inst[`RsInInst];
		rt 		= inst[`RtInInst];
		func 	= inst[`FuncInInst];

	end

	always @ (*) begin

		if (sext_signed)
			imm_after_se = {{`LengthOfImmeInInst{1'h0}}, inst[`ImmeInInst]};
		else
			imm_after_se = {{`LengthOfImmeInInst{inst[`TopBitOfImmeInInst]}}, inst[`ImmeInInst]};

		if (reg_rt)
			reg_des = inst[`RtInInst];
		else
			reg_des = inst[`RdInInst];
	
/* This part is used to distinguish two instructions:
 * 
 * 1. beq(ne) $rs, $rt, C (I-type, C takes 15:0)
 * 		if ($rs == $rt) goto PC + 4 + (PC << 2)
 * 
 * 2. j C(J-type, C takes 25:0) 
 *		PC = {(PC + 4)[31:28], C}
 */
		if (jump)	
			jump_addr = {inst_addr[`ConcatenateBitsForJumpInInst], inst[`AddressInInst], 2'h0};
		else
			jump_addr = inst_addr + {inst[`ImmeInInst], 2'h0};

		case (fwd_a)
			`PortSel1: oprand_1_o = oprand_1_port_1;
			`PortSel2: oprand_1_o = oprand_1_port_2;
			`PortSel3: oprand_1_o = oprand_1_port_3;
			`PortSel4: oprand_1_o = oprand_1_port_4;
		endcase // fwd_a

		case (fwd_b)
			`PortSel1: oprand_2_o = oprand_2_port_1;
			`PortSel2: oprand_2_o = oprand_2_port_2;
			`PortSel3: oprand_2_o = oprand_2_port_3;
			`PortSel4: oprand_2_o = oprand_2_port_4;
		endcase

		if (oprand_1_o == oprand_2_o)
			rs_rt_equ = `RsRtEqual;
		else 
			rs_rt_equ = `RsRtNotEqual;

	end
endmodule
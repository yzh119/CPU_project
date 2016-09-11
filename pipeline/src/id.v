`include "macros.v"

module id (
	input clk,						// Clock

	input[`InstAddrBus] inst_addr, 			// Instruction address
	input[`InstBus] 	inst, 				// Instruction

	input[`RegDataBus]	operand_1_port_1,	// Operand 1 port 1
	input[`RegDataBus]	operand_1_port_2, 	// Operand 1 port 2
	input[`RegDataBus]	operand_1_port_3, 	// Operand 1 port 3
	input[`RegDataBus]	operand_1_port_4, 	// Operand 1 port 4

	input[`RegDataBus]	operand_2_port_1,	// Operand 2 port 1
	input[`RegDataBus]	operand_2_port_2, 	// Operand 2 port 2
	input[`RegDataBus]	operand_2_port_3, 	// Operand 2 port 3
	input[`RegDataBus]	operand_2_port_4, 	// Operand 2 port 4

	input reg_rt,					// Register destination == rt?
	input [`JumpBus] jump,			// Jump instruction ?
	input sext_signed,				// Signed or unsigned ?

	input[`ForwardingBus]	fwd_a,		// Forwarding A
	input[`ForwardingBus]	fwd_b,		// Forwarding B

	output reg [`FuncBus]		func, 			// Func
	output reg [`OpcodeBus]		opcode,			// Opcode
	output reg [`RsRtRdBus]		rs, 			// rs
	output reg [`RsRtRdBus] 	rt, 			// rt
	output reg [`RegAddrBus]	reg_des, 		// rd or rt
	output reg [`InstAddrBus] 	jump_addr,		// Jump address
	output reg [`RegDataBus]	imm_after_se,	// Immediate after sign extension

	output reg [`RegDataBus]	operand_1_o, 	// Output operand_1
	output reg [`RegDataBus] 	operand_2_o, 	// Output operand_2
	output reg [`RegDataBus] 	jal_addr,
	output reg rs_rt_equ 						// rs == rt ?
);		

	reg [`InstBus] this_inst;
	reg [`InstBus] this_inst_addr;

	always @ (posedge clk) begin
		
		opcode 	<= inst[`OpcodeInInst];
		rs 		<= inst[`RsInInst];
		rt 		<= inst[`RtInInst];
		func 	<= inst[`FuncInInst];
		this_inst 		<= inst;
		this_inst_addr	<= inst_addr;
		jal_addr		<= inst_addr;

	end

	always @ (
			this_inst_addr, 		
			this_inst, 			
			operand_1_port_1,
			operand_1_port_2,
			operand_1_port_3,
			operand_1_port_4,
			operand_2_port_1,
			operand_2_port_2,
			operand_2_port_3,
			operand_2_port_4,
			reg_rt,		
			jump,			
			sext_signed,
			fwd_a,
			fwd_b,
			operand_1_o
		) begin

		if (sext_signed)
			imm_after_se = {{`LengthOfImmeInInst{this_inst[`TopBitOfImmeInInst]}}, this_inst[`ImmeInInst]};
		else
			imm_after_se = {{`LengthOfImmeInInst{1'h0}}, this_inst[`ImmeInInst]};
			
		if (reg_rt)
			reg_des = this_inst[`RtInInst];
		else
			reg_des = this_inst[`RdInInst];
	
/* This part is used to distinguish two instructions:
 * 
 * 1. beq(ne) $rs, $rt, C (I-type, C takes 15:0)
 * 		if ($rs == $rt) goto PC + 4 + (C << 2)
 * 
 * 2. j C(J-type, C takes 25:0) 
 *		PC = {(PC + 4)[31:28], C << 2}
 */

		case (jump)
			`JumpJ: jump_addr = {this_inst_addr[`ConcatenateBitsForJumpInInst], this_inst[`AddressInInst], 2'h0};
			`JumpB: jump_addr = this_inst_addr + {this_inst[`ImmeInInst], 2'h0};
			`JumpJR: jump_addr = operand_1_o;
			default: jump_addr = `ZeroWord;
		endcase

		case (fwd_a)
			`PortSel1: operand_1_o = operand_1_port_1;
			`PortSel2: operand_1_o = operand_1_port_2;
			`PortSel3: operand_1_o = operand_1_port_3;
			`PortSel4: operand_1_o = operand_1_port_4;
			default:   operand_1_o = operand_1_port_1;
		endcase // fwd_a

		case (fwd_b)
			`PortSel1: operand_2_o = operand_2_port_1;
			`PortSel2: operand_2_o = operand_2_port_2;
			`PortSel3: operand_2_o = operand_2_port_3;
			`PortSel4: operand_2_o = operand_2_port_4;
			default:   operand_2_o = operand_2_port_1;
		endcase

		if (operand_1_o == operand_2_o)
			rs_rt_equ = `RsRtEqual;
		else 
			rs_rt_equ = `RsRtNotEqual;

	end
endmodule
	
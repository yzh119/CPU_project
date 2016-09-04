`include "macros.v"

module control_unit (
	input clk,						// Clock
	input m_mem_to_reg,				// Mem to Reg in stage MEM
	input m_write_reg,				// Write Reg in stage MEM
	input m_des_r,					// Destination Reg in stage MEM
	input e_des_r,					// Destination Reg in stage EXE
	input e_write_reg,				// Write Reg in stage EXE
	input rs_rt_equ,				// rs == rt ?
	output reg write_reg,				// Write Reg
	output reg mem_to_reg,				// Mem to Reg
	output reg write_mem,				// Write Mem
	output reg [`ALUBus] aluc,				// ALUcontrol
	output reg shift,					// Shift Mul
	output reg alu_imm,					// ALU Immediate
	output reg sext_signed,				// Sign extension == signed ?
	output reg reg_rt,					// Destination Reg == rt?
	output reg [`ForwardingBus] fwd_b,	// Forwarding B
	output reg [`ForwardingBus] fwd_a,	// Forwarding A
	output reg jump,					// Jump Mul
	output reg write_pc_ir,				// Write PC & IR
	output reg branch					// Branch
);


endmodule
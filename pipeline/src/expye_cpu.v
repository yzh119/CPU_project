`include "macros.v"
`include "pc_reg.v"
`include "get_next_addr.v"
`include "reg_file.v"
`include "inst_mem.v"
`include "if_id.v"
`include "id.v"
`include "control_unit.v"
`include "ex.v"
`include "mem.v"
`include "wb.v"

module expye_cpu(
		input clk,
		input rst
	);
	
	wire [`InstAddrBus] pc_1;
	wire [`InstAddrBus] pc_2;
	wire ctl_write_pc_ir;
	wire ctl_branch;

	pc_reg pc_reg_0(
			.clk        (clk),
			.rst        (rst),
			.next_addr_i(pc_1),
			.write_pc_ir(ctl_write_pc_ir),

			.pc_o       (pc_2)
		);

	wire [`InstAddrBus] jump_addr;
	wire [`InstAddrBus] pc_plus_4;

	get_next_addr get_next_addr_0(
			.clk        (clk),
			.branch     (ctl_branch),
			.jump_addr  (jump_addr),
			.pc         (pc_2),

			.pc_plus_4  (pc_plus_4),
			.next_addr_o(pc_1)
		);

	wire [`InstBus] inst;

	inst_mem inst_mem_0(
			.addr 		(pc_2),
			.inst 		(inst)
		);


	wire [`InstAddrBus] id_pc;
	wire [`InstBus]		id_inst;

	if_id if_id_0(
			.clk    		(clk),
			.write_pc_ir	(ctl_write_pc_ir),
			.branch     	(ctl_branch),
			.if_pc  		(pc_plus_4),
			.if_inst 		(inst),

			.id_pc			(id_pc),
			.id_inst 		(id_inst)	
		);

	wire [`RsRtRdBus] id_rs;
	wire [`RsRtRdBus] id_rt;
	wire [`FuncBus] id_func;
	wire [`OpcodeBus] id_op;	

	wire [`RegDataBus] rs_o;
	wire [`RegDataBus] rt_o;

	wire rs_rt_equ;

	wire [`RegDataBus] op_after_sel_1;
	wire [`RegDataBus] op_after_sel_2;
	wire [`RegAddrBus] id_reg_des;
	wire [`RegDataBus] op_imm;

	wire ctl_write_reg;
	wire ctl_mem_to_reg;
	wire ctl_write_mem;
	wire [`ALUBus] ctl_aluc;
	wire ctl_shift;
	wire ctl_alu_imm;
	wire ctl_sext_signed;
	wire ctl_reg_rt;
	wire [`ForwardingBus] ctl_fwd_a;
	wire [`ForwardingBus] ctl_fwd_b;
	wire [`JumpBus] ctl_jump;

	wire [`RegDataBus] alu_result;

	wire [`RegDataBus] data_from_mem;
	wire [`RegDataBus] mem_alu_result;

	wire jal;
	wire [`RegDataBus] jal_addr;

	id id_0(
			.clk        	(clk),

			.inst_addr 		(id_pc),
			.inst 			(id_inst),

			.operand_1_port_1 	(rs_o),
			.operand_1_port_2	(alu_result),
			.operand_1_port_3 	(mem_alu_result),
			.operand_1_port_4 	(data_from_mem),

			.operand_2_port_1 	(rt_o),
			.operand_2_port_2 	(alu_result),
			.operand_2_port_3 	(mem_alu_result),
			.operand_2_port_4 	(data_from_mem),

			.reg_rt 		(ctl_reg_rt),
			.jump        	(ctl_jump),
			.sext_signed 	(ctl_sext_signed),

			.fwd_a 			(ctl_fwd_a),
			.fwd_b 			(ctl_fwd_b),

			.func        	(id_func),
			.opcode      	(id_op),
			.rs          	(id_rs),
			.rt 			(id_rt),
			.reg_des     	(id_reg_des),
			.jump_addr   	(jump_addr),
			.imm_after_se	(op_imm),

			.operand_1_o 	(op_after_sel_1),
			.operand_2_o 	(op_after_sel_2),
			.jal_addr    	(jal_addr),
			.rs_rt_equ   	(rs_rt_equ)
		);


	wire w_write_reg;

	wire [`RegAddrBus] reg_des;
	wire [`RegDataBus] reg_data;

	reg_file reg_file_0(
			.clk        (clk),
			.w_write_reg(w_write_reg),
			.jal        (jal),

			.jal_addr   (jal_addr),
			.rs 	 	(id_rs),
			.rt 		(id_rt),

			.reg_des 	(reg_des),
			.reg_data 	(reg_data),

			.rs_o 		(rs_o),
			.rt_o 		(rt_o)
		);

	wire m_mem_to_reg;
	wire m_write_reg;
	wire [`RegAddrBus] m_des_r;
	wire [`RegAddrBus] e_des_r;
	wire e_mem_to_reg;
	wire e_write_reg;

	control_unit control_unit_0(
			.m_mem_to_reg 		(m_mem_to_reg),
			.m_write_reg 		(m_write_reg),
			.m_des_r     		(m_des_r),
			.e_des_r     		(e_des_r),
			.e_mem_to_reg 		(e_mem_to_reg),
			.e_write_reg 		(e_write_reg),
			.rs_rt_equ   		(rs_rt_equ),
			.func        		(id_func),
			.opcode      		(id_op),
			.rs          		(id_rs),
			.rt          		(id_rt),

			.jal         		(jal),
			.write_reg   		(ctl_write_reg),
			.mem_to_reg  		(ctl_mem_to_reg),	
			.write_mem   		(ctl_write_mem),
			.aluc        		(ctl_aluc),
			.shift       		(ctl_shift),
			.alu_imm     		(ctl_alu_imm),
			.sext_signed 		(ctl_sext_signed),
			.reg_rt      		(ctl_reg_rt),
			.fwd_a       		(ctl_fwd_a),
			.fwd_b       		(ctl_fwd_b),
			.jump        		(ctl_jump),
			.write_pc_ir 		(ctl_write_pc_ir),
			.branch      		(ctl_branch)
		);

	wire [`RegDataBus] write_mem_val;
	wire e_write_mem;

	ex ex_0(
			.clk            (clk),

			.exe_write_reg  (ctl_write_reg),
			.exe_mem_to_reg (ctl_mem_to_reg),
			.exe_write_mem  (ctl_write_mem),
			.exe_aluc       (ctl_aluc),
			.exe_alu_imm    (ctl_alu_imm),
			.exe_shift      (ctl_shift),

			.operand_1      (op_after_sel_1),
			.operand_imm    (op_imm),
			.operand_2      (op_after_sel_2),
			.des_r_i        (id_reg_des),

			.exe_write_reg_o	(e_write_reg),
			.exe_mem_to_reg_o	(e_mem_to_reg),
			.exe_write_mem_o 	(e_write_mem),

			.alu_result     (alu_result),
			.e_des_r        (e_des_r),
			.write_mem_val  (write_mem_val)
		);

	mem mem_0(
			.clk           (clk),

			.m_write_reg_i (e_write_reg),
			.m_mem_to_reg_i(e_mem_to_reg),
			.m_write_mem   (e_write_mem),

			.alu_result_i  (alu_result),
			.write_mem_val (write_mem_val),
			.m_des_r       (e_des_r),

			.m_write_reg_o (m_write_reg),
			.m_mem_to_reg_o(m_mem_to_reg),

			.data_from_mem (data_from_mem),
			.alu_result_o  (mem_alu_result),
			.m_des_r_o     (m_des_r)
		);

	wb wb_0(
			.clk          (clk),

			.w_write_reg_i	(m_write_reg),
			.w_mem_to_reg_i	(m_mem_to_reg),

			.data_from_mem 	(data_from_mem),
			.alu_result    	(mem_alu_result),
			.des_reg_i     	(m_des_r),

			.w_write_reg_o 	(w_write_reg),
			.write_data    	(reg_data),
			.des_reg_o     	(reg_des)	
		);

endmodule
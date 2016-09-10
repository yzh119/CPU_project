`include "macros.v"

module mem (
	input clk,		// Clock.

	input m_write_reg_i,		// Write reg? in MEM stage.(input)
	input m_mem_to_reg_i,		// Memory to reg? in MEM stage.(input)
	input m_write_mem,			// Write mem? in MEM stage.

	input [`RegDataBus] alu_result_i,		// ALU result
	input [`RegDataBus] write_mem_val,	// Write memory value.
	input [`RegAddrBus]	m_des_r,		// Destination reg in MEM stage(input).

	output reg m_write_reg_o,	// Write reg? in MEM stage.(output)
	output reg m_mem_to_reg_o,	// Memory to reg? in MEM stage.(output)

	output reg [`RegDataBus] data_from_mem,		// Fetched data.
	output reg [`RegDataBus] alu_result_o,		// ALU result.
	output reg [`RegAddrBus] m_des_r_o			// Destination reg in MEM stage(output).
);
	reg [`RegDataBus] mem_pool[0: `DataMemNum - 1];
	
	initial begin 
		$readmemh("ram.data", mem_pool, 0, 25);
	end

	always @(posedge clk) begin 
		m_write_reg_o 	<= m_write_reg_i;
		m_mem_to_reg_o 	<= m_mem_to_reg_i;
		m_des_r_o		<= m_des_r;
		alu_result_o	<= alu_result_i;

		if (m_write_mem == `True)
			mem_pool[alu_result_i[`DataMemNumLog - 1 : 0]] <= write_mem_val;
		
		if (m_mem_to_reg_i == `True)
			data_from_mem <= mem_pool[alu_result_i[`DataMemNumLog - 1 : 0]];
	end

endmodule
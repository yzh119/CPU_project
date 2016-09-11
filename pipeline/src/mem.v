`include "macros.v"

module mem (
	input clk,		// Clock.

	input m_write_reg_i,		// Write reg? in MEM stage.(input)
	input m_mem_to_reg_i,		// Memory to reg? in MEM stage.(input)
	input m_write_mem,			// Write mem? in MEM stage.

	input [`RegDataBus] alu_result_i,	// ALU result
	input [`RegDataBus] write_mem_val,	// Write memory value.
	input [`RegAddrBus]	m_des_r,		// Destination reg in MEM stage(input).
	input [`MEMBus]		mem_memc,

	output reg m_write_reg_o,	// Write reg? in MEM stage.(output)
	output reg m_mem_to_reg_o,	// Memory to reg? in MEM stage.(output)

	output reg [`RegDataBus] data_from_mem,		// Fetched data.
	output reg [`RegDataBus] alu_result_o,		// ALU result.
	output reg [`RegAddrBus] m_des_r_o			// Destination reg in MEM stage(output).
);
	reg [`RegDataBus] mem_pool[0: `DataMemNum - 1];
	reg [`MEMBus] 	  this_memc;
	integer i;

	initial begin 
		for (i = 0; i < `DataMemNum; i++)
			mem_pool[i] = `ZeroWord;

		$readmemh("ram.data", mem_pool);
	end

	always @(posedge clk) begin 
	//	this_memc 		<= mem_memc;
		m_write_reg_o 	<= m_write_reg_i;
		m_mem_to_reg_o 	<= m_mem_to_reg_i;
		m_des_r_o		<= m_des_r;
		alu_result_o	<= alu_result_i;

		if (m_write_mem == `True) begin
			
			if (mem_memc == `MEM_WORD)
				mem_pool[alu_result_i[`DataMemNumLog - 1: 2]] <= write_mem_val;
		
			if (mem_memc == `MEM_HALF) begin
				if (alu_result_i[1] == 1)
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`LowHalf] <= write_mem_val[`LowHalf];
				else
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`HighHalf] <= write_mem_val[`LowHalf]; 
			end

			if (mem_memc == `MEM_BYTE) begin 
				if (alu_result_i[1: 0] == 2'b00)
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FirstByte] <= write_mem_val[`FourthByte];
				if (alu_result_i[1: 0] == 2'b01)
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`SecondByte] <= write_mem_val[`FourthByte];
				if (alu_result_i[1: 0] == 2'b10)
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`ThirdByte] <= write_mem_val[`FourthByte];
				if (alu_result_i[1: 0] == 2'b11)
					mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FourthByte] <= write_mem_val[`LowHalf];
			end
		end

		if (m_mem_to_reg_i == `True) begin

			if (mem_memc == `MEM_WORD)
				data_from_mem <= mem_pool[alu_result_i[`DataMemNumLog - 1: 2]];
		
			if (mem_memc == `MEM_EXT_HALF) begin
				if (alu_result_i[1] == 1)
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`LowHalf]};
				else 
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`HighHalf]};
			end

			if (mem_memc == `MEM_EXT_BYTE) begin 
				if (alu_result_i[1: 0] == 2'b00)
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FirstByte]};
				if (alu_result_i[1: 0] == 2'b01)
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`SecondByte]};
				if (alu_result_i[1: 0] == 2'b10)
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`ThirdByte]};
				if (alu_result_i[1: 0] == 2'b11)
					data_from_mem <= {`ZeroWord, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FourthByte]};
			end

			if (mem_memc == `MEM_HALF) begin
				if (alu_result_i[1] == 1)
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][15]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`LowHalf]};
				else 
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][31]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`HighHalf]};
			end

			if (mem_memc == `MEM_BYTE) begin
				if (alu_result_i[1: 0] == 2'b00)
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][31]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FirstByte]};
				if (alu_result_i[1: 0] == 2'b01)
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][23]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`SecondByte]};
				if (alu_result_i[1: 0] == 2'b10)
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][15]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`ThirdByte]};
				if (alu_result_i[1: 0] == 2'b11)
					data_from_mem <= {{32{mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][7]}}, mem_pool[alu_result_i[`DataMemNumLog - 1: 2]][`FourthByte]};
			end
		end

	end

endmodule
`include "macros.v"

module sa (
	input [`RegDataBus] imme_after_extension, 	// Immediate after extension.
	output reg [`RegDataBus] shamt 				// Shift amount.
);
	always @ (*) begin 
		shamt = (imme_after_extension >> 3'h6) & 32'h1f;	
	end

endmodule
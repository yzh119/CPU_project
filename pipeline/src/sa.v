`include "macros.v"

module sa (
	input [`RegDataBus] imme_after_extension, 	// Immediate after extension.
	output [`RegDataBus] shamt 				// Shift amount.
);
	assign shamt = (imme_after_extension >> 3'h6) & 32'h1f;
endmodule
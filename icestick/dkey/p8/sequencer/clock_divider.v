// Clock divider
module clock_divider #(
	// Parameters
	parameter			COUNT_WIDTH	= 24,
	parameter [COUNT_WIDTH:0]	MAX_COUNT	= 12000000 - 1

)(
	// Inputs
	input			clk,

	// Outputs
	output			out
);

	// Internal signals
	reg [COUNT_WIDTH:0] count = 0;

	// Clock divider
	always @ (posedge clk) begin
		count <= (count == MAX_COUNT) ? 0 : count + 1;
	end

	assign out = (count == MAX_COUNT);
endmodule

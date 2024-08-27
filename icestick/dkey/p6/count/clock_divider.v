module clock_divider # (
	// Parameters
	parameter			COUNT_WIDTH		= 32,
	parameter [COUNT_WIDTH:0]	COUNT_MAX		= 12000000 - 1
)(
	// Inputs
	input				clk,
	input				rst,

	// Outputs
	output reg			dclk
);

	reg [COUNT_WIDTH:0] count;

	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			count <= 0;
			dclk <= 0;
		end else if (count == COUNT_MAX) begin
			dclk <= 1;
			count <= 0;
		end else begin
			dclk <= 0;
			count <= count + 1;
		end
	end

endmodule

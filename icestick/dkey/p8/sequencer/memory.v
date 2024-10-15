module memory(
	// Inputs
	input			clk,
	input			w_en,
	input [2:0]		w_addr,
	input [1:0]		w_data,

	input			r_en,
	input [2:0]		r_addr,


	// Outputs
	output reg [1:0]	r_data
);

	/*
	 * We need 3 bits as the address width and 2 bits for the data width.
	 * However, if we do so, yosys will not infer BRAM correctly.
	 */
	reg [7:0]		bram [0:15];

	always @ (posedge clk) begin
		if (w_en) begin
			bram[w_addr] <= w_data;
		end

		if (r_en) begin
			r_data <= bram[r_addr];
		end
	end

endmodule

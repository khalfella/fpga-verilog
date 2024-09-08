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

	//
	reg [7:0]		bram [0:15];

	always @ (posedge clk) begin
		if (w_en) begin
			bram[{2'b00, w_addr}] <= w_data;
		end

		if (r_en) begin
			r_data <= bram[r_addr][1:0];
		end
	end

endmodule

`default_nettype none

module top(
	// Inputs
	input			clk,
	input			rst_nbtn,
	input			set_nbtn,
	input [1:0]		p_nbtn,

	// Outputs
	output [1:0]		leds
);

	// Internal singals
	wire			rst_btn, set_btn;
	wire [1:0]		p_btn;
	wire			div_clk;

	// Storage elements
	reg [1:0]		out1 = 0;
	reg [2:0]		count = 0;

	deb	deb_rst_btn (
		.clk(clk),
		.btn(~rst_nbtn),
		.down(rst_btn)
	);


	deb	deb_set_btn (
		.clk(clk),
		.btn(~set_nbtn),
		.down(set_btn)
	);

	deb	p0_set_btn (
		.clk(clk),
		.btn(~p_nbtn[0]),
		.is_down(p_btn[0])
	);

	deb	p1_set_btn (
		.clk(clk),
		.btn(~p_nbtn[1]),
		.is_down(p_btn[1])
	);


	clock_divider clk_div (
		.clk(clk),
		.out(div_clk)
	);


	// Display module
	reg [2:0]		r_addr = 0;
	wire [1:0]		r_data;

	memory	bram0 (
		.clk(clk),
		.w_en(set_btn),
		.w_addr(count),
		.w_data(p_btn),

		.r_en(1'b1),
		.r_addr(r_addr),
		.r_data(r_data)
	);



	always @ (posedge clk) begin
		if (count != 0 && div_clk) begin
			out1 <= r_data;
			r_addr <= (r_addr == (count - 1)) ? 0 : r_addr + 1;
		end
	end


	always @ (posedge clk) begin
		if (set_btn) begin
			count <= count + 1;
		end
	end

	assign leds = out1;

endmodule

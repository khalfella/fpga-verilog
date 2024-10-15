`default_nettype none

module sequencer #(
	// Parameters
	parameter			COUNT_WIDTH	= 24,
	parameter [COUNT_WIDTH-1:0]	MAX_COUNT	= 12000000 - 1,
	parameter			BNT_DEB_COUNT	= 32'd2000000
) (
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
	reg [1:0]		leds_output = 0;	/* Registered output to LEDs */
	reg [2:0]		w_addr = 0;		/* Next addr to write seq to */
	reg [3:0]		num_seqs = 0;		/* Number of stored seqs */
	reg [2:0]		r_addr = 0;		/* Address to read from */
	wire [1:0]		r_data;			/* Data read from BRAM */

	deb #(
		.MAX_BTN_COUNT(BNT_DEB_COUNT)
	) deb_rst_btn (
		.clk(clk),
		.btn(~rst_nbtn),
		.down(rst_btn)
	);


	deb #(
		.MAX_BTN_COUNT(BNT_DEB_COUNT)
	) deb_set_btn (
		.clk(clk),
		.btn(~set_nbtn),
		.down(set_btn)
	);

	deb #(
		.MAX_BTN_COUNT(BNT_DEB_COUNT)
	) p0_set_btn (
		.clk(clk),
		.btn(~p_nbtn[0]),
		.is_down(p_btn[0])
	);

	deb #(
		.MAX_BTN_COUNT(BNT_DEB_COUNT)
	) p1_set_btn (
		.clk(clk),
		.btn(~p_nbtn[1]),
		.is_down(p_btn[1])
	);


	clock_divider #(
		.COUNT_WIDTH(COUNT_WIDTH),
		.MAX_COUNT(MAX_COUNT)
	) clk_div (
		.clk(clk),
		.out(div_clk)
	);


	// Display module

	memory	bram0 (
		.clk(clk),
		.w_en(set_btn),
		.w_addr(w_addr),
		.w_data(p_btn),

		.r_en(1'b1),
		.r_addr(r_addr),
		.r_data(r_data)
	);



	always @ (posedge clk) begin
		if (set_btn == 1'b1) begin
			w_addr <= w_addr + 1;
			num_seqs <= (num_seqs == 8) ? 8 : num_seqs + 1;
		end
	end

	always @ (posedge clk) begin
		if (num_seqs == 0) begin
			leds_output <= 0;
			r_addr <= 0;
		end else if (num_seqs && div_clk) begin
			leds_output <= r_data;
			r_addr <= (r_addr == (num_seqs - 1)) ? 0 : r_addr + 1;
		end
	end

	assign leds = leds_output;

endmodule

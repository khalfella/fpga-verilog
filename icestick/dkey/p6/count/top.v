`default_nettype none

module top (
	// Inputs
	input				rst_btn,
	input				go_btn,
	input				clk,

	// Outputs
	output				green,
	output [3:0]			led
);

	wire clk_enable;
	wire count_1_last;
	wire count_2_last;

	wire [3:0] count_1_out;
	wire [3:0] count_2_out;

	clock_divider div_1 (
		.clk(clk),
		.rst(~rst_btn),
		.dclk(clk_enable)
	);

	count_machine #(
		.COUNT_WIDTH(4),
		.COUNT_START(0),
		.COUNT_END(15),
		.COUNT_INCR(1)
	) count_1 (
		.clk(clk),
		.clk_enable(clk_enable),
		.rst(~rst_btn),
		.start(count_2_last),
		.auto_start(1'b1),
		.out(count_1_out),
		.out_last(count_1_last)
	);

	count_machine #(
		.COUNT_WIDTH(4),
		.COUNT_START(14),
		.COUNT_END(1),
		.COUNT_INCR(-1)
	) count_2 (
		.clk(clk),
		.clk_enable(clk_enable),
		.rst(~rst_btn),
		.start(count_1_last),
		.auto_start(1'b0),
		.out(count_2_out),
		.out_last(count_2_last)
	);

	assign led = count_1_out | count_2_out;
	assign green = count_1_last || count_2_last;

	
endmodule

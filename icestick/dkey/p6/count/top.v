`default_nettype none

module top (
	// Inputs
	input				rst_btn,
	input				go_btn,
	input				clk,

	// Outputs
	output				green,
	output reg [3:0]		led
);

	wire clk_enable;
	wire count_1_valid, count_1_last;
	wire count_2_valid, count_2_last;

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
		.start(~go_btn || count_2_last),
		.out(count_1_out),
		.out_valid(count_1_valid),
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
		.out(count_2_out),
		.out_valid(count_2_valid),
		.out_last(count_2_last)
	);


	always @ ( * ) begin
		if (count_1_valid) begin
			led = count_1_out;
		end else if (count_2_valid) begin
			led = count_2_out;
		end else begin
			led = 0;
		end

	end


	assign green = count_1_last || count_2_last;

	
endmodule

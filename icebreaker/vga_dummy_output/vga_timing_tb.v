`timescale 1 ns / 10 ps

module vga_timing_tb();

	reg		clk = 0;
	reg		rst = 0;
	

	localparam	CLK = 12.5;	// 40MHz
	localparam	DURATION = 24000000;

	always begin
		#(CLK)
		clk = ~clk;
	end

	wire [9:0]	x;
	wire [9:0]	y;
	wire		in_frame;
	wire		hsync;
	wire		vsync;

	vga_timing uut (
		.clk(clk),
		.reset(rst),
		.x(x),
		.y(y),
		.in_frame(in_frame),
		.hsync(hsync),
		.vsync(vsync)
	);

	/*
	 * No need to fiddle with bits for now
	 */

	// Run simulation
	initial begin
		$dumpfile("vga_timing_tb.vcd");
		$dumpvars(0, vga_timing_tb);

		#(DURATION)
		
		$display("Finished");
		$finish;
	end

endmodule

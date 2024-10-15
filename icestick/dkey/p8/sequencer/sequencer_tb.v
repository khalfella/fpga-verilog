// Define timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

module sequencer_tb();
	// Internal signals
	wire	out;

	// Storage elements (set initial values to 0)
	reg		clk		= 0;
	reg		rst_nbtn	= 1'b1;
	reg		set_nbtn	= 1'b1;
	reg [1:0]	p_nbtn		= 2'b11;

	wire [1:0]	leds_output;

	// Simulation time: 10000 * 1 ns = 10 us
	localparam DURATION= 100000;

	// Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
	always begin
		// Delay for 41.67 time units
		// 10 ps precision mean that 41.667 is rounded to 41.67 ns
		#41.667

		// Toggle clock line
		clk = ~clk;
	end


	sequencer #(
		.COUNT_WIDTH(10),
		.MAX_COUNT(10),
		.BNT_DEB_COUNT(3)
	) uut (
		.clk(clk),
		.rst_nbtn(rst_nbtn),
		.set_nbtn(set_nbtn),
		.p_nbtn(p_nbtn),
		.leds(leds_output)
	);

	initial begin
		#(4 * 41.667)
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b10;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b11;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b10;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b01;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b00;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b01;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
		#(10 * 41.667)

		p_nbtn = 2'b10;
		set_nbtn = 0;
		#(16 * 41.667)
		set_nbtn = 1;
	end


	// Run simulation (output to .vcd file)
	initial begin

		// Create simulation output file
		$dumpfile("sequencer_tb.vcd");
		$dumpvars(0, sequencer_tb);

		// Wait for a given amount of time for simulation to complete
		#(DURATION);

		// Notify and end simulation
		$display("Finished!");
		$finish;
	end
endmodule

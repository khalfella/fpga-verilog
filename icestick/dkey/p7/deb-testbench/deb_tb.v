// Button debounce testbench
`timescale 1 ns / 10 ps
module deb_tb();

	// Internal signals
	wire	out;

	// Storage elemets
	reg	clk = 0;
	reg	rst = 0;
	reg	btn = 0;


	// Simulation time: 20000 * 1 ns = 10 us
	localparam DURATION = 20000;


	// Generate clock signal of 12 MHz
	always begin
		#41.667
		clk = ~clk;
	end


	deb #(
		.MAX_BTN_COUNT(20)
	) uut (
		.clk(clk),
		.nrst(~rst),
		.nbtn(~btn),
		.out(out)
	);


	integer i;
	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;

		#100
		btn = 1;
		#160
		for (i = 0; i < 20; i = i + 1) begin
			#3
			btn = 0;
			#3;
			btn = 1;
		end
		#170
		btn = 1;
		#180
		btn = 0;
		

		#8000
		for (i = 0; i < 20; i = i + 1) begin
			#($urandom%5)
			btn = 0;
			#($urandom%5)
			btn = 1;
		end
		#20
		btn = 0;

		
	end


	// Run simulation
	initial begin
		$dumpfile("deb_tb.vcd");
		$dumpvars(0, deb_tb);

		#(DURATION);

		$display("Finished!");
		$finish;
	end


endmodule

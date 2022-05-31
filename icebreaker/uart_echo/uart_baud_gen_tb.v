`timescale 1 ns / 10 ps


module uart_baud_gen_tb();

	reg	clk = 0;
	reg	rst = 0;

	

	localparam CLK      = 11.90;	/* 42 MHz */
	localparam DURATION = 120000;

	always begin
		#(CLK)
		clk = ~clk;
	end

	wire rx_clk;
	wire tx_clk;
	// Instantiate Unit Under Test (uut)
	uart_baud_gen #(
		.CLOCK_RATE(42000000),
		.BAUD_RATE(115200)
	) uut (
		.clk(clk),
		.rst(rst),
		.rx_clk(rx_clk),
		.tx_clk(tx_clk)
	);


	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;
	end


	initial begin
		$dumpfile("uart_baud_gen_tb.vcd");
		$dumpvars(0, uart_baud_gen_tb);
		
		#(DURATION)

		$display("Finished");
		$finish;
	end

endmodule

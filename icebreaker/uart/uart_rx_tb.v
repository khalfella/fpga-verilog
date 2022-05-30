`timescale 1 ns / 10 ps


module uart_rx_tb();

	reg	clk = 0;
	reg	rx_clk = 0;
	reg	rst = 0;


	localparam CLK      = 12;	/* 42 MHz */
	localparam RX_CLK   = 540;	/* 115200 * 16 rx_clock */
	localparam DURATION = 1200000;

	always begin
		#(CLK)
		clk = ~clk;
	end

	reg rx_clk_counter = 0;
	always begin
		#(CLK)
		rx_clk = ~rx_clk;
		#(2 * CLK)
		rx_clk = ~rx_clk;
		#(RX_CLK - 3 * CLK)
		rx_clk = rx_clk;
	end

	reg uart_rx_pin = 1;
	wire [7:0] uart_rx_data;
	wire uart_rx_err;
	wire uart_rx_done;
	wire uart_rx_busy;


	uart_rx rx (
		.clk(clk),
		.rx_clk(rx_clk),
		.enabled(1'b1),
		.rx(uart_rx_pin),

		.data(uart_rx_data),
		.err(uart_rx_err),
		.done(uart_rx_done),
		.busy(uart_rx_busy)
	);
		


	initial begin
		#10
		rst = 1'b1;
		#1
		rst = 1'b0;
		#(RX_CLK)
		uart_rx_pin <= 1;
		#(100*RX_CLK)
		uart_rx_pin <= 0;	// start bit
		#(16*RX_CLK)
		
		uart_rx_pin <= 1;	// 11
		#(2*16*RX_CLK)
		uart_rx_pin <= 0;	// 00
		#(2*16*RX_CLK)
		uart_rx_pin <= 1;	// 111
		#(3*16*RX_CLK)
		uart_rx_pin <= 0;	// 0
		#(1*16*RX_CLK)
		uart_rx_pin <= 1;	// stop bit
		#(16*RX_CLK)
		uart_rx_pin <= 1;
	end



	initial begin
		$dumpfile("uart_rx_tb.vcd");
		$dumpvars(0, uart_rx_tb);
		
		#(DURATION)

		$display("Finished");
		$finish;
	end

endmodule

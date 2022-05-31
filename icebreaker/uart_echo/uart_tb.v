`timescale 1 ns / 10 ps


module uart_tb();

	reg	clk = 0;

	localparam CLK      = 11.90;	/* 42 MHz */
	localparam RX_CLK   = (44 * 11.90); /* for baud rate 115200 and 42MHz clock */
	localparam DURATION = 120000;

	always begin
		#(CLK)
		clk = ~clk;
	end

	reg		uart_rx_pin = 1;
	wire		uart_tx_pin = 1;
	reg		uart_tx_start = 0;
	reg [7:0]	uart_tx_data = 0;
	// Instantiate Unit Under Test (uut)
	uart #(
		.CLOCK_RATE(42000000),
		.BAUD_RATE(115200)
	) uut (
		.clk(clk),
		.uart_rx_pin(uart_rx_pin),
		.uart_tx_pin(uart_tx_pin),
		.uart_tx_start(uart_tx_start),
		.uart_tx_data(uart_tx_data)
	);

	initial begin
		#(16*RX_CLK)
		uart_rx_pin <= 1;
		#(16*RX_CLK)
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
		$dumpfile("uart_tb.vcd");
		$dumpvars(0, uart_tb);
		
		#(DURATION)

		$display("Finished");
		$finish;
	end

endmodule

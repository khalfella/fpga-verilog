`default_nettype none

module uart #(
	parameter			CLOCK_RATE = 42000000,
	parameter			BAUD_RATE = 115200
) (
	input wire			clk,
	input wire			uart_rx_pin,
	output wire			uart_tx_pin,

	input wire			uart_tx_start,
	input wire [7:0]		uart_tx_data,

	output wire			uart_tx_clk,
	output wire			uart_tx_done,
	output wire			uart_tx_busy,

	output wire			uart_rx_clk,
	output wire [7:0]		uart_rx_data,
	output wire			uart_rx_err,
	output wire			uart_rx_done,
	output wire			uart_rx_busy
);

	uart_baud_gen #(
		.CLOCK_RATE(CLOCK_RATE), 
		.BAUD_RATE(BAUD_RATE)
	) uart_baud_gen_unit (
		.clk(clk),
		.rst(1'b0),
		.tx_clk(uart_tx_clk),
		.rx_clk(uart_rx_clk)
	);

	uart_tx uart_tx_unit (
		.clk(clk), 
		.tx_clk(uart_tx_clk),
		.enabled(1'b1),
		.start(uart_tx_start),
		.in(uart_tx_data),

		.tx(uart_tx_pin),
		.done(uart_tx_done),
		.busy(uart_tx_busy)
	);

	uart_rx uart_rx_unit (
		.clk(clk),
		.rx_clk(uart_rx_clk),
		.enabled(1'b1),
		.rx(uart_rx_pin),
		.data(uart_rx_data),
		.err(uart_rx_err),
		.done(uart_rx_done),
		.busy(uart_rx_busy)
	);

endmodule

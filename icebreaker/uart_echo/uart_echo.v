`default_nettype none

module top (
	input wire	CLK,
	input wire	RX,
	output wire 	TX,
	output wire	LEDR_N,
	output wire	LEDG_N
);

	wire clk_42mhz;

	SB_PLL40_PAD #(
	  .DIVR(4'b0000),
	  // 42MHz
	  .DIVF(7'b0110111),
	  .DIVQ(3'b100),
	  .FILTER_RANGE(3'b001),
	  .FEEDBACK_PATH("SIMPLE"),
	  .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
	  .FDA_FEEDBACK(4'b0000),
	  .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
	  .FDA_RELATIVE(4'b0000),
	  .SHIFTREG_DIV_MODE(2'b00),
	  .PLLOUT_SELECT("GENCLK"),
	  .ENABLE_ICEGATE(1'b0)
	) usb_pll_inst (
	  .PACKAGEPIN(CLK),
	  .PLLOUTCORE(clk_42mhz),
	  //.PLLOUTGLOBAL(),
	  .EXTFEEDBACK(),
	  .DYNAMICDELAY(),
	  .RESETB(1'b1),
	  .BYPASS(1'b0),
	  .LATCHINPUTVALUE()
	  //.LOCK(),
	  //.SDI(),
	  //.SDO(),
	  //.SCLK()
	);

	reg uart_tx_start = 0;
	reg [7:0] uart_tx_data = 0;
	wire uart_tx_clk;
	wire uart_tx_done;
	wire uart_tx_busy;

	wire uart_rx_clk;
	reg [7:0] uart_rx_data;
	wire uart_rx_err;
	wire uart_rx_done;
	wire uart_rx_busy;
	uart #(
		.CLOCK_RATE(42000000),
		.BAUD_RATE(115200)
	) uart_unit (
		.clk(clk_42mhz),
		.uart_rx_pin(RX),
		.uart_tx_pin(TX),
		.uart_tx_start(uart_tx_start),
		.uart_tx_data(uart_tx_data),
		.uart_tx_clk(uart_tx_clk),
		.uart_tx_done(uart_tx_done),
		.uart_tx_busy(uart_tx_busy),

		.uart_rx_clk(uart_rx_clk),
		.uart_rx_data(uart_rx_data),
		.uart_rx_err(uart_rx_err),
		.uart_rx_done(uart_rx_done),
		.uart_rx_busy(uart_rx_busy)
	);

	assign LEDG_N = ~uart_rx_busy;
	assign LEDR_N = ~uart_tx_busy;
	always @(posedge clk_42mhz) begin
		if (uart_rx_clk) begin
			if (uart_rx_done) begin
				uart_tx_data <= uart_rx_data;
				uart_tx_start <= 1;
			end
		end
		if (uart_tx_clk) begin
			if (uart_tx_done) begin
				uart_tx_start <= 0;
			end
		end
	end


endmodule

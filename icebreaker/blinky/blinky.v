`default_nettype none

module top # (
	parameter	BLINK_PERIOD_TICKS	= 12000000,		// blink period ticks
	parameter	BLINK_DUTY_TICKS	= 6000000		// blink duty ticks
) (
	input wire	CLK,		// 12MHz clock
	output reg	LEDG_N		// green LED
);

	localparam	CW			= $clog2(BLINK_PERIOD_TICKS);
	reg [CW - 1:0]	counter			= 0;

	always @(posedge CLK) begin
		counter <= (counter == BLINK_PERIOD_TICKS - 1) ? 0 : counter + 1;
		LEDG_N <= (counter < BLINK_DUTY_TICKS);
	end

endmodule

`default_nettype none

module top # (
	parameter	BLINK_PERIOD_TICKS	= 24000000,		// blink period ticks
	parameter	BLINK_DUTY_TICKS	= 12000000		// blink duty ticks
) (
	input wire	CLK,		// 12MHz clock
	output wire	D5
);

	localparam	CW			= $clog2(BLINK_PERIOD_TICKS);
	reg [CW - 1:0]	counter			= 0;

	always @(posedge CLK) begin
		counter <= (counter == BLINK_PERIOD_TICKS - 1) ? 0 : counter + 1;
	end

	assign D5 = (counter < BLINK_DUTY_TICKS);

endmodule

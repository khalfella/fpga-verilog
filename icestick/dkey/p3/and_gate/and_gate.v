// Module: when buttons 1 and 2 are pressed, turn on LED

`default_nettype none

module and_gate(
	// Inputs
	input wire	pmod_0,
	input wire	pmod_1,

	// Output
	output wire	led_0
);

	// Continuous assignment: NOT and AND operators
	assign led_0 = (~pmod_0) & (~pmod_1);

endmodule

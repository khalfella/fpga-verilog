// Module: button 0 lights up 2 LEDs, button 0 and 1 light up another

`default_nettype none

module vector(
	// Inputs
	input wire [1:0]	pmod,

	// Output
	output wire [2:0]	led
);

	// Continuous assignment: NOT and AND operators
	// assign led_0 = (~pmod_0) & (~pmod_1);

	// Wire (net) declarations (internal to module)
	wire not_pmod_0;

	// Continuous assignment: replicate 1 wire to outputs
	assign not_pmod_0 = ~pmod[0];
	assign led[1:0] = {2{not_pmod_0}};


	// Continuous assignment: NOT and AND operators
	assign led[2] = not_pmod_0 & ~pmod[1];

endmodule

// Module: full adder module

`default_nettype none

module fadder (
	// Inputs
	input wire		nA,
	input wire		nB,
	input wire		nCin,

	// Output
	output wire		S,
	output wire		Cout
);


	// Internal wire signals to invert input
	wire A, B, Cin;
	assign {A, B, Cin} = {~nA, ~nB, ~nCin};

	// Continuous assignment for full adder
	assign S = (A ^ B ^ Cin);
	assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule

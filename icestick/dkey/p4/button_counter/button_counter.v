// Count up on each button press and display on LEDs

module button_counter (
	// Inputs
	input wire [1:0]	pmod,

	// Outputs
	output reg [3:0]	led
);


	wire rst;
	wire clk;


	// Reset is the inverse of the first button
	assign rst = ~pmod[0];

	// Clock signal is the inverse of the second button
	assign clk = ~pmod[1];

	// Coun up on clock rising edge or reset on button push
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			led <= 4'b0000;
		end else begin
			led <= led + 1;
		end
	end

endmodule

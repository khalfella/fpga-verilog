// Count up on each button press and display on LEDs

module counter (
	// Inputs
	input wire		clk,	/* 12MHz clock */
	input wire [1:0]	pmod,

	// Outputs
	output reg [3:0]	led
);


	wire rst;

	// Reset is the inverse of the first button
	assign rst = ~pmod[0];

	reg [31:0] count;

	localparam MAXCOUNT = 12000000 - 1;

	// Coun up on clock rising edge or reset on button push
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			led <= 4'b0000;
			count <= 0;
		end else begin
			if (count == MAXCOUNT) begin
				led <= led + 1;
				count <= 0;
			end else begin
				count <= count + 1;
			end
		end
	end

endmodule

`default_nettype none

module vga_timing #(
	// VGA display mode. Units in pixels
	parameter	HZNT_WIDTH	= 800,		// display width
	parameter	HZNT_RRONTP	= 40,		// horizontal front porch
	parameter	HZNT_SYNC	= 128,		// horizontal sync
	parameter	HZNT_BACKP	= 88,		// horizontal back porch
	parameter	VERT_HEIGHT	= 600,		// vertical height
	parameter	VERT_FRONTP	= 1,		// vertical front porch
	parameter	VERT_SYNC	= 4,		// vertical sync
	parameter	VERT_BACKP	= 23,		// vertical back porch

	// Coordinates bit width
	parameter	HZNT_COOR_BITS	= 10,
	parameter	VERT_COOR_BITS	= 10
) (
	input wire	clk,				// per-pixel clock
	input wire	reset,				// async reset signal
	
	output reg [HZNT_COOR_BITS - 1:0] x,		// pixel x-coordinate (0 <= x < HZNT_WIDTH)
	output reg [VERT_COOR_BITS - 1:0] y,		// pixel y-coordinate (0 <= y < VERT_HEIGHT)
	output reg	in_frame,			// whether x and y are within display area
	output reg	hsync,				// in horizontal sync
	output reg	vsync				// in vsync
);

	localparam	HZNT_FULL_WIDTH   = HZNT_WIDTH  + HZNT_RRONTP + HZNT_SYNC + HZNT_BACKP;
	localparam	VERT_FULL_HEIGHT  = VERT_HEIGHT + VERT_FRONTP + VERT_SYNC + VERT_BACKP;
	localparam	HZNT_WIDTH_BITS   = $clog2(HZNT_FULL_WIDTH);
	localparam	VERT_HEIGHT_BITS  = $clog2(VERT_FULL_HEIGHT);


	reg [HZNT_WIDTH_BITS  - 1:0]	hc = 0;		// horizontal counter
	reg [VERT_HEIGHT_BITS - 1:0]	vc = 0; 	// vertical counter

	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			hc <= 0;
			vc <= 0;
		end else begin
			hc <= (hc == HZNT_FULL_WIDTH - 1) ? 0 : hc + 1;
			if (hc == HZNT_FULL_WIDTH - 1) begin
				vc <= (vc == VERT_FULL_HEIGHT - 1) ? 0 : vc + 1;
			end
		end
	end

	assign x = (hc < HZNT_WIDTH)  ? hc : 0;
	assign y = (vc < VERT_HEIGHT) ? vc : 0;
	assign in_frame	= (hc < HZNT_WIDTH && vc < VERT_HEIGHT) ? 1 : 0;
	assign hsync = (hc >= HZNT_WIDTH + HZNT_RRONTP && hc < HZNT_FULL_WIDTH - HZNT_BACKP) ? 1 : 0;
	assign vsync = (vc >= VERT_HEIGHT + VERT_FRONTP && vc < VERT_FULL_HEIGHT - VERT_BACKP) ? 1 : 0;

endmodule

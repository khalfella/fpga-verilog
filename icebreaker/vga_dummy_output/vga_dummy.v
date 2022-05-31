`default_nettype none

module top (
	input		CLK,							// default 12MHz clock
	output		P1A1, P1A2, P1A3, P1A4, P1A7, P1A8, P1A9, P1A10,
	output		P1B1, P1B2, P1B3, P1B4, P1B7, P1B8, P1B9, P1B10
);



	wire	clk_40mhz;
	//-----------------------------------------------------------------------------
	// PLL.
	//-----------------------------------------------------------------------------
	SB_PLL40_PAD #(
	  .DIVR(4'b0000),
	  // 40MHz ish to be exact it is 39.750MHz
	  .DIVF(7'b0110100), // 39.750MHz
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
	) pll_inst (
	  .PACKAGEPIN(CLK),
	  .PLLOUTCORE(),
	  .PLLOUTGLOBAL(clk_40mhz),
	  .EXTFEEDBACK(),
	  .DYNAMICDELAY(),
	  .RESETB(1'b1),
	  .BYPASS(1'b0),
	  .LATCHINPUTVALUE(),
	  //.LOCK(),
	  //.SDI(),
	  //.SDO(),
	  //.SCLK()
	);

	wire		in_frame;
	wire		hsync;
	wire		vsync;
	wire [9:0]	x;
	wire [9:0]	y;
	vga_timing vga_timing_inst (
		.clk(clk_40mhz),
		.reset(1'b0),
		.x(x),
		.y(y),
		.in_frame(in_frame),
		.hsync(hsync),
		.vsync(vsync)
	);
		


	// ----------------------------------------------------------------------------
	// Assign the PMOD(s) pins
	// ----------------------------------------------------------------------------
	// Also add IO registers to minimize timing between lines and ensure we're
	// properly aligned to the clock. Clock is output using a DDR flop and 180deg
	// out of phase (rising edge in middle of data eye) to maximize setup/hold
	// time margin.
	
	SB_IO #(
	  .PIN_TYPE(6'b01_0000)  // PIN_OUTPUT_DDR
	) dvi_clk_iob (
	  .PACKAGE_PIN (P1B2),
	  .D_OUT_0     (1'b0),
	  .D_OUT_1     (1'b1),
	  .OUTPUT_CLK  (clk_40mhz)
	);


	SB_IO #(
	  .PIN_TYPE(6'b01_0100)  // PIN_OUTPUT_REGISTERED
	) dvi_data_iob [14:0] (
	  .PACKAGE_PIN ({P1A1,   P1A2,   P1A3,   P1A4,   P1A7,   P1A8,        P1A9,   P1A10,
			 P1B1,           P1B3,   P1B4,   P1B7,   P1B8,        P1B9,   P1B10}),
	  .D_OUT_0     ({x[4],   y[4],   x[3],   y[3],   x[2],   y[2],   x[1],   y[1],
			 x[1],           y[1],  hsync,   y[0],   x[0],   in_frame, vsync}),

	  .OUTPUT_CLK  (clk_40mhz)
	);

endmodule

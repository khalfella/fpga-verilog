// Count up on each button press and display on LEDs

module deb #(
	parameter		MAX_BTN_COUNT = 32'd2000000
)(
	// Inputs
	input wire		clk,
	input wire		btn,

	// Outputs
	output			down,
	output			up,
	output			is_down,
	output			is_up

);


	localparam STATE_BUTTON_UP		= 3'b000;
	localparam STATE_BUTTON_TRANS_DOWN	= 3'b001;
	localparam STATE_BUTTON_HOLD_DOWN	= 3'b010;
	localparam STATE_BUTTON_DOWN		= 3'b011;
	localparam STATE_BUTTON_TRANS_UP	= 3'b100;
	localparam STATE_BUTTON_HOLD_UP		= 3'b101;

	reg [2:0]		state		= STATE_BUTTON_UP;
	reg [31:0]		count		= 0;

	/*
	 * STATE_BUTTON_UP: The button is up. Wating for the button
	 *  to be pressed.
	 *
	 * STATE_BUTTON_TRANS_DOWN: The button has been pressed. This
	 *  is a transitioning state that signals button press.
	 *
	 * STATE_BUTTON_HOLD_DOWN: The button has been pressed. Holds
	 *  the state that the button is down regardless of the actual
	 *  state of the button. Waits for count == MAX_BTN_COUNT before
	 *  leaving this state. Changes in the actual button state has
	 *  no significance.
	 *
	 * STATE_BUTTON_DOWN: The button is down and the state machine
	 *  is currently waitina for the button to be depressed. As soon
	 *  as the button is depressed we transition to up.
	 *
	 * STTE_BUTTON_TRANS_UP: The button has been depressed. This is
	 *  is a stransitioning states that signals the button has been
	 *  depressed.
	 *
	 * STATE_BUTTON_HOLD_UP: The button has been depressed. Holds
	 *  the state of the button as it is and wait for count to reach
	 *  MAX_BTN_COUNT before declaring the button is up again.
	 */
	always @ (posedge clk) begin
		case (state)
			STATE_BUTTON_UP: begin
				if (btn == 1'b1) begin
					state <= STATE_BUTTON_TRANS_DOWN;
				end
			end
			STATE_BUTTON_TRANS_DOWN: begin
				count <= 0;
				state <= STATE_BUTTON_HOLD_DOWN;
			end
			STATE_BUTTON_HOLD_DOWN: begin
				count <= count + 1;
				if (count == MAX_BTN_COUNT) begin
					state <= STATE_BUTTON_DOWN;
				end
			end
			STATE_BUTTON_DOWN: begin
				if (btn == 1'b0) begin
					state <= STATE_BUTTON_TRANS_UP;
				end
			end
			STATE_BUTTON_TRANS_UP: begin
				count <= 0;
				state <= STATE_BUTTON_HOLD_UP;
			end
			STATE_BUTTON_HOLD_UP: begin
				count <= count + 1;
				if (count == MAX_BTN_COUNT) begin
					state <= STATE_BUTTON_UP;
				end
			end
			default: begin
				state <= STATE_BUTTON_UP;
			end
		endcase
	end


	assign down = (state == STATE_BUTTON_TRANS_DOWN);
	assign is_down = (state == STATE_BUTTON_TRANS_DOWN || state == STATE_BUTTON_HOLD_DOWN || state == STATE_BUTTON_DOWN);
	assign up = (state == STATE_BUTTON_TRANS_UP);
	assign is_up = (state == STATE_BUTTON_TRANS_UP || state == STATE_BUTTON_HOLD_UP || state == STATE_BUTTON_UP);

endmodule

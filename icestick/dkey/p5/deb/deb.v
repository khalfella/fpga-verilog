// Count up on each button press and display on LEDs

module deb (
	// Inputs
	input wire		clk,
	input wire		nrst,
	input wire		nbtn,

	// Outputs
	output reg [3:0]	led
);


	localparam STATE_BUTTON_IDLE	= 2'd0;
	localparam STATE_BUTTON_DOWN	= 2'd1;
	localparam STATE_BUTTON_WAIT	= 2'd2;
	localparam STATE_BUTTON_UP	= 2'd3;

	localparam MAX_BTN_COUNT	= 32'd2000000;

	// Internal signals
	wire rst, btn;
	assign rst = ~nrst;
	assign btn = ~nbtn;

	reg [1:0] state;
	reg [31:0] count;

	/*
	 * The FSM starts with STATE_BUTTON_IDLE. In this state the machine
	 * waits for the button to be pressed for the first time. There will
	 * be one clock transition through STATE_BUTTON_DOWN signalling the
	 * button has been pressed. Then the FSM transitions to STATE_BUTTON_WAIT
	 * where it waits for count to hit MAX_BTN_COUNT. This is the core
	 * part of the button debounce logic. In this state we do discard
	 * any changes to the button whether it is up or down.
	 *
	 * Once count hits MAX_BTN_COUNT the state machine transitions to
	 * STATE_BUTTON_UP. This state waits until it sees the button up.
	 * This is important because we do not want having the button
	 * continuously down register as mutilple down event. Once the button
	 * is seen up, then we transition back to STATE_BUTTON_IDLE state.
	 */
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			state <= STATE_BUTTON_IDLE;
		end else begin
			case (state)
				STATE_BUTTON_IDLE: begin
					if (btn == 1'b1) begin
						state <= STATE_BUTTON_DOWN;
					end
				end
				STATE_BUTTON_DOWN: begin
					state <= STATE_BUTTON_WAIT;
				end
				STATE_BUTTON_WAIT: begin
					if (count == MAX_BTN_COUNT) begin
						state <= STATE_BUTTON_UP;
					end
				end
				STATE_BUTTON_UP: begin
					if (btn == 1'b0) begin
						state <= STATE_BUTTON_IDLE;
					end
				end
				default: begin
					state <= STATE_BUTTON_IDLE;
				end
			endcase
		end
	end

	// Set button counter
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			count <= 0;
		end else begin
			if (state == STATE_BUTTON_WAIT) begin
				count <= count + 1;
			end else begin
				count <= 0;
			end
		end
	end

	// Sets led counter
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			led <= 0;
		end else begin
			if (state == STATE_BUTTON_DOWN) begin
				led <= led + 1;
			end
		end
	end


endmodule

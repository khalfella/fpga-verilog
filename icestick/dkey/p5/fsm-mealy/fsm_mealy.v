// State machine that counts up when go button is pressed

module fsm_mealy (
	// Inputs
	input wire			clk,
	input wire			rst_btn,
	input wire			go_btn,


	// Outputs
	output reg [3:0]		led,
	output reg			done_sig
);

	// States
	localparam STATE_IDLE		= 2'd0;
	localparam STATE_COUNTING	= 2'd1;


	// Max counts for clock divider and counter
	localparam MAX_CLK_COUNT	= 24'd1500000;
	localparam MAX_LED_COUNT	= 4'hf;


	// Internal signals
	wire		rst, go;
	reg  		div_clk;
	reg [1:0] 	state;
	reg [23:0]	clk_count;


	// Invert active-log buttons
	assign rst = ~rst_btn;
	assign go = ~go_btn;

	// Clock divider
	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			clk_count <= 24'b0;
		end else if (clk_count == MAX_CLK_COUNT) begin
			clk_count <= 24'b0;
			div_clk <= ~div_clk;
		end else begin
			clk_count <= clk_count + 1;
		end
	end


	// State transition logic
	always @ (posedge div_clk, posedge rst) begin
		if (rst == 1'b1) begin
			state <= STATE_IDLE;
		end else begin
			case (state)
				// Wait for go button to be pressed
				STATE_IDLE: begin
					done_sig <= 1'b0;
					if (go == 1'b1) begin
						state <= STATE_COUNTING;
					end
				end

				// Go for countingb to done if counting reaches max
				STATE_COUNTING: begin
					if (led == MAX_LED_COUNT) begin
						done_sig <= 1'b1;
						state <= STATE_IDLE;
					end
				end

				// Go idle if in unknown state
				default: begin
					state <= STATE_IDLE;
				end
			endcase
		end
	end

	// Handle LED counter
	always @ (posedge div_clk, posedge rst) begin
		if (rst == 1'b1) begin
			led <= 4'd0;
		end else begin
			if (state == STATE_COUNTING) begin
				led <= led + 1;
			end else begin
				led <= 0;
			end
		end
	end

endmodule

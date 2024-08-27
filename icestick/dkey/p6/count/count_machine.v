module count_machine #(
	// Parameters
	parameter			COUNT_WIDTH	= 4,
	parameter [COUNT_WIDTH-1:0]	COUNT_START	= 0,
	parameter [COUNT_WIDTH-1:0]	COUNT_END	= 15,
	parameter [COUNT_WIDTH-1:0]	COUNT_INCR	= 1
)(
	// Inputs
	input				clk,
	input				clk_enable,
	input				rst,
	input				start,

	// Outputs
	output reg [COUNT_WIDTH-1:0]	out,
	output reg			out_valid,
	output reg			out_last
);

	// States
	localparam	STATE_IDLE	= 2'b0;
	localparam	STATE_COUNTING	= 2'b1;


	reg [1:0] state;

	always @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			out <= 0;
			out_valid<= 0;
			out_last <= 0;
			state <= STATE_IDLE;
		end else if (clk_enable) begin
			case (state)
				STATE_IDLE: begin
					if (start) begin
						out <= COUNT_START;
						out_valid <= 1;
						out_last <= (COUNT_START == COUNT_END);
						state <= (COUNT_START == COUNT_END) ? STATE_IDLE : STATE_COUNTING;
					end else begin
						out <= 0;
						out_valid<= 0;
						out_last <= 0;
						state <= STATE_IDLE;
					end
				end
				STATE_COUNTING: begin
					out <= out + COUNT_INCR;
					out_valid <= 1;
					out_last <= (out + COUNT_INCR == COUNT_END);
					state <= (out + COUNT_INCR == COUNT_END) ? STATE_IDLE : STATE_COUNTING;
				end
				default: begin
					out <= 0;
					out_valid<= 0;
					out_last <= 0;
					state <= STATE_IDLE;
				end
			endcase
		end
	end
endmodule

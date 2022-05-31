`default_nettype none

module uart_rx(
	input wire		clk,		// domain clock
	input wire		rx_clk,		// baud clock
	input wire		enabled,
	input wire		rx,		// rx pin

	output reg [7:0]	data,		// rcvd data
	output reg		err,		// err rcvd data
	output reg		done,		// rcvd data ready
	output reg		busy		// rcving  data
);

	localparam STATE_RX_IDLE	= 2'b00;
	localparam STATE_RX_START_BIT	= 2'b01;
	localparam STATE_RX_DATA_BITS	= 2'b10;
	localparam STATE_RX_STOP_BIT	= 2'b11;

	reg [1:0] state = STATE_RX_IDLE;

	reg [2:0] bit_index = 0;
	reg [3:0] clock_count = 0;

	always @(posedge clk) begin
		if (rx_clk) begin
			case (state)
				STATE_RX_IDLE: begin
					data <= 8'b0;
					done <= 0;
					err <= 0;
					busy <= 0;

					bit_index <= 0;
					clock_count <= 0;

					if (enabled && rx == 0) begin
						busy <= 1;
						state <= STATE_RX_START_BIT;
					end
				end

				STATE_RX_START_BIT: begin
					if (clock_count == 4'b0111) begin
						if (rx == 0) begin
							clock_count <= 0;
							state <= STATE_RX_DATA_BITS;
						end else begin
							err <= 1;
							state <= STATE_RX_IDLE;
						end
					end else begin
						clock_count <= clock_count + 1;
					end
				end


				STATE_RX_DATA_BITS: begin
					if (clock_count == 4'b1111) begin
						clock_count <= 0;
						data[bit_index] <= rx;
						bit_index <= bit_index + 1;
						if (bit_index == 3'b111) begin
							state <= STATE_RX_STOP_BIT;
						end
					end else begin
						clock_count <= clock_count + 1;
					end
				end

				STATE_RX_STOP_BIT: begin
					if (clock_count == 4'b1111) begin
						if (rx == 1) begin
							done <= 1;
							state <= STATE_RX_IDLE;
						end else begin
							err <= 1;
							state <= STATE_RX_IDLE;
						end
					end else begin
						clock_count <= clock_count + 1;
					end
				end
			endcase
		end
	end

endmodule

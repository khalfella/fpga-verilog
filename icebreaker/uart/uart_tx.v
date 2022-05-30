

module uart_tx(
	input wire		clk,		// Domain clock
	input wire		tx_clk,		// Baud clock
	input wire		enabled,
	input wire		start,		// Start transmission
	input wire [7:0]	in,		// Data to transmit
	
	output reg		tx,		// output TX pin
	output reg		done,		// done transmitting
	output reg		busy		// transmitting data
);

	localparam STATE_TX_IDLE	= 2'b00;
	localparam STATE_TX_START_BIT	= 2'b01;
	localparam STATE_TX_DATA_BITS	= 2'b10;
	localparam STATE_TX_STOP_BIT	= 2'b11;

	reg [1:0] state = STATE_TX_IDLE;

	reg [2:0] bit_index = 0;
	reg [7:0] data = 0;

	always @(posedge clk) begin
		if (tx_clk) begin
			case (state)
				STATE_TX_IDLE: begin
					tx <= 1;
					done <= 0;
					busy <= 0;
					bit_index <= 0;
					data <= 0;

					if (start && enabled) begin
						data <= in;
						state <= STATE_TX_START_BIT;
					end
				end

				STATE_TX_START_BIT: begin
					busy <= 1;
					tx <= 0;
					state <= STATE_TX_DATA_BITS;
				end


				STATE_TX_DATA_BITS: begin
					tx <= data[bit_index];
					bit_index <= bit_index + 1;
					if (bit_index == 7) begin
						done <= 1;
						state <= STATE_TX_STOP_BIT;
					end
				end

				STATE_TX_STOP_BIT: begin
					done <= 0;
					tx <= 1;
					state <= STATE_TX_IDLE;
				end
			endcase
		end
	end

endmodule

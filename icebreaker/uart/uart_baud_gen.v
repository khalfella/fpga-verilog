`default_nettype none

module uart_baud_gen #(
	parameter	CLOCK_RATE	= 42000000,	/* Def. 42MHz */
	parameter	BAUD_RATE	= 115200	/* Def. 115200 */
) (
	input wire		clk,			/* Input clock @CLOCK_RATE */
	input wire		rst,			/* Async reset signal */
	output wire		rx_clk,			/* RX clock @16xBAUD_RATE */
	output wire		tx_clk			/* TX clock @BAUD_RATE */
);
	localparam MAX_RATE_RX = CLOCK_RATE / (BAUD_RATE * 16);
	localparam MAX_RATE_TX = CLOCK_RATE / (BAUD_RATE);
	localparam RX_CNT_WDTH = $clog2(MAX_RATE_RX);
	localparam TX_CNT_WDTH = $clog2(MAX_RATE_TX);


	reg [RX_CNT_WDTH - 1:0] rx_counter = 0;
	reg [TX_CNT_WDTH - 1:0] tx_counter = 0;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			rx_counter = 0;
			tx_counter = 0;
		end else begin
			rx_counter <= (rx_counter == MAX_RATE_RX - 1) ? 0 : rx_counter + 1;
			tx_counter <= (tx_counter == MAX_RATE_TX - 1) ? 0 : tx_counter + 1;
		end
	end

	assign rx_clk = (rx_counter == MAX_RATE_RX - 1) ? 1'b1 : 1'b0;
	assign tx_clk = (tx_counter == MAX_RATE_TX - 1) ? 1'b1 : 1'b0;
	
endmodule
